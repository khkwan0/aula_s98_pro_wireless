import '../hid/hid_device.dart';
import 'constants.dart';
import 'device_protocol.dart';

class LightingResult {
  const LightingResult({
    required this.modeId,
    required this.modeName,
    required this.r,
    required this.g,
    required this.b,
    required this.brightness,
    required this.speed,
    required this.direction,
    required this.colorful,
  });

  final int modeId;
  final String modeName;
  final int r;
  final int g;
  final int b;
  final int brightness;
  final int speed;
  final int direction;
  final bool colorful;
}

Future<LightingResult> setLighting({
  required dynamic mode,
  int r = 255,
  int g = 255,
  int b = 255,
  int brightness = 5,
  int speed = 3,
  int direction = 0,
  bool colorful = false,
}) async {
  final modeId = resolveLightingMode(mode);
  if (brightness < 0 || brightness > 5) {
    throw ArgumentError('Brightness must be 0-5.');
  }
  if (speed < 0 || speed > 5) {
    throw ArgumentError('Speed must be 0-5.');
  }

  final device = HidDevice.openControl();
  try {
    await beginTransaction(device);
    await lightingInit(device);

    final payload = emptyReport();
    payload[0] = modeId;
    if (modeId != 0) {
      payload[1] = r;
      payload[2] = g;
      payload[3] = b;
      payload[8] = colorful ? 1 : 0;
      payload[9] = brightness;
      payload[10] = speed;
      payload[11] = direction;
    }
    payload[14] = 0x55;
    payload[15] = 0xAA;
    await sendCommand(device, payload, readback: false);

    await applyTransaction(device);
    await finalizeTransaction(device);

    return LightingResult(
      modeId: modeId,
      modeName: lightingModeNames[modeId],
      r: r,
      g: g,
      b: b,
      brightness: brightness,
      speed: speed,
      direction: direction,
      colorful: colorful,
    );
  } finally {
    device.close();
  }
}
