import 'dart:typed_data';

import '../hid/hid_device.dart';
import '../l10n/user_message.dart';
import '../models/macro.dart';
import 'constants.dart';
import 'device_protocol.dart';
import 'hid_scancodes.dart';

const int macroHeaderBytes = 400;
const int macroMaxSlots = 100;
const int macroUsbSizeLimit = 2700;

class MacroBufferInfo {
  const MacroBufferInfo({
    required this.buffer,
    required this.macroCount,
    required this.eventCount,
    required this.packetCount,
  });

  final Uint8List buffer;
  final int macroCount;
  final int eventCount;
  final int packetCount;
}

List<MacroEvent> _eventsForUpload(MacroDefinition macro) {
  if (macro.events.isEmpty) return const [];

  final uploaded = <MacroEvent>[];
  if (macro.delayMode == MacroDelayMode.none) {
    return List<MacroEvent>.from(macro.events);
  }

  if (macro.delayMode == MacroDelayMode.custom) {
    final gap = macro.customDelayMs.clamp(10, 65535);
    for (var i = 0; i < macro.events.length; i++) {
      if (i > 0) {
        uploaded.add(
          MacroEvent(
            hidCode: 0,
            isKeyDown: false,
            delayMs: gap,
            label: '${gap}ms',
          ),
        );
      }
      uploaded.add(macro.events[i]);
    }
    return uploaded;
  }

  for (var i = 0; i < macro.events.length; i++) {
    final event = macro.events[i];
    if (i > 0 && event.delayMs >= 10) {
      uploaded.add(
        MacroEvent(
          hidCode: 0,
          isKeyDown: false,
          delayMs: event.delayMs,
          label: '${event.delayMs}ms',
        ),
      );
    }
    uploaded.add(event);
  }
  return uploaded;
}

Uint8List _encodeEvent(MacroEvent event) {
  if (event.hidCode == 0 && event.delayMs > 0) {
    final delay = event.delayMs.clamp(10, 65535);
    return Uint8List.fromList([
      delay & 0xFF,
      (delay >> 8) & 0xFF,
      0x00,
      HidScancodes.flagDelay,
    ]);
  }

  return Uint8List.fromList([
    0x00,
    0x00,
    event.hidCode & 0xFF,
    event.isKeyDown ? HidScancodes.flagKeyDown : HidScancodes.flagKeyUp,
  ]);
}

MacroBufferInfo _buildEmptyMacroBuffer() {
  final paddedLength = ((macroHeaderBytes + 2 + 63) ~/ 64) * 64;
  final buffer = Uint8List(paddedLength);
  for (var i = 0; i < macroMaxSlots; i++) {
    final offset = i * 4;
    buffer[offset] = 0xFF;
    buffer[offset + 1] = 0xFF;
    buffer[offset + 2] = 0xFF;
    buffer[offset + 3] = 0xFF;
  }
  buffer[paddedLength - 2] = 0x55;
  buffer[paddedLength - 1] = 0xAA;
  return MacroBufferInfo(
    buffer: buffer,
    macroCount: 0,
    eventCount: 0,
    packetCount: paddedLength ~/ KeyboardConstants.reportSize,
  );
}

