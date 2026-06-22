import 'package:flutter/material.dart';

import 'protocol/constants.dart';
import 'screens/clock_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lcd_screen.dart';
import 'screens/lighting_screen.dart';
import 'services/keyboard_service.dart';

class AulaApp extends StatefulWidget {
  AulaApp({super.key});

  @override
  State<AulaApp> createState() => _AulaAppState();
}

class _AulaAppState extends State<AulaApp> {
  final KeyboardService keyboard = KeyboardService();

  @override
  void initState() {
    super.initState();
    keyboard.getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: keyboard.deviceName,
      builder: (context, deviceName, _) {
        return MaterialApp(
          title: deviceName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6750A4),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: MainShell(keyboard: keyboard),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.keyboard});

  final KeyboardService keyboard;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _showDeviceInfo() {
    final details = widget.keyboard.getDeviceDetails();
    showDialog<void>(
      context: context,
      builder: (context) => _DeviceInfoDialog(details: details),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(keyboard: widget.keyboard),
      ClockScreen(keyboard: widget.keyboard),
      LightingScreen(keyboard: widget.keyboard),
      LcdScreen(keyboard: widget.keyboard),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() => _index = value),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: IconButton(
                tooltip: 'Device info',
                onPressed: _showDeviceInfo,
                style: IconButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  Icons.keyboard,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.schedule_outlined),
                selectedIcon: Icon(Icons.schedule),
                label: Text('Clock'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.light_mode_outlined),
                selectedIcon: Icon(Icons.light_mode),
                label: Text('RGB'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.gif_box_outlined),
                selectedIcon: Icon(Icons.gif_box),
                label: Text('LCD'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[_index]),
        ],
      ),
    );
  }
}

class _DeviceInfoDialog extends StatelessWidget {
  const _DeviceInfoDialog({required this.details});

  final DeviceDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final control = details.control;
    final lcd = details.lcd;

    return AlertDialog(
      title: Text(details.deviceName),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle(theme, 'USB identification'),
              _row('Model', details.deviceName),
              _row('Vendor ID', DeviceDetails.hex(KeyboardConstants.vendorId)),
              _row('Product ID', DeviceDetails.hex(KeyboardConstants.productId)),
              _row(
                'Status',
                details.connected ? 'Connected' : 'Not connected',
              ),
              const SizedBox(height: 16),
              _sectionTitle(theme, 'Control HID interface'),
              if (control != null) ...[
                _row('Path', control.path),
                _row(
                  'Usage page',
                  '${DeviceDetails.hex(control.usagePage)} (${control.usagePage})',
                ),
                _row('Usage', '${control.usage}'),
                _row('Interface', '${control.interfaceNumber}'),
              ] else
                _row('Interface', 'Not found'),
              const SizedBox(height: 16),
              _sectionTitle(theme, 'LCD HID interface'),
              if (lcd != null) ...[
                _row('Path', lcd.path),
                _row(
                  'Usage page',
                  '${DeviceDetails.hex(lcd.usagePage)} (${lcd.usagePage})',
                ),
                _row('Usage', '${lcd.usage}'),
                _row('Interface', '${lcd.interfaceNumber}'),
              ] else
                _row('Interface', 'Not found'),
              const SizedBox(height: 16),
              _sectionTitle(theme, 'Protocol'),
              _row('HID report size', '${KeyboardConstants.reportSize} bytes'),
              _row('Command delay', '${KeyboardConstants.cmdDelayMs} ms'),
              _row(
                'LCD resolution',
                '${KeyboardConstants.screenWidth}×${KeyboardConstants.screenHeight}',
              ),
              _row('Pixel format', 'RGB565 (${KeyboardConstants.bytesPerPixel} bytes/pixel)'),
              _row(
                'Frame size',
                '${KeyboardConstants.frameSize} bytes',
              ),
              _row('Max frames', '${KeyboardConstants.maxFrames}'),
              _row('Flash page size', '${KeyboardConstants.pageSize} bytes'),
              _row('LCD ACK timeout', '${KeyboardConstants.lcdAckTimeoutMs} ms'),
              if (details.interfaces.length > 1) ...[
                const SizedBox(height: 16),
                _sectionTitle(
                  theme,
                  'All HID interfaces (${details.interfaces.length})',
                ),
                for (final iface in details.interfaces)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'IF${iface.interfaceNumber}: '
                      '${DeviceDetails.hex(iface.usagePage)} usage ${iface.usage}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
