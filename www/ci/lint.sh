#!/usr/bin/env bash
# Lint stage: structural + SEO checks (no third-party SaaS).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PUBLIC="$ROOT/public"
FAIL=0

ok() { printf '  OK  %s\n' "$1"; }
bad() { printf ' FAIL %s\n' "$1"; FAIL=1; }

echo "==> lint: required files"
for f in index.html privacy.html 404.html robots.txt sitemap.xml \
         assets/css/site.css assets/js/site.js \
         assets/img/icon-256.png assets/screenshots/screen_0.png; do
  if [[ -f "$PUBLIC/$f" ]]; then ok "$f"; else bad "missing $f"; fi
done

echo "==> lint: SEO markers in index.html"
INDEX="$PUBLIC/index.html"
for needle in \
  '<title>' \
  'name="description"' \
  'rel="canonical"' \
  'property="og:title"' \
  'application/ld+json' \
  'AULA.S98.Pro.dmg' \
  'name="twitter:card"'; do
  if grep -q "$needle" "$INDEX"; then ok "index has $needle"; else bad "index missing $needle"; fi
done

echo "==> lint: robots + sitemap consistency"
if grep -q 'Sitemap: https://nitroxstudios.com/aula/sitemap.xml' "$PUBLIC/robots.txt"; then
  ok "robots.txt declares absolute Sitemap URL"
else
  bad "robots.txt missing absolute Sitemap URL"
fi
if grep -q '<urlset' "$PUBLIC/sitemap.xml"; then ok "sitemap.xml has urlset"; else bad "sitemap.xml invalid"; fi
if grep -q '<lastmod>' "$PUBLIC/sitemap.xml"; then ok "sitemap has lastmod"; else bad "sitemap missing lastmod"; fi
if grep -q 'xmlns:image=' "$PUBLIC/sitemap.xml"; then ok "sitemap has image namespace"; else bad "sitemap missing image namespace"; fi
if grep -q 'privacy.html' "$PUBLIC/sitemap.xml"; then ok "sitemap lists privacy"; else bad "sitemap missing privacy"; fi
if grep -q 'screen_0.png' "$PUBLIC/sitemap.xml"; then ok "sitemap lists hero screenshot"; else bad "sitemap missing screenshot images"; fi
BASE='https://nitroxstudios.com/aula'
for path in '/' '/privacy.html'; do
  if grep -q "<loc>${BASE}${path}</loc>" "$PUBLIC/sitemap.xml"; then
    ok "sitemap loc ${path}"
  else
    bad "sitemap missing loc ${path}"
  fi
done

echo "==> lint: no accidental secrets"
if grep -RInE '(api[_-]?key|secret|password)\s*[:=]' "$PUBLIC" --include='*.html' --include='*.js' --include='*.css' >/dev/null 2>&1; then
  bad "possible secret pattern in public assets"
else
  ok "no obvious secrets in public assets"
fi

if [[ "$FAIL" -ne 0 ]]; then
  echo "lint failed"
  exit 1
fi
echo "lint passed"
