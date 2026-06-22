import 'dart:typed_data';

import '../hid/hid_device.dart';
import 'constants.dart';

Future<void> delayCmd() =>
    Future<void>.delayed(const Duration(milliseconds: KeyboardConstants.cmdDelayMs));

Uint8List emptyReport() => Uint8List(KeyboardConstants.reportSize);

Future<void> sendCommand(
  HidDevice device,
  Uint8List payload, {
  required bool readback,
}) async {
  final report = emptyReport();
  final copyLength = payload.length.clamp(0, KeyboardConstants.reportSize);
  report.setRange(0, copyLength, payload.sublist(0, copyLength));
  device.sendFeatureReport(report);
  await delayCmd();

  if (readback) {
    device.getFeatureReport();
    await delayCmd();
  }
}

Future<void> beginTransaction(HidDevice device) =>
    sendCommand(device, Uint8List.fromList([0x04, 0x18]), readback: true);

Future<void> applyTransaction(HidDevice device) =>
    sendCommand(device, Uint8List.fromList([0x04, 0x02]), readback: true);

Future<void> finalizeTransaction(HidDevice device) =>
    sendCommand(device, Uint8List.fromList([0x04, 0xF0]), readback: false);

Future<void> lightingInit(HidDevice device) async {
  final payload = emptyReport();
  payload[0] = 0x04;
  payload[1] = 0x13;
  payload[8] = 0x01;
  await sendCommand(device, payload, readback: true);
}

Future<void> clockInit(HidDevice device) async {
  final payload = emptyReport();
  payload[0] = 0x04;
  payload[1] = 0x28;
  payload[8] = 0x01;
  await sendCommand(device, payload, readback: true);
}

Future<void> lcdImageHeader(
  HidDevice device, {
  required int imageSlot,
  required int pageCount,
}) async {
  final payload = emptyReport();
  payload[0] = 0x04;
  payload[1] = 0x72;
  payload[2] = imageSlot;
  payload[8] = pageCount & 0xFF;
  payload[9] = (pageCount >> 8) & 0xFF;
  await sendCommand(device, payload, readback: true);
}
