import 'dart:typed_data';

import '../hid/hid_device.dart';
import '../l10n/user_message.dart';
import '../models/macro.dart';
import '../models/remap.dart';
import '../services/remap_storage.dart';
import 'constants.dart';
import 'device_protocol.dart';
import 'key_map.dart';
import 'macro_protocol.dart';
import 'macro_trigger_codec.dart';

const int remapBufferSize = 0x240;
const int remapActionKeyCombo = 0x02;
const int remapActionConsumer = 0x03;
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

  factory KeyRemap.consumer({
    required int sourceIndex,
    required int consumerCode,
  }) {
    return KeyRemap(
      sourceIndex: sourceIndex,
      action: remapActionConsumer,
      param1: consumerCode,
    );
  }

  factory KeyRemap.keyTarget({
    required int sourceIndex,
    required int hidCode,
    int modifiers = 0,
  }) {
    return KeyRemap(
      sourceIndex: sourceIndex,
      action: remapActionKeyCombo,
      param1: modifiers,
      param2: hidCode,
    );
  }

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
    if (!_writeRemapSlot(buffer, remap)) continue;
  }
  buffer[remapBufferSize - 2] = 0xAA;
  buffer[remapBufferSize - 1] = 0x55;
  return buffer;
}

bool _writeRemapSlot(Uint8List buffer, KeyRemap remap) {
  if (remap.sourceIndex <= 0) return false;
  final offset = remap.sourceIndex * 4;
  if (offset + 3 >= remapBufferSize - 2) return false;
  buffer[offset] = remap.action;
  buffer[offset + 1] = remap.param1;
  buffer[offset + 2] = remap.param2;
  buffer[offset + 3] = remap.param3;
  return true;
}

int countEncodedRemaps(List<KeyRemap> remaps) {
  var count = 0;
  final buffer = Uint8List(remapBufferSize);
  for (final remap in remaps) {
    if (_writeRemapSlot(buffer, remap)) count++;
  }
  return count;
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
    await sendMultiPacket(device, buildRemapBuffer(remaps), readback: true);
    await applyTransaction(device);
    await finalizeTransaction(device);
    return RemapResult(bindingCount: countEncodedRemaps(remaps));
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

List<KeyRemap> remapsFromBindings(Iterable<RemapBinding> bindings) {
  return bindings.map((binding) => binding.toKeyRemap()).toList();
}

List<KeyRemap> buildMergedNormalRemaps({
  required List<RemapBinding> userBindings,
  required List<MacroDefinition> macros,
}) {
  final userRemaps = remapsFromBindings(
    userBindings.where((binding) => !binding.fnLayer),
  );
  final macroRemaps = macroTriggerRemaps(macros);
  _assertNoSourceConflicts(userRemaps, macroRemaps);
  return [...userRemaps, ...macroRemaps];
}

List<KeyRemap> buildMergedFnRemaps(List<RemapBinding> userBindings) {
  return remapsFromBindings(
    userBindings.where((binding) => binding.fnLayer),
  );
}

void _assertNoSourceConflicts(
  List<KeyRemap> userRemaps,
  List<KeyRemap> macroRemaps,
) {
  final macroSources = {for (final remap in macroRemaps) remap.sourceIndex};
  for (final remap in userRemaps) {
    if (macroSources.contains(remap.sourceIndex)) {
      throw UserMessage(
        'errorRemapConflictMacro',
        {'key': KeyboardKeyMap.labelForIndex(remap.sourceIndex)},
      );
    }
  }
}

void _assertUniqueSources(List<KeyRemap> remaps) {
  final seen = <int>{};
  for (final remap in remaps) {
    if (!seen.add(remap.sourceIndex)) {
      throw UserMessage(
        'errorRemapDuplicateSource',
        {'key': KeyboardKeyMap.labelForIndex(remap.sourceIndex)},
      );
    }
  }
}

Future<RemapResult> applyRemapBindings(
  List<RemapBinding> bindings, {
  List<MacroDefinition> macros = const [],
  bool uploadNormalLayer = true,
  bool uploadFnLayer = true,
}) async {
  final activeBindings = activeRemapBindings(bindings);
  final hasNormalBindings = activeBindings.any((binding) => !binding.fnLayer);
  final hasFnBindings = activeBindings.any((binding) => binding.fnLayer);
  final macroRemaps = macroTriggerRemaps(macros);
  final normalRemaps = buildMergedNormalRemaps(
    userBindings: activeBindings,
    macros: macros,
  );
  final fnRemaps = buildMergedFnRemaps(activeBindings);

  if (!uploadNormalLayer &&
      !uploadFnLayer &&
      !hasNormalBindings &&
      !hasFnBindings &&
      macroRemaps.isEmpty) {
    throw const UserMessage('errorRemapNoBindings');
  }

  var appliedCount = 0;
  var uploadedLayers = 0;

  if (uploadNormalLayer && (hasNormalBindings || macroRemaps.isNotEmpty)) {
    _assertUniqueSources(normalRemaps);
    final normalResult = await uploadRemapTable(normalRemaps);
    appliedCount += normalResult.bindingCount;
    uploadedLayers++;
  } else if (uploadNormalLayer) {
    await uploadRemapTable(const []);
    uploadedLayers++;
  }

  if (uploadFnLayer && hasFnBindings) {
    _assertUniqueSources(fnRemaps);
    final fnResult = await uploadRemapTable(fnRemaps, fnLayer: true);
    appliedCount += fnResult.bindingCount;
    uploadedLayers++;
  } else if (uploadFnLayer) {
    await uploadRemapTable(const [], fnLayer: true);
    uploadedLayers++;
  }

  if (uploadedLayers == 0) {
    throw const UserMessage('errorRemapNoBindings');
  }

  return RemapResult(bindingCount: appliedCount);
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
  final storedBindings = await RemapStorage.load();
  final remaps = buildMergedNormalRemaps(
    userBindings: storedBindings,
    macros: macros,
  );
  final bindings = await uploadRemapTable(remaps);
  final fnRemaps = buildMergedFnRemaps(storedBindings);
  if (fnRemaps.isNotEmpty) {
    await uploadRemapTable(fnRemaps, fnLayer: true);
  }
  return MacroUploadWithBindingsResult(
    upload: upload,
    bindings: bindings,
  );
}
