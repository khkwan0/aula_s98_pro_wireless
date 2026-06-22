import 'dart:convert';
import 'dart:io';

import '../models/macro.dart';
import '../protocol/macro_trigger_codec.dart';

const _storageVersion = 1;

List<MacroDefinition> defaultMacros() => [
      const MacroDefinition(name: 'Macro 1'),
      const MacroDefinition(name: 'Macro 2'),
      const MacroDefinition(name: 'Macro 3'),
    ];

class MacroStorage {
  MacroStorage._();

  static String storagePath() {
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '.';
    return '$home/.aula_desktop/macros.json';
  }

  static List<MacroDefinition> _mutableCopy(List<MacroDefinition> macros) =>
      List<MacroDefinition>.from(macros);

  static Future<List<MacroDefinition>> load() async {
    try {
      final file = File(storagePath());
      if (!await file.exists()) {
        return _mutableCopy(defaultMacros());
      }
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) {
        return _mutableCopy(defaultMacros());
      }
      final macrosJson = decoded['macros'];
      if (macrosJson is! List<dynamic> || macrosJson.isEmpty) {
        return _mutableCopy(defaultMacros());
      }
      return _mutableCopy(
        macrosJson
            .map((entry) => _macroFromJson(entry as Map<String, dynamic>))
            .toList(),
      );
    } catch (_) {
      return _mutableCopy(defaultMacros());
    }
  }

  static String _encode(List<MacroDefinition> macros) {
    final payload = <String, Object?>{
      'version': _storageVersion,
      'macros': macros.map(_macroToJson).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  static Future<void> save(List<MacroDefinition> macros) async {
    if (macros.isEmpty) return;
    final file = File(storagePath());
    await file.parent.create(recursive: true);
    await file.writeAsString(_encode(macros));
  }

  static void saveSync(List<MacroDefinition> macros) {
    if (macros.isEmpty) return;
    final file = File(storagePath());
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(_encode(macros));
  }

  static Map<String, Object?> _macroToJson(MacroDefinition macro) => {
        'name': macro.name,
        'playbackMode': macro.playbackMode.name,
        'maxRepeats': macro.maxRepeats,
        'delayMode': macro.delayMode.name,
        'customDelayMs': macro.customDelayMs,
        'triggerKeyIndices': macro.triggerKeyIndices,
        'triggerKeyLabel': macro.triggerKeyLabel,
        'events': macro.events.map(_eventToJson).toList(),
      };

  static MacroDefinition _macroFromJson(Map<String, dynamic> json) {
    final delayModeName = json['delayMode'] as String? ?? 'recorded';
    final delayMode = MacroDelayMode.values.firstWhere(
      (mode) => mode.name == delayModeName,
      orElse: () => MacroDelayMode.recorded,
    );

    return MacroDefinition(
      name: json['name'] as String? ?? 'Macro',
      playbackMode: _playbackModeFromJson(json),
      maxRepeats: _maxRepeatsFromJson(json),
      delayMode: delayMode,
      customDelayMs: ((json['customDelayMs'] as num?) ?? 10).toInt(),
      triggerKeyIndices: _normalizeStoredTriggerIndices(
        _intList(json['triggerKeyIndices']),
      ),
      triggerKeyLabel: _triggerLabelFromJson(json),
      events: (json['events'] as List<dynamic>?)
              ?.map((entry) => _eventFromJson(entry as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  static Map<String, Object?> _eventToJson(MacroEvent event) => {
        'hidCode': event.hidCode,
        'isKeyDown': event.isKeyDown,
        'delayMs': event.delayMs,
        'label': event.label,
      };

  static MacroEvent _eventFromJson(Map<String, dynamic> json) => MacroEvent(
        hidCode: ((json['hidCode'] as num?) ?? 0).toInt(),
        isKeyDown: json['isKeyDown'] as bool? ?? true,
        delayMs: ((json['delayMs'] as num?) ?? 0).toInt(),
        label: json['label'] as String? ?? '',
      );

  static MacroPlaybackMode _playbackModeFromJson(Map<String, dynamic> json) {
    final playbackMode = json['playbackMode'] as String?;
    if (playbackMode != null) {
      if (playbackMode == 'whileHeld') {
        return MacroPlaybackMode.once;
      }
      return MacroPlaybackMode.fromName(playbackMode);
    }
    return MacroPlaybackMode.once;
  }

  static int _maxRepeatsFromJson(Map<String, dynamic> json) {
    final maxRepeats = json['maxRepeats'] as num?;
    if (maxRepeats != null) {
      return maxRepeats.toInt().clamp(1, MacroDefinition.maxRepeatsLimit);
    }
    final legacyLoops = json['maxLoops'] as num?;
    if (legacyLoops != null) {
      return legacyLoops.toInt().clamp(1, MacroDefinition.maxRepeatsLimit);
    }
    return 1;
  }

  static List<int> _intList(Object? value) {
    if (value is! List<dynamic>) return const [];
    return value.map((entry) => (entry as num).toInt()).toList();
  }

  static List<int> _normalizeStoredTriggerIndices(List<int> indices) {
    return normalizeTriggerIndices(indices);
  }

  static String _triggerLabelFromJson(Map<String, dynamic> json) {
    final indices = _normalizeStoredTriggerIndices(
      _intList(json['triggerKeyIndices']),
    );
    if (indices.isEmpty) return '';
    return labelForTriggerIndices(indices);
  }
}
