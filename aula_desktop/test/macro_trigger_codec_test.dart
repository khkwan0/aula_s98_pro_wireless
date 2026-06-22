import 'package:aula_desktop/models/macro.dart';
import 'package:aula_desktop/protocol/macro_trigger_codec.dart';
import 'package:aula_desktop/protocol/remap_protocol.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizeTriggerIndices keeps single non-modifier from legacy chord', () {
    const indices = [92, 73, 57];
    expect(normalizeTriggerIndices(indices), [57]);
  });

  test('parseMacroTrigger accepts one regular key', () {
    final info = parseMacroTrigger([57]);
    expect(info.sourceIndex, 57);
    expect(info.label, 'S');
  });

  test('KeyRemap.macro encodes play once', () {
    final once = KeyRemap.macro(
      sourceIndex: 57,
      macroIndex: 0,
      playbackMode: MacroPlaybackMode.once,
      maxRepeats: 1,
    );
    expect(once.param2, 1);
    expect(once.param3, 0);
  });

  test('KeyRemap.macro encodes repeat count in param3', () {
    final twice = KeyRemap.macro(
      sourceIndex: 57,
      macroIndex: 0,
      playbackMode: MacroPlaybackMode.once,
      maxRepeats: 2,
    );
    expect(twice.param2, 1);
    expect(twice.param3, 2);
  });

  test('KeyRemap.macro encodes toggle trigger remap', () {
    final toggle = KeyRemap.macro(
      sourceIndex: 57,
      macroIndex: 0,
      playbackMode: MacroPlaybackMode.toggle,
    );
    expect(toggle.param2, 2);
    expect(toggle.param3, 0);
  });
}
