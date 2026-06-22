import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'constants.dart';

int rgb888ToRgb565(int r, int g, int b) {
  return ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3);
}

void writeRgb565(Uint8List buffer, int offset, int r, int g, int b) {
  final pixel = rgb888ToRgb565(r, g, b);
  buffer[offset] = pixel & 0xFF;
  buffer[offset + 1] = (pixel >> 8) & 0xFF;
}

int frameDelayToKeyboard(int delayCentiseconds) {
  var delay = delayCentiseconds ~/ 2;
  if (delay < 1) delay = 1;
  if (delay > 255) delay = 255;
  return delay;
}

Uint8List buildPaddedBuffer(Uint8List header, Uint8List frameData) {
  final totalSize = KeyboardConstants.headerSize + frameData.length;
  final pageCount = (totalSize / KeyboardConstants.pageSize).ceil();
  final paddedSize = pageCount * KeyboardConstants.pageSize;
  final buffer = Uint8List(paddedSize);
  buffer.fillRange(0, paddedSize, 0xFF);
  buffer.setRange(0, header.length, header);
  buffer.setRange(
    KeyboardConstants.headerSize,
    KeyboardConstants.headerSize + frameData.length,
    frameData,
  );
  return buffer;
}

class _DecodedGif {
  const _DecodedGif({
    required this.decoder,
    required this.info,
  });

  final img.GifDecoder decoder;
  final img.GifInfo info;

  int get width => info.width;
  int get height => info.height;
  int get frameCount => info.numFrames;
}

_DecodedGif? _decodeGif(Uint8List bytes) {
  final decoder = img.GifDecoder();
  final info = decoder.startDecode(bytes);
  if (info == null || info.numFrames == 0) {
    return null;
  }
  return _DecodedGif(decoder: decoder, info: info);
}

class LcdBufferInfo {
  const LcdBufferInfo({
    required this.headerFrameCount,
    required this.computedFrameCount,
    required this.pageCount,
  });

  final int headerFrameCount;
  final int computedFrameCount;
  final int pageCount;
}

LcdBufferInfo countFrames(Uint8List buffer) {
  if (buffer.length < KeyboardConstants.headerSize) {
    throw StateError('LCD buffer is too small to contain a header.');
  }
  final headerFrameCount = buffer[0];
  final payloadBytes = buffer.length - KeyboardConstants.headerSize;
  final computedFrameCount = payloadBytes ~/ KeyboardConstants.frameSize;
  return LcdBufferInfo(
    headerFrameCount: headerFrameCount,
    computedFrameCount: computedFrameCount,
    pageCount: buffer.length ~/ KeyboardConstants.pageSize,
  );
}

LcdBufferInfo validateLcdBuffer(
  Uint8List buffer, {
  bool force = false,
  int maxFrames = KeyboardConstants.maxFrames,
}) {
  if (buffer.isEmpty) {
    throw StateError('LCD buffer is empty.');
  }
  if (buffer.length % KeyboardConstants.pageSize != 0) {
    throw StateError(
      'LCD buffer size ${buffer.length} is not a multiple of ${KeyboardConstants.pageSize}.',
    );
  }

  final info = countFrames(buffer);
  if (info.headerFrameCount == 0) {
    throw StateError('LCD buffer header reports 0 frames.');
  }
  if (info.headerFrameCount > maxFrames && !force) {
    throw StateError(
      'Buffer contains ${info.headerFrameCount} frames, which exceeds the safe limit of $maxFrames. '
      'Enable force to override (may corrupt keyboard menu graphics).',
    );
  }
  if (info.computedFrameCount < info.headerFrameCount) {
    throw StateError(
      'Buffer is truncated: header says ${info.headerFrameCount} frames '
      'but only ${info.computedFrameCount} fit.',
    );
  }

  final maxSafePages =
      ((KeyboardConstants.headerSize + KeyboardConstants.frameSize * maxFrames) /
              KeyboardConstants.pageSize)
          .ceil();
  if (info.pageCount > maxSafePages && !force) {
    throw StateError(
      'Buffer is ${info.pageCount} pages, exceeding the safe limit of $maxSafePages pages '
      '(~$maxFrames frames). Enable force to override.',
    );
  }
  return info;
}

class GifInspectInfo {
  const GifInspectInfo({
    required this.frameCount,
    required this.outputFrameCount,
    required this.width,
    required this.height,
    required this.pageCount,
    required this.withinLimit,
    required this.warnings,
  });

  final int frameCount;
  final int outputFrameCount;
  final int width;
  final int height;
  final int pageCount;
  final bool withinLimit;
  final List<String> warnings;
}

