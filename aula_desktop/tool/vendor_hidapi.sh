#!/usr/bin/env bash
# Rebuild vendored hidapi binaries (maintainers only).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="hidapi-0.15.0"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth 1 --branch "$VERSION" https://github.com/libusb/hidapi.git "$TMP/hidapi"

mkdir -p "$ROOT/native/hidapi/macos" "$ROOT/native/hidapi/windows/x64"

if [[ "$(uname)" == "Darwin" ]]; then
  OUT="$ROOT/native/hidapi/macos"
  for ARCH in arm64 x86_64; do
    clang -I"$TMP/hidapi/hidapi" -I"$TMP/hidapi/mac" \
      -arch "$ARCH" -Wall -O2 -fvisibility=hidden \
      -dynamiclib "$TMP/hidapi/mac/hid.c" \
      -framework IOKit -framework CoreFoundation \
      -install_name @rpath/libhidapi.dylib \
      -o "$OUT/libhidapi-$ARCH.dylib"
  done
  lipo -create "$OUT/libhidapi-arm64.dylib" "$OUT/libhidapi-x86_64.dylib" \
    -output "$OUT/libhidapi.dylib"
  rm -f "$OUT/libhidapi-arm64.dylib" "$OUT/libhidapi-x86_64.dylib"
  echo "Built $OUT/libhidapi.dylib ($(lipo -info "$OUT/libhidapi.dylib"))"
fi

curl -fsSL -o "$TMP/hidapi-win.zip" \
  "https://github.com/libusb/hidapi/releases/download/${VERSION}/hidapi-win.zip"
unzip -q "$TMP/hidapi-win.zip" -d "$TMP/win"
cp "$TMP/win/x64/hidapi.dll" "$ROOT/native/hidapi/windows/x64/hidapi.dll"
echo "Copied $ROOT/native/hidapi/windows/x64/hidapi.dll"

echo "$VERSION" | sed 's/hidapi-//' > "$ROOT/native/hidapi/VERSION"
echo "Done."
