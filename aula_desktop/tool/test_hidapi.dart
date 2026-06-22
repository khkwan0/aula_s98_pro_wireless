import 'dart:ffi';
import 'dart:io';

void main() {
  final paths = <String>[
  if (Platform.isMacOS) ...[
    '${Directory.current.path}/native/hidapi/macos/libhidapi.dylib',
    '${File(Platform.resolvedExecutable).parent.parent.path}/Frameworks/libhidapi.dylib',
  ],
  if (Platform.isWindows)
    '${File(Platform.resolvedExecutable).parent.path}/hidapi.dll',
  ];

  for (final path in paths) {
    try {
      final lib = DynamicLibrary.open(path);
      lib.lookup('hid_enumerate');
      print('OK: $path');
    } catch (error) {
      print('FAIL: $path -> $error');
    }
  }
}
