/// How a macro runs when its trigger key is pressed.
enum MacroPlaybackMode {
  /// Run up to [MacroDefinition.maxRepeats] times per trigger press.
  once,

  /// Loop until the trigger key is pressed again.
  toggle;

  static MacroPlaybackMode fromName(String? name) {
    return MacroPlaybackMode.values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => MacroPlaybackMode.once,
    );
  }
}

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
    this.playbackMode = MacroPlaybackMode.once,
    this.maxRepeats = 1,
    this.delayMode = MacroDelayMode.recorded,
    this.customDelayMs = 10,
    this.events = const [],
    this.triggerKeyIndices = const [],
    this.triggerKeyLabel = '',
  });

  static const int maxRepeatsLimit = 99;

  final String name;
  final MacroPlaybackMode playbackMode;
  final int maxRepeats;
  final MacroDelayMode delayMode;
  final int customDelayMs;
  final List<MacroEvent> events;
  final List<int> triggerKeyIndices;
  final String triggerKeyLabel;

  bool get isEmpty => events.isEmpty;
  bool get hasTrigger => triggerKeyIndices.isNotEmpty;

  MacroDefinition copyWith({
    String? name,
    MacroPlaybackMode? playbackMode,
    int? maxRepeats,
    MacroDelayMode? delayMode,
    int? customDelayMs,
    List<MacroEvent>? events,
    List<int>? triggerKeyIndices,
    String? triggerKeyLabel,
    bool clearTrigger = false,
    bool clearEvents = false,
  }) {
    return MacroDefinition(
      name: name ?? this.name,
      playbackMode: playbackMode ?? this.playbackMode,
      maxRepeats: maxRepeats ?? this.maxRepeats,
      delayMode: delayMode ?? this.delayMode,
      customDelayMs: customDelayMs ?? this.customDelayMs,
      events: clearEvents ? const [] : (events ?? this.events),
      triggerKeyIndices: clearTrigger
          ? const []
          : (triggerKeyIndices ?? this.triggerKeyIndices),
      triggerKeyLabel:
          clearTrigger ? '' : (triggerKeyLabel ?? this.triggerKeyLabel),
    );
  }

  MacroDefinition clone() {
    return MacroDefinition(
      name: name,
      playbackMode: playbackMode,
      maxRepeats: maxRepeats,
      delayMode: delayMode,
      customDelayMs: customDelayMs,
      events: List<MacroEvent>.from(events),
      triggerKeyIndices: List<int>.from(triggerKeyIndices),
      triggerKeyLabel: triggerKeyLabel,
    );
  }

  bool matches(MacroDefinition other) {
    if (name != other.name ||
        playbackMode != other.playbackMode ||
        maxRepeats != other.maxRepeats ||
        delayMode != other.delayMode ||
        customDelayMs != other.customDelayMs ||
        triggerKeyLabel != other.triggerKeyLabel ||
        events.length != other.events.length ||
        triggerKeyIndices.length != other.triggerKeyIndices.length) {
      return false;
    }
    for (var i = 0; i < events.length; i++) {
      final event = events[i];
      final otherEvent = other.events[i];
      if (event.hidCode != otherEvent.hidCode ||
          event.isKeyDown != otherEvent.isKeyDown ||
          event.delayMs != otherEvent.delayMs ||
          event.label != otherEvent.label) {
        return false;
      }
    }
    for (var i = 0; i < triggerKeyIndices.length; i++) {
      if (triggerKeyIndices[i] != other.triggerKeyIndices[i]) return false;
    }
    return true;
  }
}

List<MacroDefinition> cloneMacroList(List<MacroDefinition> macros) {
  return macros.map((macro) => macro.clone()).toList();
}

bool macrosListChanged(
  List<MacroDefinition> applied,
  List<MacroDefinition> draft,
) {
  if (applied.length != draft.length) return true;
  for (var i = 0; i < applied.length; i++) {
    if (!applied[i].matches(draft[i])) return true;
  }
  return false;
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
