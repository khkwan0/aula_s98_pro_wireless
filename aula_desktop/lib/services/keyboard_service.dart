import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../hid/hid_device.dart';
import '../models/macro.dart';
import '../protocol/clock_protocol.dart' as clock;
import '../protocol/constants.dart';
import '../protocol/lcd_converter.dart';
import '../protocol/lcd_protocol.dart';
import '../protocol/lighting_protocol.dart' as lighting;
import '../protocol/macro_protocol.dart' as macro;

class DeviceStatus {
  const DeviceStatus({
    required this.connected,
    required this.deviceName,
    this.controlPath,
    this.lcdPath,
  });

  final bool connected;
  final String deviceName;
  final String? controlPath;
  final String? lcdPath;

  bool get lcdReady => lcdPath != null;
}

class DeviceDetails {
  const DeviceDetails({
    required this.connected,
    required this.deviceName,
    this.control,
    this.lcd,
    this.interfaces = const [],
  });

  final bool connected;
  final String deviceName;
  final HidDeviceDescriptor? control;
  final HidDeviceDescriptor? lcd;
  final List<HidDeviceDescriptor> interfaces;

  static String hex(int value, {int width = 4}) =>
      '0x${value.toRadixString(16).toUpperCase().padLeft(width, '0')}';
}

class KeyboardService {
  final ValueNotifier<String> deviceName = ValueNotifier(
    KeyboardConstants.fallbackDeviceName,
  );

  void _syncDeviceName(String name) {
    if (deviceName.value != name) {
      deviceName.value = name;
    }
  }

  DeviceStatus getStatus() {
    final interfaces = HidDevice.listDevices();
    final control = HidDevice.findControlInterface();
    final lcd = HidDevice.findLcdInterface();
    final name = HidDevice.resolveDeviceName(interfaces);
    _syncDeviceName(name);
    return DeviceStatus(
      connected: control != null,
      deviceName: name,
      controlPath: control?.path,
      lcdPath: lcd?.path,
    );
  }

  DeviceDetails getDeviceDetails() {
    final interfaces = HidDevice.listDevices();
    HidDeviceDescriptor? control;
    HidDeviceDescriptor? lcd;
    for (final device in interfaces) {
      if (control == null &&
          device.usagePage == KeyboardConstants.controlUsagePage) {
        control = device;
      }
      if (lcd == null &&
          device.usagePage == KeyboardConstants.lcdUsagePage &&
          device.interfaceNumber == KeyboardConstants.lcdInterface) {
        lcd = device;
      }
    }
    final name = HidDevice.resolveDeviceName(interfaces);
    _syncDeviceName(name);
    return DeviceDetails(
      connected: control != null,
      deviceName: name,
      control: control,
      lcd: lcd,
      interfaces: interfaces,
    );
  }

  Future<DateTime> syncClock({DateTime? when}) =>
      clock.syncKeyboardTime(when ?? DateTime.now());

  Future<lighting.LightingResult> applyLighting({
    required dynamic mode,
    int r = 255,
    int g = 255,
    int b = 255,
    int brightness = 5,
    int speed = 3,
    int direction = 0,
    bool colorful = false,
  }) {
    return lighting.setLighting(
      mode: mode,
      r: r,
      g: g,
      b: b,
      brightness: brightness,
      speed: speed,
      direction: direction,
      colorful: colorful,
    );
  }

  Future<lighting.LightingResult> turnOffLighting() =>
      lighting.setLighting(mode: 0);

  GifInspectInfo inspectGif(List<int> bytes) =>
      inspectGifBytes(Uint8List.fromList(bytes));

  GifConversionResult convertGif(
    List<int> bytes, {
    bool force = false,
  }) =>
      gifBytesToLcdBuffer(Uint8List.fromList(bytes), force: force);

  Future<LcdUploadResult> uploadGif(
    List<int> bytes, {
    bool force = false,
    int slot = 1,
    void Function(int sent, int total)? onProgress,
  }) async {
    final converted = gifBytesToLcdBuffer(Uint8List.fromList(bytes), force: force);
    final result = await uploadLcdBuffer(
      converted.buffer,
      imageSlot: slot,
      force: force,
      onProgress: onProgress,
    );
    return LcdUploadResult(
      frameCount: result.frameCount,
      pageCount: result.pageCount,
      source: 'gif upload',
      warnings: converted.warnings,
    );
  }

  Future<LcdUploadResult> uploadFromPath(
    String path, {
    bool force = false,
    int slot = 1,
    void Function(int sent, int total)? onProgress,
  }) =>
      uploadLcdFile(path, imageSlot: slot, force: force, onProgress: onProgress);

  Future<GifConversionResult> convertGifFileToBin(
    String gifPath,
    String binPath, {
    bool force = false,
  }) async {
    final bytes = await File(gifPath).readAsBytes();
    final converted = gifBytesToLcdBuffer(bytes, force: force);
    await saveBinFile(binPath, converted.buffer);
    return converted;
  }

  int get maxFrames => KeyboardConstants.maxFrames;

  Future<MacroUploadResult> uploadMacros(List<MacroDefinition> macros) =>
      macro.uploadMacros(macros);
}
