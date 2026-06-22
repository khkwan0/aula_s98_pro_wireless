import '../models/macro.dart';
import 'key_map.dart';

bool isModifierHidCode(int hidCode) => hidCode >= 0xE0 && hidCode <= 0xE7;

class MacroTriggerInfo {
  const MacroTriggerInfo({
    required this.sourceIndex,
    required this.label,
  });

  final int sourceIndex;
  final String label;
}

/// Normalizes legacy chord triggers to a single key index when possible.
List<int> normalizeTriggerIndices(List<int> keyIndices) {
  if (keyIndices.length <= 1) {
    return keyIndices;
  }

  final keys = keyIndices
      .map(KeyboardKeyMap.byIndex)
      .whereType<KeyboardKey>()
      .toList();
  if (keys.isEmpty) {
    return const [];
  }

  final regular =
      keys.where((key) => !isModifierHidCode(key.hidCode)).toList();
  if (regular.length == 1) {
    return [regular.first.index];
  }
  if (regular.isNotEmpty) {
    return [regular.first.index];
  }
  return const [];
}

/// Parses a single-key macro trigger.
MacroTriggerInfo parseMacroTrigger(List<int> keyIndices) {
  if (keyIndices.isEmpty) {
    throw const MacroTriggerFormatException('empty');
  }

  final normalized = normalizeTriggerIndices(keyIndices);
  if (normalized.isEmpty) {
    throw const MacroTriggerFormatException('unsupported');
  }
  if (normalized.length != 1) {
    throw const MacroTriggerFormatException('singleKeyOnly');
  }

  final key = KeyboardKeyMap.byIndex(normalized.single);
  if (key == null) {
    throw const MacroTriggerFormatException('unsupported');
  }
  if (isModifierHidCode(key.hidCode)) {
    throw const MacroTriggerFormatException('modifierNotAllowed');
  }

  return MacroTriggerInfo(
    sourceIndex: key.index,
    label: key.label,
  );
}

String macroTriggerSignature(List<int> keyIndices) {
  final info = parseMacroTrigger(keyIndices);
  return '${info.sourceIndex}';
}

class MacroTriggerFormatException implements Exception {
  const MacroTriggerFormatException(this.code);

  final String code;
}

String labelForTriggerIndices(List<int> keyIndices) {
  if (keyIndices.isEmpty) return '';
  try {
    return parseMacroTrigger(keyIndices).label;
  } catch (_) {
    return keyIndices.map(KeyboardKeyMap.labelForIndex).join(' + ');
  }
}

/// True when the trigger key also appears in the macro sequence.
bool triggerOverlapsMacroEvents(MacroDefinition macro) {
  if (macro.triggerKeyIndices.isEmpty || macro.events.isEmpty) {
    return false;
  }
  try {
    final info = parseMacroTrigger(macro.triggerKeyIndices);
    final triggerKey = KeyboardKeyMap.byIndex(info.sourceIndex);
    if (triggerKey == null) return false;
    return macro.events.any((event) => event.hidCode == triggerKey.hidCode);
  } on MacroTriggerFormatException {
    return false;
  }
}
