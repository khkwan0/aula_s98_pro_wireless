import 'package:aula_desktop/models/macro.dart';
import 'package:aula_desktop/protocol/macro_protocol.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildMacroBuffer keeps play_times at 1 in macro block', () {
    final info = buildMacroBuffer([
      MacroDefinition(
        name: 'Repeat',
        maxRepeats: 5,
        events: const [
          MacroEvent(hidCode: 0x04, isKeyDown: true, label: 'A'),
          MacroEvent(hidCode: 0x04, isKeyDown: false, label: 'A'),
        ],
      ),
    ]);

    expect(info.buffer[macroHeaderBytes + 2], 1);
    expect(info.buffer[macroHeaderBytes + 3], MacroDelayMode.recorded.protocolValue);
  });

  test('buildMacroBuffer uses play_times 1 for toggle mode', () {
    final info = buildMacroBuffer([
      MacroDefinition(
        name: 'Toggle',
        playbackMode: MacroPlaybackMode.toggle,
        events: const [
          MacroEvent(hidCode: 0x04, isKeyDown: true, label: 'A'),
        ],
      ),
    ]);

    expect(info.buffer[macroHeaderBytes + 2], 1);
  });

  test('buildMacroBuffer encodes custom delay metadata', () {
    final info = buildMacroBuffer([
      MacroDefinition(
        name: 'Custom delay',
        customDelayMs: 250,
        delayMode: MacroDelayMode.custom,
        events: const [
          MacroEvent(hidCode: 0x04, isKeyDown: true, label: 'A'),
        ],
      ),
    ]);

    expect(info.buffer[macroHeaderBytes + 3], MacroDelayMode.custom.protocolValue);
    expect(info.buffer[macroHeaderBytes + 4], 250 & 0xFF);
    expect(info.buffer[macroHeaderBytes + 5], (250 >> 8) & 0xFF);
  });
}
