#!/usr/bin/env bash
# One-time: secret env + user systemd unit for the GitHub webhook listener.
# Usage: bash www/ci/install-webhook.sh
# Does not require sudo. Host nginx vhost still needs: sudo bash www/ci/setup-host-nginx.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CI_DIR="$REPO_ROOT/www/ci"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/aula-s98-www"
ENV_FILE="$CONFIG_DIR/webhook.env"
UNIT_SRC="$CI_DIR/aula-s98-www-webhook.service"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
UNIT_DST="$UNIT_DIR/aula-s98-www-webhook.service"
DOMAIN="${DOMAIN:-nitroxstudios.com}"
HOOK_PATH="/hooks/github/aula-www"

chmod +x "$CI_DIR"/github-webhook.py "$CI_DIR"/on-github-push.sh "$CI_DIR"/pipeline.sh \
  "$CI_DIR"/lint.sh "$CI_DIR"/test.sh "$CI_DIR"/deploy.sh "$CI_DIR"/install-webhook.sh

mkdir -p "$CONFIG_DIR" "$UNIT_DIR"
chmod 700 "$CONFIG_DIR"

if [[ ! -f "$ENV_FILE" ]]; then
  SECRET="$(openssl rand -hex 32)"
  cat > "$ENV_FILE" <<EOF
WEBHOOK_SECRET=$SECRET
WEBHOOK_HOST=127.0.0.1
WEBHOOK_PORT=9001
DEPLOY_ROOT=$REPO_ROOT
DEPLOY_SCRIPT=$CI_DIR/on-github-push.sh
WEBHOOK_BRANCH_REF=refs/heads/main
EOF
  chmod 600 "$ENV_FILE"
  echo "==> created $ENV_FILE"
else
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  SECRET="${WEBHOOK_SECRET:?WEBHOOK_SECRET missing in $ENV_FILE}"
  echo "==> reusing $ENV_FILE"
fi

# Bake absolute paths for this checkout into the user unit
sed \
  -e "s|%h/dev/aula_s98_pro_wireless|$REPO_ROOT|g" \
  -e "s|WorkingDirectory=.*|WorkingDirectory=$CI_DIR|" \
  -e "s|EnvironmentFile=.*|EnvironmentFile=$ENV_FILE|" \
  -e "s|ExecStart=.*|ExecStart=/usr/bin/python3 $CI_DIR/github-webhook.py|" \
  "$UNIT_SRC" > "$UNIT_DST"

systemctl --user daemon-reload
systemctl --user enable --now aula-s98-www-webhook.service
systemctl --user restart aula-s98-www-webhook.service

sleep 0.5
if curl -fsS "http://127.0.0.1:9001/healthz" >/dev/null; then
  echo "==> webhook listener healthy on 127.0.0.1:9001"
else
  echo "ERROR: webhook listener not responding"
  systemctl --user status aula-s98-www-webhook.service --no-pager || true
  exit 1
fi

echo
echo "Webhook install complete (user systemd)."
echo
echo "Still needed on this host (run in a terminal with sudo):"
echo "  sudo bash $REPO_ROOT/www/ci/setup-host-nginx.sh"
echo "  sudo loginctl enable-linger $USER"
echo
echo "Create a GitHub webhook (Settings → Webhooks → Add webhook):"
echo "  Payload URL:  https://${DOMAIN}${HOOK_PATH}"
echo "  Content type: application/json"
echo "  Secret:       (from $ENV_FILE — WEBHOOK_SECRET=...)"
echo "  Events:       Just the push event"
echo "  Active:       checked"
echo
echo "  grep WEBHOOK_SECRET $ENV_FILE"
echo
echo "Deploy logs:  ~/.local/share/aula-s98-www/deploy.log"
echo "Service logs: journalctl --user -u aula-s98-www-webhook -f"
