import 'dart:typed_data';

import '../hid/hid_device.dart';
import 'device_protocol.dart';
import 'lighting_protocol.dart' as lighting;
import 'macro_protocol.dart' as macro;
import 'remap_protocol.dart' as remap;

/// Factory defaults from AULA `rgb-keyboard.xml` (`default_mode=11`, `default_brightness=5`).
const int factoryLightingMode = 11;
const int factoryLightingBrightness = 5;
const int factoryLightingSpeed = 3;

class FactoryResetResult {
  const FactoryResetResult({
    required this.clearedNormalRemaps,
    required this.clearedFnRemaps,
    required this.clearedMacros,
    required this.lightingMode,
  });

  final bool clearedNormalRemaps;
  final bool clearedFnRemaps;
  final bool clearedMacros;
  final String lightingMode;
}

Uint8List _buildEmptyMacroBuffer() {
  final header = Uint8List(macro.macroHeaderBytes);
  for (var i = 0; i < macro.macroMaxSlots; i++) {
    final offset = i * 4;
    header[offset] = 0xFF;
    header[offset + 1] = 0xFF;
    header[offset + 2] = 0xFF;
    header[offset + 3] = 0xFF;
  }

  final paddedLength =
      ((macro.macroHeaderBytes + 2 + 63) ~/ 64) * 64;
  final buffer = Uint8List(paddedLength);
  buffer.setRange(0, macro.macroHeaderBytes, header);
  buffer[paddedLength - 2] = 0x55;
  buffer[paddedLength - 1] = 0xAA;
  return buffer;
}

Future<void> _clearMacros() async {
  final buffer = _buildEmptyMacroBuffer();
  final packetCount = buffer.length ~/ 64;
  final device = HidDevice.openControl();
  try {
    await macro.macroInit(device);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    await macro.macroDataHeader(device, packetCount: packetCount);
    await Future<void>.delayed(const Duration(milliseconds: 30));

    for (var i = 0; i < packetCount; i++) {
      final start = i * 64;
      final end = (start + 64).clamp(0, buffer.length);
      final packet = emptyReport();
      packet.setRange(0, end - start, buffer.sublist(start, end));
      await sendCommand(device, packet, readback: true);
    }

    await Future<void>.delayed(const Duration(milliseconds: 30));
    await applyTransaction(device);
  } finally {
    device.close();
  }
}

/// Restores keyboard settings to factory defaults over USB.
///
/// Clears key remaps (normal + FN layers), macros, and resets lighting.
/// LCD animations and menu graphics in SPI flash are not affected.
Future<FactoryResetResult> factoryReset() async {
  await remap.uploadRemapTable(const []);
  await remap.uploadRemapTable(const [], fnLayer: true);
  await _clearMacros();

  final lightingResult = await lighting.setLighting(
    mode: factoryLightingMode,
    brightness: factoryLightingBrightness,
    speed: factoryLightingSpeed,
  );

  return FactoryResetResult(
    clearedNormalRemaps: true,
    clearedFnRemaps: true,
    clearedMacros: true,
    lightingMode: lightingResult.modeName,
  );
}