MacroBufferInfo buildMacroBuffer(List<MacroDefinition> macros) {
  final active = <MacroDefinition>[];
  for (final macro in macros) {
    if (!macro.isEmpty) {
      active.add(macro);
    }
  }

  if (active.isEmpty) {
    return _buildEmptyMacroBuffer();
  }

  if (active.length > macroMaxSlots) {
    throw UserMessage('errorMacroTooManyMacros', {'count': active.length});
  }

  final uploadedEvents = active.map(_eventsForUpload).toList();
  final totalEvents = uploadedEvents.fold<int>(0, (sum, events) => sum + events.length);
  if ((active.length + totalEvents) * 8 > macroUsbSizeLimit) {
    throw UserMessage(
      'errorMacroTooLarge',
      {'macros': active.length, 'events': totalEvents},
    );
  }

  final header = Uint8List(macroHeaderBytes);
  for (var i = 0; i < macroMaxSlots; i++) {
    final offset = i * 4;
    header[offset] = 0xFF;
    header[offset + 1] = 0xFF;
    header[offset + 2] = 0xFF;
    header[offset + 3] = 0xFF;
  }

  final dataBlocks = <Uint8List>[];
  var dataOffset = macroHeaderBytes;

  for (var i = 0; i < active.length; i++) {
    final macro = active[i];
    final events = uploadedEvents[i];
    final block = Uint8List(8 + events.length * 4);
    block[0] = events.length & 0xFF;
    block[1] = (events.length >> 8) & 0xFF;
    block[2] = 1;
    block[3] = macro.delayMode.protocolValue;
    if (macro.delayMode == MacroDelayMode.custom) {
      final delay = macro.customDelayMs.clamp(10, 65535);
      block[4] = delay & 0xFF;
      block[5] = (delay >> 8) & 0xFF;
    }

    var writeOffset = 8;
    for (final event in events) {
      block.setRange(writeOffset, writeOffset + 4, _encodeEvent(event));
      writeOffset += 4;
    }

    final slotOffset = i * 4;
    header[slotOffset] = dataOffset & 0xFF;
    header[slotOffset + 1] = (dataOffset >> 8) & 0xFF;
    header[slotOffset + 2] = 0x00;
    header[slotOffset + 3] = 0x00;

    dataBlocks.add(block);
    dataOffset += block.length;
  }

  final combinedLength = macroHeaderBytes +
      dataBlocks.fold<int>(0, (sum, block) => sum + block.length);
  final paddedLength = ((combinedLength + 2 + 63) ~/ 64) * 64;
  final buffer = Uint8List(paddedLength);
  buffer.setRange(0, macroHeaderBytes, header);

  var cursor = macroHeaderBytes;
  for (final block in dataBlocks) {
    buffer.setRange(cursor, cursor + block.length, block);
    cursor += block.length;
  }

  buffer[paddedLength - 2] = 0x55;
  buffer[paddedLength - 1] = 0xAA;

  return MacroBufferInfo(
    buffer: buffer,
    macroCount: active.length,
    eventCount: totalEvents,
    packetCount: paddedLength ~/ KeyboardConstants.reportSize,
  );
}

Future<void> macroInit(HidDevice device) async {
  final payload = emptyReport();
  payload[0] = 0x04;
  payload[1] = 0x19;
  await sendCommand(device, payload, readback: true);
}

Future<void> macroDataHeader(HidDevice device, {required int packetCount}) async {
  final payload = emptyReport();
  payload[0] = 0x04;
  payload[1] = 0x15;
  payload[8] = packetCount & 0xFF;
  await sendCommand(device, payload, readback: true);
}

Future<MacroUploadResult> uploadMacros(List<MacroDefinition> macros) async {
  final info = buildMacroBuffer(macros);
  final device = HidDevice.openControl();
  try {
    await macroInit(device);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    await macroDataHeader(device, packetCount: info.packetCount);
    await Future<void>.delayed(const Duration(milliseconds: 30));

    final reportSize = KeyboardConstants.reportSize;
    for (var i = 0; i < info.packetCount; i++) {
      final start = i * reportSize;
      final end = (start + reportSize).clamp(0, info.buffer.length);
      final packet = emptyReport();
      packet.setRange(0, end - start, info.buffer.sublist(start, end));
      await sendCommand(device, packet, readback: true);
    }

    await Future<void>.delayed(const Duration(milliseconds: 30));
    await applyTransaction(device);

    return MacroUploadResult(
      macroCount: info.macroCount,
      eventCount: info.eventCount,
      packetCount: info.packetCount,
    );
  } finally {
    device.close();
  }
}
