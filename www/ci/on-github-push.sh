#!/usr/bin/env bash
# Called by github-webhook.py after a verified push to main.
# Pulls latest main and runs the local lint → test → deploy pipeline.
set -euo pipefail

DEPLOY_ROOT="${DEPLOY_ROOT:-/home/ken/dev/aula_s98_pro_wireless}"
LOCK_FILE="${LOCK_FILE:-/tmp/aula-s98-www-deploy.lock}"
BRANCH="${WEBHOOK_BRANCH:-main}"
LOG_DIR="${LOG_DIR:-/home/ken/.local/share/aula-s98-www}"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/deploy.log"

exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  echo "$(date -Is) deploy already running; skipping" | tee -a "$LOG_FILE"
  exit 0
fi

{
  echo "==== $(date -Is) deploy start ===="
  cd "$DEPLOY_ROOT"
  git fetch origin "$BRANCH"
  git reset --hard "origin/$BRANCH"
  bash "$DEPLOY_ROOT/www/ci/pipeline.sh" all
  echo "==== $(date -Is) deploy done ===="
} 2>&1 | tee -a "$LOG_FILE"
