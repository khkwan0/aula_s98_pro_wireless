/// Protocol constants mirrored from the Node.js reference implementation.
class KeyboardConstants {
  static const String fallbackDeviceName = 'Aula S98 Pro Wireless';

  static const int vendorId = 0x0C45;
  static const int productId = 0x800A;
  static const int controlUsagePage = 0xFF13; // 65299
  static const int lcdUsagePage = 0xFF68; // 65384
  static const int lcdInterface = 2;

  static const int reportSize = 64;
  static const int cmdDelayMs = 35;

  static const int screenWidth = 240;
  static const int screenHeight = 135;
  static const int bytesPerPixel = 2;
  static const int frameSize = screenWidth * screenHeight * bytesPerPixel;
  static const int headerSize = 256;
  static const int pageSize = 4096;
  static const int maxFrames = 60;
  static const int lcdAckTimeoutMs = 300;
}

const lightingModeNames = [
  'Off',
  'Static',
  'SingleOn',
  'SingleOff',
  'Glittering',
  'Falling',
  'Colourful',
  'Breath',
  'Spectrum',
  'Outward',
  'Scrolling',
  'Rolling',
  'Rotating',
  'Explode',
  'Launch',
  'Ripples',
  'Flowing',
  'Pulsating',
  'Tilt',
  'Shuttle',
];

const lightingModeKeys = {
  'off': 0,
  'static': 1,
  'singleon': 2,
  'singleoff': 3,
  'glittering': 4,
  'falling': 5,
  'colourful': 6,
  'colorful': 6,
  'breath': 7,
  'spectrum': 8,
  'outward': 9,
  'scrolling': 10,
  'rolling': 11,
  'rotating': 12,
  'explode': 13,
  'launch': 14,
  'ripples': 15,
  'flowing': 16,
  'pulsating': 17,
  'tilt': 18,
  'shuttle': 19,
};

int resolveLightingMode(dynamic modeArg) {
  if (modeArg == null) {
    throw ArgumentError('Lighting mode is required.');
  }
  if (modeArg is int && modeArg >= 0 && modeArg <= 19) {
    return modeArg;
  }
  final key = modeArg.toString().toLowerCase();
  final mode = lightingModeKeys[key];
  if (mode == null) {
    throw ArgumentError('Unknown lighting mode: $modeArg');
  }
  return mode;
}
