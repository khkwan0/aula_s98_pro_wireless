#!/usr/bin/env bash
# Print Cloudflare DNS steps / optionally create records via API.
# Requires: CLOUDFLARE_API_TOKEN with Zone.DNS Edit (and Zone.Zone Read).
# Usage:
#   export CLOUDFLARE_API_TOKEN=...
#   bash www/ci/cloudflare-dns.sh
set -euo pipefail

DOMAIN="${DOMAIN:-nitroxstudios.com}"
TARGET_IP="${TARGET_IP:-72.61.127.13}"
API="https://api.cloudflare.com/client/v4"

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  cat <<EOF
CLOUDFLARE_API_TOKEN is not set.

Current public DNS for ${DOMAIN} is on Google Domains nameservers
(ns-cloud-c*.googledomains.com), not Cloudflare yet.

Option A — Move the zone to Cloudflare (dashboard):
  1. https://dash.cloudflare.com → Add site → ${DOMAIN}
  2. Choose Free plan
  3. Replace the domain's nameservers at Google Domains / Squarespace
     with the two Cloudflare NS values shown
  4. In Cloudflare DNS, create:
       Type  Name  Content          Proxy
       A     @     ${TARGET_IP}     DNS only (grey cloud)  ← needed for HTTP-01 LE
       A     www   ${TARGET_IP}     DNS only (grey cloud)
  5. Wait for NS propagation, then run:
       sudo bash www/ci/setup-host-nginx.sh

Option B — Keep Google Domains DNS:
  Set A records for @ and www → ${TARGET_IP}, then run setup-host-nginx.sh

Option C — Automate records after the zone is on Cloudflare:
  export CLOUDFLARE_API_TOKEN=...   # Zone:DNS:Edit + Zone:Zone:Read
  bash www/ci/cloudflare-dns.sh
EOF
  exit 1
fi

auth_hdr=( -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" -H "Content-Type: application/json" )

echo "==> resolve zone id for ${DOMAIN}"
ZONE_JSON="$(curl -fsS "${auth_hdr[@]}" "${API}/zones?name=${DOMAIN}")"
ZONE_ID="$(python3 -c 'import json,sys; d=json.load(sys.stdin); r=d.get("result") or []; print(r[0]["id"] if r else "")' <<<"$ZONE_JSON")"
if [[ -z "$ZONE_ID" ]]; then
  echo "Zone ${DOMAIN} not found in this Cloudflare account. Add the site in the dashboard first."
  echo "API says: $ZONE_JSON"
  exit 1
fi
echo "    zone id: $ZONE_ID"

upsert_a() {
  local name="$1"
  local fqdn="$2"
  echo "==> upsert A ${fqdn} → ${TARGET_IP} (DNS only)"
  EXISTING="$(curl -fsS "${auth_hdr[@]}" "${API}/zones/${ZONE_ID}/dns_records?type=A&name=${fqdn}")"
  RID="$(python3 -c 'import json,sys; d=json.load(sys.stdin); r=d.get("result") or []; print(r[0]["id"] if r else "")' <<<"$EXISTING")"
  BODY="$(python3 -c "import json; print(json.dumps({'type':'A','name':'${name}','content':'${TARGET_IP}','ttl':300,'proxied':False}))")"
  if [[ -n "$RID" ]]; then
    curl -fsS -X PUT "${auth_hdr[@]}" "${API}/zones/${ZONE_ID}/dns_records/${RID}" --data "$BODY" >/dev/null
    echo "    updated $RID"
  else
    curl -fsS -X POST "${auth_hdr[@]}" "${API}/zones/${ZONE_ID}/dns_records" --data "$BODY" >/dev/null
    echo "    created"
  fi
}

upsert_a "@" "$DOMAIN"
upsert_a "www" "www.${DOMAIN}"

echo "DNS records upserted (grey cloud). After propagation:"
echo "  dig +short ${DOMAIN} A   # expect ${TARGET_IP}"
echo "  sudo bash $(cd "$(dirname "$0")" && pwd)/setup-host-nginx.sh"
