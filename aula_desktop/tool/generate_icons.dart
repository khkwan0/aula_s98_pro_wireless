// Generates platform app icons from the app Material 3 theme.
// Full-bleed opaque squares for macOS 26 Tahoe (edge alpha must be 255).
// Run: dart run tool/generate_icons.dart

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

// Matches ThemeData seedColor in lib/app.dart (Material 3 dark).
final _seed = img.ColorRgb8(103, 80, 164); // #6750A4
final _container = img.ColorRgb8(79, 55, 139); // #4F378B
final _onContainer = img.ColorRgb8(232, 222, 248); // #E8DEF8

void main() {
  final master = _renderIcon(1024);
  _writeMacosIcons(master);
  _writeWindowsIco(master);
  _writeLinuxIcons(master);

  final assets = Directory('assets');
  assets.createSync(recursive: true);
  File('assets/app_icon_source.png').writeAsBytesSync(img.encodePng(master));
  stdout.writeln('App icons generated.');
}

img.Image _renderIcon(int size) {
  final image = img.Image(width: size, height: size);

  for (var y = 0; y < size; y++) {
    final t = y / (size - 1);
    final color = _lerpColor(_seed, _container, t);
    for (var x = 0; x < size; x++) {
      image.setPixel(x, y, color);
    }
  }

  final unit = size / 10.0;
  final keyW = unit * 1.55;
  final keyH = unit * 1.15;
  final gap = unit * 0.28;
  final radius = unit * 0.22;

  // Abstract keyboard rows (full-width space bar on bottom).
  final rows = <List<double>>[
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5],
    [1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5],
    [2, 8],
  ];

  final totalH = rows.length * keyH + (rows.length - 1) * gap;
  var y = (size - totalH) / 2;

  for (final row in rows) {
    final rowW = row.fold<double>(0, (sum, w) => sum + w * keyW) +
        (row.length - 1) * gap;
    var x = (size - rowW) / 2;

    for (final weight in row) {
      final w = weight * keyW;
      _fillRoundedRect(image, x, y, w, keyH, radius, _onContainer);
      x += w + gap;
    }
    y += keyH + gap;
  }

  return _forceOpaque(image);
}

img.Image _forceOpaque(img.Image image) {
  final out = img.Image(width: image.width, height: image.height);
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      out.setPixelRgba(
        x,
        y,
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
        255,
      );
    }
  }
  return out;
}

img.ColorRgb8 _lerpColor(img.ColorRgb8 a, img.ColorRgb8 b, double t) {
  return img.ColorRgb8(
    (a.r + (b.r - a.r) * t).round().clamp(0, 255),
    (a.g + (b.g - a.g) * t).round().clamp(0, 255),
    (a.b + (b.b - a.b) * t).round().clamp(0, 255),
  );
}

void _fillRoundedRect(
  img.Image image,
  double x,
  double y,
  double w,
  double h,
  double r,
  img.Color color,
) {
  final left = x.round();
  final top = y.round();
  final right = (x + w).round();
  final bottom = (y + h).round();
  final radius = r.round().clamp(0, math.min(w, h) ~/ 2);

  img.fillRect(
    image,
    x1: left + radius,
    y1: top,
    x2: right - radius,
    y2: bottom,
    color: color,
  );
  img.fillRect(
    image,
    x1: left,
    y1: top + radius,
    x2: right,
    y2: bottom - radius,
    color: color,
  );
  img.fillCircle(image, x: left + radius, y: top + radius, radius: radius, color: color);
  img.fillCircle(image, x: right - radius, y: top + radius, radius: radius, color: color);
  img.fillCircle(image, x: left + radius, y: bottom - radius, radius: radius, color: color);
  img.fillCircle(image, x: right - radius, y: bottom - radius, radius: radius, color: color);
}

void _writeMacosIcons(img.Image master) {
  final iconset = Directory(
    'macos/Runner/Assets.xcassets/AppIcon.appiconset',
  );
  iconset.createSync(recursive: true);

  for (final size in [16, 32, 64, 128, 256, 512, 1024]) {
    final resized = _forceOpaque(
      img.copyResize(master, width: size, height: size),
    );
    File('${iconset.path}/app_icon_$size.png')
        .writeAsBytesSync(img.encodePng(resized));
  }
  stdout.writeln('  macOS: ${iconset.path}');
}

void _writeWindowsIco(img.Image master) {
  final sizes = [16, 32, 48, 64, 128, 256];
  final pngEntries = <Uint8List>[];
  for (final size in sizes) {
    final resized = _forceOpaque(
      img.copyResize(master, width: size, height: size),
    );
    pngEntries.add(Uint8List.fromList(img.encodePng(resized)));
  }

  final out = File('windows/runner/resources/app_icon.ico');
  out.parent.createSync(recursive: true);
  out.writeAsBytesSync(_encodeMultiSizeIco(sizes, pngEntries));
  stdout.writeln('  Windows: ${out.path}');
}

void _writeLinuxIcons(img.Image master) {
  final icons = Directory('linux/icons');
  icons.createSync(recursive: true);

  for (final size in [128, 256]) {
    final resized = _forceOpaque(
      img.copyResize(master, width: size, height: size),
    );
    File('${icons.path}/app_icon_$size.png')
        .writeAsBytesSync(img.encodePng(resized));
  }
  stdout.writeln('  Linux: ${icons.path}');
}

Uint8List _encodeMultiSizeIco(List<int> sizes, List<Uint8List> pngData) {
  final count = sizes.length;
  final headerSize = 6 + count * 16;
  var offset = headerSize;
  final buffer = BytesBuilder();

  buffer.addByte(0);
  buffer.addByte(0);
  buffer.addByte(1);
  buffer.addByte(0);
  buffer.addByte(count);
  buffer.addByte(0);

  for (var i = 0; i < count; i++) {
    final size = sizes[i];
    final data = pngData[i];
    buffer.addByte(size < 256 ? size : 0);
    buffer.addByte(size < 256 ? size : 0);
    buffer.addByte(0);
    buffer.addByte(0);
    buffer.addByte(1);
    buffer.addByte(0);
    buffer.addByte(32);
    buffer.addByte(0);
    buffer.add(_le32(data.length));
    buffer.add(_le32(offset));
    offset += data.length;
  }

  for (final data in pngData) {
    buffer.add(data);
  }

  return buffer.toBytes();
}

Uint8List _le32(int value) => Uint8List.fromList([
      value & 0xFF,
      (value >> 8) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 24) & 0xFF,
    ]);
