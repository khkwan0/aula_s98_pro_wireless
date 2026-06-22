#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter SDK not found."
  echo "Install from https://docs.flutter.dev/get-started/install"
  exit 1
fi

echo "Generating desktop platform folders..."
flutter create --project-name aula_desktop --org com.aula --platforms=macos,windows,linux .

echo "Fetching Dart dependencies..."
flutter pub get

echo "Generating platform app icons..."
dart run tool/generate_icons.dart

cat <<'EOF'

Setup complete.

Run the app:
  cd aula_desktop
  flutter run -d macos

hidapi is vendored in native/hidapi/ and bundled automatically at build time.
No Homebrew or system hidapi install is required.

EOF
