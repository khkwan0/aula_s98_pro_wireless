#!/usr/bin/env bash
# One-time setup on the deploy host: bare git remote + post-receive CI hook.
# Usage: bash www/ci/install-remote.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GIT_DIR="${GIT_DIR:-/home/ken/git/aula_s98_pro_wireless.git}"
DEPLOY_ROOT="${DEPLOY_ROOT:-$REPO_ROOT}"

echo "==> creating bare repo at $GIT_DIR"
mkdir -p "$(dirname "$GIT_DIR")"
if [[ ! -d "$GIT_DIR" ]]; then
  git init --bare "$GIT_DIR"
else
  echo "    bare repo already exists"
fi

echo "==> installing post-receive hook"
install -m 0755 "$REPO_ROOT/www/hooks/post-receive" "$GIT_DIR/hooks/post-receive"

# Bake absolute paths into the installed hook via a tiny wrapper env file
cat > "$GIT_DIR/hooks/post-receive.env" <<EOF
export DEPLOY_ROOT="$DEPLOY_ROOT"
export GIT_DIR="$GIT_DIR"
EOF

# Wrap hook so env is loaded
cat > "$GIT_DIR/hooks/post-receive" <<EOF
#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$GIT_DIR/hooks/post-receive.env"
exec bash "$DEPLOY_ROOT/www/hooks/post-receive"
EOF
chmod 0755 "$GIT_DIR/hooks/post-receive"

# Keep a copy of the real hook script path stable: point DEPLOY_ROOT checkout
# to use the repo's www/hooks/post-receive after first push. For bootstrap,
# install the script body directly as well.
install -m 0755 "$REPO_ROOT/www/hooks/post-receive" "$GIT_DIR/hooks/post-receive.impl"
cat > "$GIT_DIR/hooks/post-receive" <<EOF
#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=SC1091
source "$GIT_DIR/hooks/post-receive.env"
exec bash "$GIT_DIR/hooks/post-receive.impl"
EOF
chmod 0755 "$GIT_DIR/hooks/post-receive"

echo "==> making CI scripts executable"
chmod +x "$REPO_ROOT"/www/ci/*.sh "$REPO_ROOT"/www/hooks/post-receive

echo
echo "Remote install complete."
echo "Add deploy remote from your workstation:"
echo "  git remote add mala ken@mala:$GIT_DIR"
echo "  git push mala main"
echo
echo "Or run the pipeline manually on this host:"
echo "  bash $REPO_ROOT/www/ci/pipeline.sh all"
