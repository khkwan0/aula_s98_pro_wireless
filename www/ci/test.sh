#!/usr/bin/env bash
# Test stage: build image and smoke-test HTTP responses locally via Docker.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

IMAGE="aula-s98-www:ci-test"
NAME="aula-s98-www-ci-test-$$"

cleanup() {
  docker rm -f "$NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "==> test: docker build"
docker build -t "$IMAGE" .

echo "==> test: run container"
docker run -d --name "$NAME" -p 18098:80 "$IMAGE" >/dev/null

echo "==> test: wait for healthy HTTP"
for i in $(seq 1 30); do
  if curl -fsS "http://127.0.0.1:18098/" >/dev/null 2>&1; then
    break
  fi
  sleep 0.5
  if [[ "$i" -eq 30 ]]; then
    echo "container did not become ready"
    docker logs "$NAME" || true
    exit 1
  fi
done

echo "==> test: HTTP status checks"
for path in / /privacy.html /robots.txt /sitemap.xml /assets/css/site.css; do
  code="$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:18098$path")"
  if [[ "$code" != "200" ]]; then
    echo " FAIL $path -> $code"
    exit 1
  fi
  echo "  OK  $path -> $code"
done

BODY="$(curl -fsS http://127.0.0.1:18098/)"
echo "$BODY" | grep -q 'AULA S98 Pro' || { echo "FAIL home missing brand"; exit 1; }
echo "$BODY" | grep -q 'AULA.S98.Pro.dmg' || { echo "FAIL home missing download link"; exit 1; }
echo "  OK  home content assertions"

echo "test passed"
