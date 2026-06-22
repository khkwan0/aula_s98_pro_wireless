import 'package:flutter_test/flutter_test.dart';

import 'package:aula_desktop/models/remap.dart';
import 'package:aula_desktop/protocol/remap_protocol.dart';

void main() {
  test('consumer remap encodes action 0x03 with usage code', () {
    final remap = KeyRemap.consumer(
      sourceIndex: 2,
      consumerCode: ConsumerMediaAction.playPause.code,
    );
    expect(remap.action, remapActionConsumer);
    expect(remap.param1, 0xCD);

    final buffer = buildRemapBuffer([remap]);
    expect(buffer[2 * 4], remapActionConsumer);
    expect(buffer[2 * 4 + 1], 0xCD);
    expect(buffer[remapBufferSize - 2], 0xAA);
    expect(buffer[remapBufferSize - 1], 0x55);
  });

  test('binding round-trips through json', () {
    const binding = RemapBinding(
      sourceIndex: 38,
      sourceLabel: 'Q',
      targetKind: RemapTargetKind.consumer,
      consumerAction: ConsumerMediaAction.mute,
    );
    final restored = RemapBinding.fromJson(binding.toJson());
    expect(restored.sourceIndex, 38);
    expect(restored.consumerAction, ConsumerMediaAction.mute);
    expect(restored.toKeyRemap().action, remapActionConsumer);
    expect(restored.toKeyRemap().param1, 0xE2);
  });

  test('countEncodedRemaps ignores invalid source slots', () {
    final remaps = [
      const KeyRemap(sourceIndex: 0, action: remapActionConsumer, param1: 0xCD),
      KeyRemap.consumer(
        sourceIndex: 6,
        consumerCode: ConsumerMediaAction.playPause.code,
      ),
    ];
    expect(countEncodedRemaps(remaps), 1);
  });

  test('pending delete is tracked until bindings change is applied', () {
    const applied = [
      RemapBinding(
        sourceIndex: 6,
        sourceLabel: 'F5',
        targetKind: RemapTargetKind.consumer,
        consumerAction: ConsumerMediaAction.mute,
      ),
    ];
    const draft = [
      RemapBinding(
        sourceIndex: 6,
        sourceLabel: 'F5',
        targetKind: RemapTargetKind.consumer,
        consumerAction: ConsumerMediaAction.mute,
        pendingDelete: true,
      ),
    ];
    expect(remapBindingsChanged(applied, draft), isTrue);
    expect(activeRemapBindings(draft), isEmpty);
  });

  test('pending delete round-trips through json', () {
    const binding = RemapBinding(
      sourceIndex: 6,
      sourceLabel: 'F5',
      targetKind: RemapTargetKind.consumer,
      consumerAction: ConsumerMediaAction.mute,
      pendingDelete: true,
    );
    final restored = RemapBinding.fromJson(binding.toJson());
    expect(restored.pendingDelete, isTrue);
  });
}
