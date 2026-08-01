#!/usr/bin/env bash
# Fix host nginx so /aula/ strips the prefix before proxying to Docker :8098.
# Usage: sudo bash www/ci/fix-aula-proxy.sh
set -euo pipefail

CONF="${NGINX_CONF:-/etc/nginx/sites-available/nitroxstudios.com.conf}"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root: sudo bash $0"
  exit 1
fi

python3 - "$CONF" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
text = path.read_text()

# Normalize any broken /aula proxy variants to the correct strip-prefix form
import re
pattern = re.compile(
    r"\n    location = /aula \{.*?\n    \}\n\n    location /aula/? \{.*?\n    \}"
    r"|\n    location /aula/? \{.*?\n    \}",
    re.S,
)
replacement = """
    location = /aula {
        return 301 /aula/;
    }

    location /aula/ {
        proxy_pass http://127.0.0.1:8098/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }"""

new, n = pattern.subn(replacement, text, count=1)
if n != 1:
    raise SystemExit(f"could not find location /aula block in {path} (matches={n})")
path.write_text(new)
print(f"patched {path}")
PY

nginx -t
systemctl reload nginx
echo "verify:"
curl -s -o /dev/null -w "  /aula/ -> %{http_code}\n" https://nitroxstudios.com/aula/
curl -s -o /dev/null -w "  css    -> %{http_code}\n" https://nitroxstudios.com/aula/assets/css/site.css
