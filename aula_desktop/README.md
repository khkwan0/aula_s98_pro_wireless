# AULA S98 Pro — Desktop GUI

Standalone Flutter desktop app with the keyboard HID protocol **reimplemented in Dart**. This does not use or wrap the Node.js CLI in the parent directory — that code is only the reference for protocol behavior.

## Features

- **Device status** — detect USB control and LCD interfaces
- **Clock sync** — system time or custom date/time
- **RGB lighting** — all 20 modes, color picker, brightness/speed/direction
- **LCD upload** — GIF → RGB565 conversion and upload with 141-frame safety cap

## Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) with desktop enabled
- AULA S98 Pro connected over **USB** (not Bluetooth-only)
- Close the official AULA utility while using this app

**No Homebrew or system hidapi install is needed** — the native HID library is vendored in `native/hidapi/` and copied into the app at build time.

## Setup

```bash
cd aula_desktop
chmod +x setup.sh
./setup.sh
```

If platform folders already exist, you can instead run:

```bash
flutter pub get
```

## Run

```bash
flutter run -d macos
# or
flutter run -d windows
flutter run -d linux
```

## Architecture

```
lib/
  hid/           FFI bindings to hidapi + device open/enumerate
  protocol/      Clock, lighting, LCD conversion & upload (mirrors Node reference)
  services/      KeyboardService facade for UI
  screens/       Flutter desktop UI
native/hidapi/   Vendored hidapi binaries (macOS, Windows; Linux optional)
```

Protocol constants and packet layouts match:

- `../device.js` — USB interfaces, feature reports
- `../index.js` — clock & lighting commands
- `../lcd.js` — GIF conversion & LCD page upload

## Safety

LCD uploads enforce a **141 frame** limit by default (same as AULA Windows software). Exceeding this can corrupt on-keyboard menu graphics stored in SPI flash. Use **Force upload** only if you understand the risk.

## Build release

```bash
flutter build macos
flutter build windows
flutter build linux
```

Output is under `build/macos/Build/Products/Release/` (macOS).

## Maintainers

To refresh vendored hidapi binaries (hidapi 0.15.0):

```bash
chmod +x tool/vendor_hidapi.sh
./tool/vendor_hidapi.sh
```
