#!/usr/bin/env bash
# Full self-hosted CI/CD pipeline: lint → test → deploy.
# Intended to run on the deploy host (e.g. mala). No third-party CI services.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

STAGE="${1:-all}"

run_lint() { bash "$ROOT/ci/lint.sh"; }
run_test() { bash "$ROOT/ci/test.sh"; }
run_deploy() { bash "$ROOT/ci/deploy.sh"; }

case "$STAGE" in
  lint) run_lint ;;
  test) run_test ;;
  deploy) run_deploy ;;
  all)
    run_lint
    run_test
    run_deploy
    ;;
  *)
    echo "usage: $0 [all|lint|test|deploy]"
    exit 2
    ;;
esac
