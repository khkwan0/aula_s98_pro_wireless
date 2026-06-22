import '../hid/hid_device.dart';
import 'device_protocol.dart';

Future<DateTime> syncKeyboardTime(DateTime when) async {
  final device = HidDevice.openControl();
  try {
    await beginTransaction(device);
    await clockInit(device);

    final payload = emptyReport();
    payload[0] = 0x00;
    payload[1] = 0x01;
    payload[2] = 0x5A;
    payload[3] = when.year % 2000;
    payload[4] = when.month;
    payload[5] = when.day;
    payload[6] = when.hour;
    payload[7] = when.minute;
    payload[8] = when.second;
    payload[10] = when.weekday % 7; // 0 = Sunday, matches JS getDay()
    payload[62] = 0x55;
    payload[63] = 0xAA;
    await sendCommand(device, payload, readback: true);

    await applyTransaction(device);
    return when;
  } finally {
    device.close();
  }
}
