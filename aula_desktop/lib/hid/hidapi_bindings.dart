import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

base class HidDeviceInfo extends Struct {
  external Pointer<Utf8> path;
  @Uint16()
  external int vendor_id;
  @Uint16()
  external int product_id;
  external Pointer<Utf16> serial_number;
  @Uint16()
  external int release_number;
  external Pointer<Utf16> manufacturer_string;
  external Pointer<Utf16> product_string;
  @Uint16()
  external int usage_page;
  @Uint16()
  external int usage;
  @Int32()
  external int interface_number;
  external Pointer<HidDeviceInfo> next;
}

typedef HidEnumerateNative = Pointer<HidDeviceInfo> Function(
  Uint16 vendorId,
  Uint16 productId,
);
typedef HidEnumerateDart = Pointer<HidDeviceInfo> Function(
  int vendorId,
  int productId,
);

typedef HidFreeEnumerationNative = Void Function(Pointer<HidDeviceInfo> devs);
typedef HidFreeEnumerationDart = void Function(Pointer<HidDeviceInfo> devs);

typedef HidOpenPathNative = Pointer<Void> Function(Pointer<Utf8> path);
typedef HidOpenPathDart = Pointer<Void> Function(Pointer<Utf8> path);

typedef HidCloseNative = Void Function(Pointer<Void> device);
typedef HidCloseDart = void Function(Pointer<Void> device);

typedef HidSendFeatureReportNative = Int32 Function(
  Pointer<Void> device,
  Pointer<Uint8> data,
  IntPtr length,
);
typedef HidSendFeatureReportDart = int Function(
  Pointer<Void> device,
  Pointer<Uint8> data,
  int length,
);

typedef HidGetFeatureReportNative = Int32 Function(
  Pointer<Void> device,
  Pointer<Uint8> data,
  IntPtr length,
);
typedef HidGetFeatureReportDart = int Function(
  Pointer<Void> device,
  Pointer<Uint8> data,
  int length,
);

typedef HidWriteNative = Int32 Function(
  Pointer<Void> device,
  Pointer<Uint8> data,
  IntPtr length,
);
typedef HidWriteDart = int Function(
  Pointer<Void> device,
  Pointer<Uint8> data,
  int length,
);

typedef HidReadTimeoutNative = Int32 Function(
  Pointer<Void> device,
  Pointer<Uint8> data,
  IntPtr length,
  Int32 milliseconds,
);
typedef HidReadTimeoutDart = int Function(
  Pointer<Void> device,
  Pointer<Uint8> data,
  int length,
  int milliseconds,
);

class HidApiBindings {
  HidApiBindings._(this._lib, this.loadedFrom)
      : enumerate = _lib
            .lookupFunction<HidEnumerateNative, HidEnumerateDart>(
              'hid_enumerate',
            ),
        freeEnumeration = _lib.lookupFunction<
            HidFreeEnumerationNative,
            HidFreeEnumerationDart>('hid_free_enumeration'),
        openPath =
            _lib.lookupFunction<HidOpenPathNative, HidOpenPathDart>(
              'hid_open_path',
            ),
        close = _lib.lookupFunction<HidCloseNative, HidCloseDart>('hid_close'),
        sendFeatureReport = _lib.lookupFunction<
            HidSendFeatureReportNative,
            HidSendFeatureReportDart>('hid_send_feature_report'),
        getFeatureReport = _lib.lookupFunction<
            HidGetFeatureReportNative,
            HidGetFeatureReportDart>('hid_get_feature_report'),
        write = _lib.lookupFunction<HidWriteNative, HidWriteDart>('hid_write'),
        readTimeout = _lib.lookupFunction<
            HidReadTimeoutNative,
            HidReadTimeoutDart>('hid_read_timeout');

  final DynamicLibrary _lib;
  final String loadedFrom;
  final HidEnumerateDart enumerate;
  final HidFreeEnumerationDart freeEnumeration;
  final HidOpenPathDart openPath;
  final HidCloseDart close;
  final HidSendFeatureReportDart sendFeatureReport;
  final HidGetFeatureReportDart getFeatureReport;
  final HidWriteDart write;
  final HidReadTimeoutDart readTimeout;

  static HidApiBindings? _instance;

  static HidApiBindings get instance {
    _instance ??= HidApiBindings._load();
    return _instance!;
  }

  static List<String> _candidatePaths() {
    final paths = <String>[];

    try {
      final executable = File(Platform.resolvedExecutable);
      final exeDir = executable.parent.path;

      if (Platform.isMacOS) {
        paths.add('$exeDir/../Frameworks/libhidapi.dylib');
      } else if (Platform.isLinux) {
        paths.addAll([
          '$exeDir/lib/libhidapi-hidraw.so',
          '$exeDir/lib/libhidapi-libusb.so',
          '$exeDir/lib/libhidapi.so',
        ]);
      } else if (Platform.isWindows) {
        paths.add('$exeDir/hidapi.dll');
      }
    } catch (_) {}

    if (Platform.isLinux) {
      paths.addAll([
        'libhidapi-hidraw.so',
        'libhidapi-libusb.so',
        'libhidapi.so',
        '/usr/lib/x86_64-linux-gnu/libhidapi-hidraw.so',
        '/usr/lib/x86_64-linux-gnu/libhidapi-libusb.so',
        '/usr/lib/aarch64-linux-gnu/libhidapi-hidraw.so',
        '/usr/lib/aarch64-linux-gnu/libhidapi-libusb.so',
      ]);
    }

    return paths.toSet().toList();
  }

  static HidApiBindings _load() {
    final errors = <String>[];
    for (final path in _candidatePaths()) {
      try {
        final lib = DynamicLibrary.open(path);
        lib.lookup('hid_enumerate');
        return HidApiBindings._(lib, path);
      } catch (error) {
        errors.add('$path -> $error');
      }
    }

    throw StateError(
      'Could not load bundled hidapi library.\n'
      'Rebuild the app (flutter run -d macos) so the native library is copied into the app bundle.\n'
      'Tried:\n${errors.join('\n')}',
    );
  }
}
