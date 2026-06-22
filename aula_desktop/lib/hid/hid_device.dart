import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import '../protocol/constants.dart';
import 'hidapi_bindings.dart';

class HidDeviceDescriptor {
  const HidDeviceDescriptor({
    required this.path,
    required this.vendorId,
    required this.productId,
    required this.usagePage,
    required this.usage,
    required this.interfaceNumber,
    this.productName,
    this.manufacturerName,
  });

  final String path;
  final int vendorId;
  final int productId;
  final int usagePage;
  final int usage;
  final int interfaceNumber;
  final String? productName;
  final String? manufacturerName;

  String? get displayName {
    final product = productName?.trim();
    if (product != null && product.isNotEmpty) return product;
    final manufacturer = manufacturerName?.trim();
    if (manufacturer != null && manufacturer.isNotEmpty) return manufacturer;
    return null;
  }
}

class HidDevice implements AutoCloseable {
  HidDevice._(this._bindings, this._handle, this.descriptor);

  final HidApiBindings _bindings;
  final Pointer<Void> _handle;
  final HidDeviceDescriptor descriptor;

  static List<HidDeviceDescriptor> listDevices({
    int vendorId = KeyboardConstants.vendorId,
    int productId = KeyboardConstants.productId,
  }) {
    final bindings = HidApiBindings.instance;
    final head = bindings.enumerate(vendorId, productId);
    if (head == nullptr) {
      return const [];
    }

    final devices = <HidDeviceDescriptor>[];
    var current = head;
    while (current != nullptr) {
      final info = current.ref;
      final path = info.path.toDartString();
      devices.add(
        HidDeviceDescriptor(
          path: path,
          vendorId: info.vendorId,
          productId: info.productId,
          usagePage: info.usagePage,
          usage: info.usage,
          interfaceNumber: info.interfaceNumber,
          productName: _readWideString(info.product_string),
          manufacturerName: _readWideString(info.manufacturer_string),
        ),
      );
      current = info.next;
    }
    bindings.freeEnumeration(head);
    return devices;
  }

  static HidDeviceDescriptor? findControlInterface() {
    for (final device in listDevices()) {
      if (device.usagePage == KeyboardConstants.controlUsagePage) {
        return device;
      }
    }
    return null;
  }

  static HidDeviceDescriptor? findLcdInterface() {
    for (final device in listDevices()) {
      if (device.usagePage == KeyboardConstants.lcdUsagePage &&
          device.interfaceNumber == KeyboardConstants.lcdInterface) {
        return device;
      }
    }
    return null;
  }

  static HidDevice open(HidDeviceDescriptor descriptor) {
    final bindings = HidApiBindings.instance;
    final pathPtr = descriptor.path.toNativeUtf8();
    try {
      final handle = bindings.openPath(pathPtr);
      if (handle == nullptr) {
        throw StateError('Could not open HID device at ${descriptor.path}');
      }
      return HidDevice._(bindings, handle, descriptor);
    } finally {
      malloc.free(pathPtr);
    }
  }

  static String resolveDeviceName([List<HidDeviceDescriptor>? devices]) {
    for (final device in devices ?? listDevices()) {
      final name = device.displayName;
      if (name != null) return name;
    }
    return KeyboardConstants.fallbackDeviceName;
  }

  static HidDevice openControl() {
    final descriptor = findControlInterface();
    if (descriptor == null) {
      throw StateError(
        '${resolveDeviceName()} not found. Connect via USB-C cable.',
      );
    }
    return open(descriptor);
  }

  static HidDevice openLcd() {
    final descriptor = findLcdInterface();
    if (descriptor == null) {
      throw StateError(
        '${resolveDeviceName()} LCD interface not found. Connect via USB-C cable.',
      );
    }
    return open(descriptor);
  }

  void sendFeatureReport(Uint8List payload64) {
    if (payload64.length != KeyboardConstants.reportSize) {
      throw ArgumentError('Feature report must be exactly 64 bytes.');
    }

    final report = calloc<Uint8>(KeyboardConstants.reportSize + 1);
    try {
      report[0] = 0x00;
      for (var i = 0; i < payload64.length; i++) {
        report[i + 1] = payload64[i];
      }
      final result = _bindings.sendFeatureReport(
        _handle,
        report,
        KeyboardConstants.reportSize + 1,
      );
      if (result < 0) {
        throw StateError('hid_send_feature_report failed ($result)');
      }
    } finally {
      calloc.free(report);
    }
  }

  Uint8List getFeatureReport() {
    final report = calloc<Uint8>(KeyboardConstants.reportSize + 1);
    try {
      report[0] = 0x00;
      final result = _bindings.getFeatureReport(
        _handle,
        report,
        KeyboardConstants.reportSize + 1,
      );
      if (result < 0) {
        throw StateError('hid_get_feature_report failed ($result)');
      }
      return Uint8List.fromList(
        report.asTypedList(KeyboardConstants.reportSize + 1).sublist(1),
      );
    } finally {
      calloc.free(report);
    }
  }

  void writeOutputReport(Uint8List payload) {
    final report = calloc<Uint8>(payload.length + 1);
    try {
      report[0] = 0x00;
      for (var i = 0; i < payload.length; i++) {
        report[i + 1] = payload[i];
      }
      final result = _bindings.write(_handle, report, payload.length + 1);
      if (result < 0) {
        throw StateError('hid_write failed ($result)');
      }
    } finally {
      calloc.free(report);
    }
  }

  Uint8List? readTimeout(int milliseconds, {int length = 65}) {
    final buffer = calloc<Uint8>(length);
    try {
      final result = _bindings.readTimeout(
        _handle,
        buffer,
        length,
        milliseconds,
      );
      if (result <= 0) {
        return null;
      }
      final data = buffer.asTypedList(result);
      if (data.isNotEmpty && data[0] == 0x00) {
        return Uint8List.fromList(data.sublist(1));
      }
      return Uint8List.fromList(data);
    } finally {
      calloc.free(buffer);
    }
  }

  @override
  void close() {
    _bindings.close(_handle);
  }
}

abstract interface class AutoCloseable {
  void close();
}

String? _readWideString(Pointer<Utf16>? pointer) {
  if (pointer == null || pointer == nullptr) {
    return null;
  }

  // hidapi exposes wchar_t strings. Windows wchar_t is UTF-16; macOS/Linux use UTF-32.
  final decoded = Platform.isWindows
      ? pointer.toDartString()
      : _readUtf32String(pointer);

  final trimmed = decoded.trim();
  if (trimmed.isEmpty || trimmed.length == 1) {
    return null;
  }
  return trimmed;
}

String _readUtf32String(Pointer<Utf16> pointer) {
  final codeUnits = <int>[];
  final values = pointer.cast<Uint32>();
  var index = 0;
  while (true) {
    final value = values[index];
    if (value == 0) {
      break;
    }
    codeUnits.add(value);
    index++;
  }
  return String.fromCharCodes(codeUnits);
}

extension _HidDeviceInfoX on HidDeviceInfo {
  int get vendorId => vendor_id;
  int get productId => product_id;
  int get usagePage => usage_page;
  int get interfaceNumber => interface_number;
}
