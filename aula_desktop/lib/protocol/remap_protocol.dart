import 'dart:typed_data';

import '../hid/hid_device.dart';
import '../l10n/user_message.dart';
import '../models/macro.dart';
import 'constants.dart';
import 'device_protocol.dart';
import 'macro_protocol.dart';
import 'macro_trigger_codec.dart';

const int remapBufferSize = 0x240;
const int remapActionMacro = 0x06;

class KeyRemap {
  const KeyRemap({
    required this.sourceIndex,
    required this.action,
    this.param1 = 0,
    this.param2 = 0,
    this.param3 = 0,
  });

  final int sourceIndex;
  final int action;
  final int param1;
  final int param2;
  final int param3;

  factory KeyRemap.macro({
    required int sourceIndex,
    required int macroIndex,
    MacroPlaybackMode playbackMode = MacroPlaybackMode.once,
    int maxRepeats = 1,
  }) {
    final repeats = maxRepeats.clamp(1, MacroDefinition.maxRepeatsLimit);
    // S98 Pro remap slot (type 0x06), verified on hardware:
    // - param2=1, param3=0 → play once
    // - param2=1, param3=N (N>1) → play exactly N times per press
    // - param2=2, param3=0 → toggle (loop until trigger pressed again)
    return switch (playbackMode) {
      MacroPlaybackMode.once => KeyRemap(
          sourceIndex: sourceIndex,
          action: remapActionMacro,
          param1: macroIndex,
          param2: 1,
          param3: repeats <= 1 ? 0 : repeats,
        ),
      MacroPlaybackMode.toggle => KeyRemap(
          sourceIndex: sourceIndex,
          action: remapActionMacro,
          param1: macroIndex,
          param2: 2,
          param3: 0,
        ),
    };
  }
}

class RemapResult {
  const RemapResult({required this.bindingCount});

  final int bindingCount;
}

Uint8List buildRemapBuffer(List<KeyRemap> remaps) {
  final buffer = Uint8List(remapBufferSize);
  for (final remap in remaps) {
    if (remap.sourceIndex <= 0) continue;
    final offset = remap.sourceIndex * 4;
    if (offset + 3 >= remapBufferSize - 2) continue;
    buffer[offset] = remap.action;
    buffer[offset + 1] = remap.param1;
    buffer[offset + 2] = remap.param2;
    buffer[offset + 3] = remap.param3;
  }
  buffer[remapBufferSize - 2] = 0xAA;
  buffer[remapBufferSize - 1] = 0x55;
  return buffer;
}

Future<void> remapInit(HidDevice device, {required bool fnLayer}) async {
  final payload = emptyReport();
  payload[0] = 0x04;
  payload[1] = fnLayer ? 0x27 : 0x11;
  payload[8] = 0x09;
  await sendCommand(device, payload, readback: true);
}

Future<void> sendMultiPacket(
  HidDevice device,
  Uint8List data, {
  required bool readback,
}) async {
  final reportSize = KeyboardConstants.reportSize;
  final packetCount = (data.length + reportSize - 1) ~/ reportSize;
  for (var i = 0; i < packetCount; i++) {
    final start = i * reportSize;
    final end = (start + reportSize).clamp(0, data.length);
    final packet = emptyReport();
    packet.setRange(0, end - start, data.sublist(start, end));
    final needsReadback = readback && i == packetCount - 1;
    await sendCommand(device, packet, readback: needsReadback);
  }
}

Future<RemapResult> uploadRemapTable(
  List<KeyRemap> remaps, {
  bool fnLayer = false,
}) async {
  final device = HidDevice.openControl();
  try {
    await beginTransaction(device);
    await remapInit(device, fnLayer: fnLayer);
    await sendMultiPacket(device, buildRemapBuffer(remaps), readback: false);
    await applyTransaction(device);
    await finalizeTransaction(device);
    return RemapResult(bindingCount: remaps.length);
  } finally {
    device.close();
  }
}

/// Returns the upload slot index for [listIndex], or null if that macro is empty.
int? activeMacroUploadIndex(List<MacroDefinition> macros, int listIndex) {
  var uploadIndex = 0;
  for (var i = 0; i < macros.length; i++) {
    if (macros[i].isEmpty) continue;
    if (i == listIndex) return uploadIndex;
    uploadIndex++;
  }
  return null;
}

List<KeyRemap> macroTriggerRemaps(List<MacroDefinition> macros) {
  final remaps = <KeyRemap>[];
  final usedTriggers = <String>{};

  for (var i = 0; i < macros.length; i++) {
    final macro = macros[i];
    if (macro.triggerKeyIndices.isEmpty || macro.isEmpty) continue;

    final uploadIndex = activeMacroUploadIndex(macros, i);
    if (uploadIndex == null) continue;

    MacroTriggerInfo info;
    try {
      info = parseMacroTrigger(macro.triggerKeyIndices);
    } on MacroTriggerFormatException catch (error) {
      throw UserMessage('errorMacroTriggerInvalid', {'reason': error.code});
    }

    final signature = '${info.sourceIndex}';
    if (usedTriggers.contains(signature)) {
      throw UserMessage(
        'errorMacroDuplicateTrigger',
        {'key': info.label},
      );
    }
    usedTriggers.add(signature);

    remaps.add(
      KeyRemap.macro(
        sourceIndex: info.sourceIndex,
        macroIndex: uploadIndex,
        playbackMode: macro.playbackMode,
        maxRepeats: macro.maxRepeats,
      ),
    );
  }

  return remaps;
}

Future<RemapResult> applyMacroTriggers(List<MacroDefinition> macros) async {
  final remaps = macroTriggerRemaps(macros);
  if (remaps.isEmpty) {
    throw const UserMessage('errorMacroNoTrigger');
  }
  return uploadRemapTable(remaps);
}

class MacroUploadWithBindingsResult {
  const MacroUploadWithBindingsResult({
    required this.upload,
    this.bindings,
  });

  final MacroUploadResult upload;
  final RemapResult? bindings;
}

Future<MacroUploadWithBindingsResult> uploadMacrosWithBindings(
  List<MacroDefinition> macros,
) async {
  final upload = await uploadMacros(macros);
  final remaps = macroTriggerRemaps(macros);
  final bindings = await uploadRemapTable(remaps);
  return MacroUploadWithBindingsResult(
    upload: upload,
    bindings: bindings,
  );
}
