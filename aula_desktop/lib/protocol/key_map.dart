import 'package:flutter/services.dart';

import 'hid_scancodes.dart';

/// A physical keyboard key identified by the vendor key index.
class KeyboardKey {
  const KeyboardKey({
    required this.index,
    required this.hidCode,
    required this.label,
  });

  final int index;
  final int hidCode;
  final String label;
}

/// Key index table from AULA rgb-keyboard.xml (F108 / S98 family).
class KeyboardKeyMap {
  KeyboardKeyMap._();

  static const List<KeyboardKey> keys = [
    KeyboardKey(index: 1, hidCode: 0x29, label: 'Esc'),
    KeyboardKey(index: 2, hidCode: 0x3A, label: 'F1'),
    KeyboardKey(index: 3, hidCode: 0x3B, label: 'F2'),
    KeyboardKey(index: 4, hidCode: 0x3C, label: 'F3'),
    KeyboardKey(index: 5, hidCode: 0x3D, label: 'F4'),
    KeyboardKey(index: 6, hidCode: 0x3E, label: 'F5'),
    KeyboardKey(index: 7, hidCode: 0x3F, label: 'F6'),
    KeyboardKey(index: 8, hidCode: 0x40, label: 'F7'),
    KeyboardKey(index: 9, hidCode: 0x41, label: 'F8'),
    KeyboardKey(index: 10, hidCode: 0x42, label: 'F9'),
    KeyboardKey(index: 11, hidCode: 0x43, label: 'F10'),
    KeyboardKey(index: 12, hidCode: 0x44, label: 'F11'),
    KeyboardKey(index: 13, hidCode: 0x45, label: 'F12'),
    KeyboardKey(index: 112, hidCode: 0x46, label: 'Print Screen'),
    KeyboardKey(index: 113, hidCode: 0x47, label: 'Scroll Lock'),
    KeyboardKey(index: 115, hidCode: 0x48, label: 'Pause'),
    KeyboardKey(index: 19, hidCode: 0x35, label: '`'),
    KeyboardKey(index: 20, hidCode: 0x1E, label: '1'),
    KeyboardKey(index: 21, hidCode: 0x1F, label: '2'),
    KeyboardKey(index: 22, hidCode: 0x20, label: '3'),
    KeyboardKey(index: 23, hidCode: 0x21, label: '4'),
    KeyboardKey(index: 24, hidCode: 0x22, label: '5'),
    KeyboardKey(index: 25, hidCode: 0x23, label: '6'),
    KeyboardKey(index: 26, hidCode: 0x24, label: '7'),
    KeyboardKey(index: 27, hidCode: 0x25, label: '8'),
    KeyboardKey(index: 28, hidCode: 0x26, label: '9'),
    KeyboardKey(index: 29, hidCode: 0x27, label: '0'),
    KeyboardKey(index: 30, hidCode: 0x2D, label: '-'),
    KeyboardKey(index: 31, hidCode: 0x2E, label: '='),
    KeyboardKey(index: 103, hidCode: 0x2A, label: 'Backspace'),
    KeyboardKey(index: 116, hidCode: 0x49, label: 'Insert'),
    KeyboardKey(index: 117, hidCode: 0x4A, label: 'Home'),
    KeyboardKey(index: 118, hidCode: 0x4B, label: 'Page Up'),
    KeyboardKey(index: 32, hidCode: 0x53, label: 'Num Lock'),
    KeyboardKey(index: 33, hidCode: 0x54, label: 'Numpad /'),
    KeyboardKey(index: 34, hidCode: 0x55, label: 'Numpad *'),
    KeyboardKey(index: 122, hidCode: 0x56, label: 'Numpad -'),
    KeyboardKey(index: 37, hidCode: 0x2B, label: 'Tab'),
    KeyboardKey(index: 38, hidCode: 0x14, label: 'Q'),
    KeyboardKey(index: 39, hidCode: 0x1A, label: 'W'),
    KeyboardKey(index: 40, hidCode: 0x08, label: 'E'),
    KeyboardKey(index: 41, hidCode: 0x15, label: 'R'),
    KeyboardKey(index: 42, hidCode: 0x17, label: 'T'),
    KeyboardKey(index: 43, hidCode: 0x1C, label: 'Y'),
    KeyboardKey(index: 44, hidCode: 0x18, label: 'U'),
    KeyboardKey(index: 45, hidCode: 0x0C, label: 'I'),
    KeyboardKey(index: 46, hidCode: 0x12, label: 'O'),
    KeyboardKey(index: 47, hidCode: 0x13, label: 'P'),
    KeyboardKey(index: 48, hidCode: 0x2F, label: '['),
    KeyboardKey(index: 49, hidCode: 0x30, label: ']'),
    KeyboardKey(index: 67, hidCode: 0x31, label: '\\'),
    KeyboardKey(index: 119, hidCode: 0x4C, label: 'Delete'),
    KeyboardKey(index: 120, hidCode: 0x4D, label: 'End'),
    KeyboardKey(index: 121, hidCode: 0x4E, label: 'Page Down'),
    KeyboardKey(index: 50, hidCode: 0x5F, label: 'Numpad 7'),
    KeyboardKey(index: 51, hidCode: 0x60, label: 'Numpad 8'),
    KeyboardKey(index: 52, hidCode: 0x61, label: 'Numpad 9'),
    KeyboardKey(index: 123, hidCode: 0x57, label: 'Numpad +'),
    KeyboardKey(index: 55, hidCode: 0x39, label: 'Caps Lock'),
    KeyboardKey(index: 56, hidCode: 0x04, label: 'A'),
    KeyboardKey(index: 57, hidCode: 0x16, label: 'S'),
    KeyboardKey(index: 58, hidCode: 0x07, label: 'D'),
    KeyboardKey(index: 59, hidCode: 0x09, label: 'F'),
    KeyboardKey(index: 60, hidCode: 0x0A, label: 'G'),
    KeyboardKey(index: 61, hidCode: 0x0B, label: 'H'),
    KeyboardKey(index: 62, hidCode: 0x0D, label: 'J'),
    KeyboardKey(index: 63, hidCode: 0x0E, label: 'K'),
    KeyboardKey(index: 64, hidCode: 0x0F, label: 'L'),
    KeyboardKey(index: 65, hidCode: 0x33, label: ';'),
    KeyboardKey(index: 66, hidCode: 0x34, label: "'"),
    KeyboardKey(index: 85, hidCode: 0x28, label: 'Enter'),
    KeyboardKey(index: 68, hidCode: 0x5C, label: 'Numpad 4'),
    KeyboardKey(index: 69, hidCode: 0x5D, label: 'Numpad 5'),
    KeyboardKey(index: 70, hidCode: 0x5E, label: 'Numpad 6'),
    KeyboardKey(index: 73, hidCode: 0xE1, label: 'LShift'),
    KeyboardKey(index: 74, hidCode: 0x1D, label: 'Z'),
    KeyboardKey(index: 75, hidCode: 0x1B, label: 'X'),
    KeyboardKey(index: 76, hidCode: 0x06, label: 'C'),
    KeyboardKey(index: 77, hidCode: 0x19, label: 'V'),
    KeyboardKey(index: 78, hidCode: 0x05, label: 'B'),
    KeyboardKey(index: 79, hidCode: 0x11, label: 'N'),
    KeyboardKey(index: 80, hidCode: 0x10, label: 'M'),
    KeyboardKey(index: 81, hidCode: 0x36, label: ','),
    KeyboardKey(index: 82, hidCode: 0x37, label: '.'),
    KeyboardKey(index: 83, hidCode: 0x38, label: '/'),
    KeyboardKey(index: 84, hidCode: 0xE5, label: 'RShift'),
    KeyboardKey(index: 101, hidCode: 0x52, label: 'Up'),
    KeyboardKey(index: 86, hidCode: 0x59, label: 'Numpad 1'),
    KeyboardKey(index: 87, hidCode: 0x5A, label: 'Numpad 2'),
    KeyboardKey(index: 88, hidCode: 0x5B, label: 'Numpad 3'),
    KeyboardKey(index: 106, hidCode: 0x58, label: 'Numpad Enter'),
    KeyboardKey(index: 91, hidCode: 0xE0, label: 'LCtrl'),
    KeyboardKey(index: 92, hidCode: 0xE3, label: 'LWin'),
    KeyboardKey(index: 93, hidCode: 0xE2, label: 'LAlt'),
    KeyboardKey(index: 94, hidCode: 0x2C, label: 'Space'),
    KeyboardKey(index: 95, hidCode: 0xE6, label: 'RAlt'),
    KeyboardKey(index: 96, hidCode: 0xAF, label: 'Fn'),
    KeyboardKey(index: 97, hidCode: 0x65, label: 'Menu'),
    KeyboardKey(index: 98, hidCode: 0xE4, label: 'RCtrl'),
    KeyboardKey(index: 99, hidCode: 0x50, label: 'Left'),
    KeyboardKey(index: 100, hidCode: 0x51, label: 'Down'),
    KeyboardKey(index: 102, hidCode: 0x4F, label: 'Right'),
    KeyboardKey(index: 104, hidCode: 0x62, label: 'Numpad 0'),
    KeyboardKey(index: 105, hidCode: 0x63, label: 'Numpad .'),
  ];

  static final Map<int, KeyboardKey> _byIndex = {
    for (final key in keys) key.index: key,
  };

  static final Map<int, KeyboardKey> _byHid = {
    for (final key in keys) key.hidCode: key,
  };

  static KeyboardKey? byIndex(int index) => _byIndex[index];

  static KeyboardKey? byHidCode(int hidCode) => _byHid[hidCode];

  static KeyboardKey? byLogicalKey(LogicalKeyboardKey logicalKey) {
    final hid = HidScancodes.logicalToHid(logicalKey);
    if (hid == null) return null;
    return byHidCode(hid);
  }

  static String labelForIndex(int? index) {
    if (index == null) return '';
    return _byIndex[index]?.label ?? '#$index';
  }

  /// Keys sorted for pickers: function row first, then the rest alphabetically.
  static List<KeyboardKey> get pickableKeys {
    final keys = List<KeyboardKey>.from(KeyboardKeyMap.keys);
    keys.sort((a, b) {
      final aFn = a.label.startsWith('F') && a.label.length <= 3;
      final bFn = b.label.startsWith('F') && b.label.length <= 3;
      if (aFn != bFn) return aFn ? -1 : 1;
      return a.label.compareTo(b.label);
    });
    return keys;
  }
}
