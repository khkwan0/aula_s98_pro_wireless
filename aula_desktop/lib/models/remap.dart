import '../protocol/key_map.dart';
import '../protocol/remap_protocol.dart';

/// HID consumer control usage codes for media remaps (action 0x03).
enum ConsumerMediaAction {
  playPause(0xCD),
  stop(0xB7),
  previous(0xB6),
  next(0xB5),
  volumeUp(0xE9),
  volumeDown(0xEA),
  mute(0xE2);

  const ConsumerMediaAction(this.code);

  final int code;

  static ConsumerMediaAction? fromCode(int code) {
    for (final action in values) {
      if (action.code == code) return action;
    }
    return null;
  }
}

enum RemapTargetKind {
  consumer,
  key,
}

class RemapBinding {
  const RemapBinding({
    required this.sourceIndex,
    required this.sourceLabel,
    required this.targetKind,
    this.consumerAction,
    this.targetKeyIndex,
    this.targetKeyLabel,
    this.fnLayer = false,
    this.pendingDelete = false,
  });

  final int sourceIndex;
  final String sourceLabel;
  final RemapTargetKind targetKind;
  final ConsumerMediaAction? consumerAction;
  final int? targetKeyIndex;
  final String? targetKeyLabel;
  final bool fnLayer;
  final bool pendingDelete;

  bool get isActive => !pendingDelete;

  String targetDescription({
    required String Function(ConsumerMediaAction action) mediaLabel,
  }) {
    return switch (targetKind) {
      RemapTargetKind.consumer =>
        mediaLabel(consumerAction ?? ConsumerMediaAction.playPause),
      RemapTargetKind.key =>
        targetKeyLabel ?? KeyboardKeyMap.labelForIndex(targetKeyIndex),
    };
  }

  RemapBinding copyWith({
    int? sourceIndex,
    String? sourceLabel,
    RemapTargetKind? targetKind,
    ConsumerMediaAction? consumerAction,
    int? targetKeyIndex,
    String? targetKeyLabel,
    bool? fnLayer,
    bool? pendingDelete,
    bool clearConsumer = false,
    bool clearTargetKey = false,
  }) {
    return RemapBinding(
      sourceIndex: sourceIndex ?? this.sourceIndex,
      sourceLabel: sourceLabel ?? this.sourceLabel,
      targetKind: targetKind ?? this.targetKind,
      consumerAction:
          clearConsumer ? null : consumerAction ?? this.consumerAction,
      targetKeyIndex:
          clearTargetKey ? null : targetKeyIndex ?? this.targetKeyIndex,
      targetKeyLabel:
          clearTargetKey ? null : targetKeyLabel ?? this.targetKeyLabel,
      fnLayer: fnLayer ?? this.fnLayer,
      pendingDelete: pendingDelete ?? this.pendingDelete,
    );
  }

  bool matches(RemapBinding other) {
    return sourceIndex == other.sourceIndex &&
        sourceLabel == other.sourceLabel &&
        targetKind == other.targetKind &&
        consumerAction == other.consumerAction &&
        targetKeyIndex == other.targetKeyIndex &&
        targetKeyLabel == other.targetKeyLabel &&
        fnLayer == other.fnLayer;
  }

  KeyRemap toKeyRemap() {
    return switch (targetKind) {
      RemapTargetKind.consumer => KeyRemap.consumer(
          sourceIndex: sourceIndex,
          consumerCode: consumerAction!.code,
        ),
      RemapTargetKind.key => KeyRemap.keyTarget(
          sourceIndex: sourceIndex,
          hidCode: KeyboardKeyMap.byIndex(targetKeyIndex!)!.hidCode,
        ),
    };
  }

  Map<String, Object?> toJson() => {
        'sourceIndex': sourceIndex,
        'sourceLabel': sourceLabel,
        'targetKind': targetKind.name,
        'consumerCode': consumerAction?.code,
        'targetKeyIndex': targetKeyIndex,
        'targetKeyLabel': targetKeyLabel,
        'fnLayer': fnLayer,
        'pendingDelete': pendingDelete,
      };

  factory RemapBinding.fromJson(Map<String, dynamic> json) {
    final targetKindName = json['targetKind'] as String? ?? 'consumer';
    final targetKind = RemapTargetKind.values.firstWhere(
      (kind) => kind.name == targetKindName,
      orElse: () => RemapTargetKind.consumer,
    );
    final consumerCode = (json['consumerCode'] as num?)?.toInt();
    final sourceIndex = (json['sourceIndex'] as num?)?.toInt() ?? 0;
    final targetKeyIndex = (json['targetKeyIndex'] as num?)?.toInt();

    return RemapBinding(
      sourceIndex: sourceIndex,
      sourceLabel: json['sourceLabel'] as String? ??
          KeyboardKeyMap.labelForIndex(sourceIndex),
      targetKind: targetKind,
      consumerAction: consumerCode == null
          ? null
          : ConsumerMediaAction.fromCode(consumerCode),
      targetKeyIndex: targetKeyIndex,
      targetKeyLabel: json['targetKeyLabel'] as String? ??
          KeyboardKeyMap.labelForIndex(targetKeyIndex),
      fnLayer: json['fnLayer'] as bool? ?? false,
      pendingDelete: json['pendingDelete'] as bool? ?? false,
    );
  }
}

List<RemapBinding> activeRemapBindings(Iterable<RemapBinding> bindings) {
  return bindings.where((binding) => binding.isActive).toList();
}

bool remapBindingsChanged(
  List<RemapBinding> applied,
  List<RemapBinding> draft,
) {
  final normalize = (List<RemapBinding> bindings) {
    final next = activeRemapBindings(bindings)
      ..sort((a, b) {
        final layer = a.fnLayer == b.fnLayer ? 0 : (a.fnLayer ? 1 : -1);
        if (layer != 0) return layer;
        return a.sourceIndex.compareTo(b.sourceIndex);
      });
    return next;
  };

  final appliedActive = normalize(applied);
  final draftActive = normalize(draft);
  if (appliedActive.length != draftActive.length) return true;
  for (var i = 0; i < appliedActive.length; i++) {
    if (!appliedActive[i].matches(draftActive[i])) return true;
  }
  return draft.any((binding) => binding.pendingDelete);
}
