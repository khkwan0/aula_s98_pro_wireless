import 'dart:io';
import 'dart:typed_data';

import '../hid/hid_device.dart';
import 'constants.dart';
import 'device_protocol.dart';
import 'lcd_converter.dart';

class LcdUploadResult {
  const LcdUploadResult({
    required this.frameCount,
    required this.pageCount,
    required this.source,
    this.warnings = const [],
  });

  final int frameCount;
  final int pageCount;
  final String source;
  final List<String> warnings;
}

Future<LcdUploadResult> uploadLcdBuffer(
  Uint8List buffer, {
  int imageSlot = 1,
  bool force = false,
  void Function(int sent, int total)? onProgress,
}) async {
  final validation = validateLcdBuffer(buffer, force: force);
  final pageCount = validation.pageCount;

  final controlDevice = HidDevice.openControl();
  final lcdDevice = HidDevice.openLcd();

  try {
    await beginTransaction(controlDevice);
    await lcdImageHeader(
      controlDevice,
      imageSlot: imageSlot,
      pageCount: pageCount,
    );

    for (var i = 0; i < pageCount; i++) {
      final start = i * KeyboardConstants.pageSize;
      final page = buffer.sublist(start, start + KeyboardConstants.pageSize);
      lcdDevice.writeOutputReport(page);
      lcdDevice.readTimeout(KeyboardConstants.lcdAckTimeoutMs);
      await Future<void>.delayed(const Duration(milliseconds: 2));
      onProgress?.call(i + 1, pageCount);
    }

    await applyTransaction(controlDevice);

    return LcdUploadResult(
      frameCount: validation.headerFrameCount,
      pageCount: pageCount,
      source: 'buffer',
    );
  } finally {
    controlDevice.close();
    lcdDevice.close();
  }
}

Future<LcdUploadResult> uploadLcdFile(
  String path, {
  int imageSlot = 1,
  bool force = false,
  void Function(int sent, int total)? onProgress,
}) async {
  final file = File(path);
  if (!await file.exists()) {
    throw StateError('File not found: $path');
  }

  final bytes = await file.readAsBytes();
  final ext = path.split('.').last.toLowerCase();

  late Uint8List buffer;
  final warnings = <String>[];
  if (ext == 'gif') {
    final converted = gifBytesToLcdBuffer(bytes, force: force);
    buffer = converted.buffer;
    warnings.addAll(converted.warnings);
  } else if (ext == 'bin') {
    buffer = bytes;
    validateLcdBuffer(buffer, force: force);
  } else {
    throw StateError('Supported formats: .gif or .bin');
  }

  final result = await uploadLcdBuffer(
    buffer,
    imageSlot: imageSlot,
    force: force,
    onProgress: onProgress,
  );

  return LcdUploadResult(
    frameCount: result.frameCount,
    pageCount: result.pageCount,
    source: path,
    warnings: warnings,
  );
}

Future<void> saveBinFile(String path, Uint8List buffer) async {
  await File(path).writeAsBytes(buffer);
}
