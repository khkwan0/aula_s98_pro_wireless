#!/usr/bin/env bash
# Deploy stage: build and roll the production compose service on this host.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export WWW_PORT="${WWW_PORT:-8098}"

echo "==> deploy: docker compose up (port ${WWW_PORT})"
docker compose build web
docker compose up -d --remove-orphans web

echo "==> deploy: verify"
sleep 1
curl -fsS "http://127.0.0.1:${WWW_PORT}/aula/" | grep -q 'AULA S98 Pro'
curl -fsS -o /dev/null -w "home %{http_code}\n" "http://127.0.0.1:${WWW_PORT}/aula/"
echo "deploy complete → http://127.0.0.1:${WWW_PORT}/aula/"
