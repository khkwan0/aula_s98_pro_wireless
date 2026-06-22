/// How delays between macro events are handled when uploaded to the keyboard.
enum MacroDelayMode {
  /// Use recorded delays between events.
  recorded(1),

  /// No delay between events.
  none(2),

  /// Use a fixed custom delay for all gaps.
  custom(3);

  const MacroDelayMode(this.protocolValue);
  final int protocolValue;
}

/// A single step in a keyboard macro.
class MacroEvent {
  const MacroEvent({
    required this.hidCode,
    required this.isKeyDown,
    this.delayMs = 0,
    this.label = '',
  });

  final int hidCode;
  final bool isKeyDown;
  final int delayMs;
  final String label;

  MacroEvent copyWith({
    int? hidCode,
    bool? isKeyDown,
    int? delayMs,
    String? label,
  }) {
    return MacroEvent(
      hidCode: hidCode ?? this.hidCode,
      isKeyDown: isKeyDown ?? this.isKeyDown,
      delayMs: delayMs ?? this.delayMs,
      label: label ?? this.label,
    );
  }
}

/// A named macro with playback settings and recorded events.
class MacroDefinition {
  const MacroDefinition({
    required this.name,
    this.playTimes = 1,
    this.delayMode = MacroDelayMode.recorded,
    this.customDelayMs = 10,
    this.events = const [],
  });

  final String name;
  final int playTimes;
  final MacroDelayMode delayMode;
  final int customDelayMs;
  final List<MacroEvent> events;

  bool get isEmpty => events.isEmpty;

  MacroDefinition copyWith({
    String? name,
    int? playTimes,
    MacroDelayMode? delayMode,
    int? customDelayMs,
    List<MacroEvent>? events,
  }) {
    return MacroDefinition(
      name: name ?? this.name,
      playTimes: playTimes ?? this.playTimes,
      delayMode: delayMode ?? this.delayMode,
      customDelayMs: customDelayMs ?? this.customDelayMs,
      events: events ?? this.events,
    );
  }
}

class MacroUploadResult {
  const MacroUploadResult({
    required this.macroCount,
    required this.eventCount,
    required this.packetCount,
  });

  final int macroCount;
  final int eventCount;
  final int packetCount;
}
