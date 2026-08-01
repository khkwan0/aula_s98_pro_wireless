#!/usr/bin/env bash
# Install host nginx vhost for nitroxstudios.com and obtain a Let's Encrypt cert.
# Run on mala as a user with sudo:  sudo bash www/ci/setup-host-nginx.sh
set -euo pipefail

DOMAIN="${DOMAIN:-nitroxstudios.com}"
WWW_PORT="${WWW_PORT:-8098}"
REPO_WWW="$(cd "$(dirname "$0")/.." && pwd)"
SITE_SRC="$REPO_WWW/nginx/nitroxstudios.com.conf"
SITE_AVAIL="/etc/nginx/sites-available/${DOMAIN}.conf"
SITE_ENABLED="/etc/nginx/sites-enabled/${DOMAIN}.conf"
EMAIL="${CERTBOT_EMAIL:-admin@${DOMAIN}}"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root: sudo bash $0"
  exit 1
fi

if [[ ! -f "$SITE_SRC" ]]; then
  echo "Missing $SITE_SRC"
  exit 1
fi

echo "==> ensure Docker site is up on :${WWW_PORT}"
if ! curl -fsS "http://127.0.0.1:${WWW_PORT}/" >/dev/null; then
  echo "Container not responding on :${WWW_PORT}. Start it first:"
  echo "  bash $REPO_WWW/ci/deploy.sh"
  exit 1
fi

echo "==> install nginx site (HTTP first, for ACME)"
install -d -m 0755 /var/www/certbot
install -m 0644 "$SITE_SRC" "$SITE_AVAIL"
ln -sfn "$SITE_AVAIL" "$SITE_ENABLED"

# Disable broken stub blocks for this domain inside the monolithic default file
DEFAULT="/etc/nginx/sites-enabled/default"
if [[ -f "$DEFAULT" ]] && grep -q "server_name ${DOMAIN};" "$DEFAULT"; then
  BACKUP="/etc/nginx/sites-enabled/default.bak.aula-$(date +%Y%m%d%H%M%S)"
  cp -a "$DEFAULT" "$BACKUP"
  echo "    backed up default → $BACKUP"
  python3 - <<'PY'
from pathlib import Path
import re
path = Path("/etc/nginx/sites-enabled/default")
text = path.read_text()
domain = "nitroxstudios.com"
# Comment out server blocks whose server_name includes nitroxstudios.com
parts = re.split(r'(?=\nserver\s*\{)', text)
out = []
for part in parts:
    if re.search(r'server_name[^;]*\bnitroxstudios\.com\b', part):
        commented = "\n".join(
            (line if line.startswith("#") or not line.strip() else "# AULA-DISABLED " + line)
            for line in part.splitlines()
        )
        # keep leading newline style
        if part.startswith("\n"):
            commented = "\n" + commented.lstrip("\n")
        out.append(commented)
    else:
        out.append(part)
path.write_text("".join(out))
print("    disabled legacy nitroxstudios.com server blocks in default")
PY
fi

nginx -t
systemctl reload nginx

echo "==> issue/renew Let's Encrypt certificate (nginx plugin)"
certbot --nginx \
  -d "$DOMAIN" \
  -d "www.${DOMAIN}" \
  --non-interactive \
  --agree-tos \
  -m "$EMAIL" \
  --redirect \
  --keep-until-expiring

nginx -t
systemctl reload nginx

echo "==> verify"
curl -fsSI "https://${DOMAIN}/" | head -15 || true
echo "Done. https://${DOMAIN}/ → 127.0.0.1:${WWW_PORT}"