GifInspectInfo inspectGifBytes(Uint8List bytes) {
  final decoded = _decodeGif(bytes);
  if (decoded == null) {
    throw StateError('GIF contains no frames.');
  }

  final frameCount = decoded.frameCount;
  final outputFrameCount = frameCount > KeyboardConstants.maxFrames
      ? KeyboardConstants.maxFrames
      : frameCount;
  final width = decoded.width;
  final height = decoded.height;
  final expectedBytes =
      KeyboardConstants.headerSize + KeyboardConstants.frameSize * outputFrameCount;
  final pageCount = (expectedBytes / KeyboardConstants.pageSize).ceil();

  final warnings = <String>[];
  if (width != KeyboardConstants.screenWidth ||
      height != KeyboardConstants.screenHeight) {
    warnings.add(
      'GIF is ${width}x$height; keyboard expects '
      '${KeyboardConstants.screenWidth}x${KeyboardConstants.screenHeight}.',
    );
  }
  if (frameCount > KeyboardConstants.maxFrames) {
    warnings.add(
      'GIF has $frameCount frames; only the first ${KeyboardConstants.maxFrames} will be used.',
    );
  }

  return GifInspectInfo(
    frameCount: frameCount,
    outputFrameCount: outputFrameCount,
    width: width,
    height: height,
    pageCount: pageCount,
    withinLimit: frameCount <= KeyboardConstants.maxFrames,
    warnings: warnings,
  );
}

class GifConversionResult {
  const GifConversionResult({
    required this.buffer,
    required this.frameCount,
    required this.width,
    required this.height,
    required this.warnings,
  });

  final Uint8List buffer;
  final int frameCount;
  final int width;
  final int height;
  final List<String> warnings;
}

GifConversionResult gifBytesToLcdBuffer(
  Uint8List bytes, {
  int maxFrames = KeyboardConstants.maxFrames,
  bool force = false,
}) {
  final decoded = _decodeGif(bytes);
  if (decoded == null) {
    throw StateError('GIF contains no frames.');
  }

  var frameCount = decoded.frameCount;
  final originalFrameCount = frameCount;
  final warnings = <String>[];

  if (frameCount > maxFrames && !force) {
    warnings.add(
      'GIF has $originalFrameCount frames; only the first $maxFrames will be used.',
    );
    frameCount = maxFrames;
  }
  if (frameCount > 255) {
    if (originalFrameCount > 255) {
      warnings.add(
        'GIF has $originalFrameCount frames; capped at 255 (header limit).',
      );
    }
    frameCount = 255;
  }

  if (decoded.width != KeyboardConstants.screenWidth ||
      decoded.height != KeyboardConstants.screenHeight) {
    warnings.add(
      'GIF is ${decoded.width}x${decoded.height}; keyboard expects '
      '${KeyboardConstants.screenWidth}x${KeyboardConstants.screenHeight}. '
      'Frames will be cropped/padded.',
    );
  }

  final header = Uint8List(KeyboardConstants.headerSize);
  header.fillRange(0, header.length, 0xFF);
  header[0] = frameCount;

  final canvas = img.Image(
    width: KeyboardConstants.screenWidth,
    height: KeyboardConstants.screenHeight,
  );
  img.fill(canvas, color: img.ColorRgb8(0, 0, 0));

  final frameBuffers = <Uint8List>[];

  for (var i = 0; i < frameCount; i++) {
    final desc = decoded.info.frames[i];
    final frameImage = decoded.decoder.decodeFrame(i);
    if (frameImage == null) {
      throw StateError('Failed to decode GIF frame ${i + 1}.');
    }

    for (final pixel in frameImage) {
      if (pixel.a == 0) continue;
      final canvasX = pixel.x + desc.x;
      final canvasY = pixel.y + desc.y;
      if (canvasX >= KeyboardConstants.screenWidth ||
          canvasY >= KeyboardConstants.screenHeight) {
        continue;
      }
      canvas.setPixel(canvasX, canvasY, pixel);
    }

    header[1 + i] = frameDelayToKeyboard(desc.duration);
    frameBuffers.add(canvasToRgb565Frame(canvas));

    switch (desc.disposal) {
      case 2:
        for (var y = desc.y; y < desc.y + desc.height; y++) {
          for (var x = desc.x; x < desc.x + desc.width; x++) {
            if (x < KeyboardConstants.screenWidth &&
                y < KeyboardConstants.screenHeight) {
              canvas.setPixel(x, y, img.ColorRgb8(0, 0, 0));
            }
          }
        }
      case 3:
        img.fill(canvas, color: img.ColorRgb8(0, 0, 0));
      default:
        break;
    }
  }

  final frameData = Uint8List(frameBuffers.length * KeyboardConstants.frameSize);
  var offset = 0;
  for (final frame in frameBuffers) {
    frameData.setRange(offset, offset + frame.length, frame);
    offset += frame.length;
  }

  final buffer = buildPaddedBuffer(header, frameData);
  validateLcdBuffer(buffer, force: force, maxFrames: maxFrames);

  return GifConversionResult(
    buffer: buffer,
    frameCount: frameCount,
    width: decoded.width,
    height: decoded.height,
    warnings: warnings,
  );
}

Uint8List canvasToRgb565Frame(img.Image canvas) {
  final frame = Uint8List(KeyboardConstants.frameSize);
  var offset = 0;
  for (var y = 0; y < KeyboardConstants.screenHeight; y++) {
    for (var x = 0; x < KeyboardConstants.screenWidth; x++) {
      final pixel = canvas.getPixel(x, y);
      writeRgb565(frame, offset, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
      offset += 2;
    }
  }
  return frame;
}
