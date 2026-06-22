#!/bin/sh
set -e

DEST="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "$DEST"

VENDORED="${PROJECT_DIR}/../native/hidapi/macos/libhidapi.dylib"
if [ -f "$VENDORED" ]; then
  cp -f "$VENDORED" "$DEST/libhidapi.dylib"
  codesign --force --sign - "$DEST/libhidapi.dylib" 2>/dev/null || true
  echo "Copied vendored hidapi from $VENDORED"
  exit 0
fi

echo "error: vendored hidapi not found at $VENDORED"
exit 1
