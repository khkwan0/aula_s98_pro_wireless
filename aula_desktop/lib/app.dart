import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'l10n/locale_config.dart';
import 'protocol/constants.dart';
import 'screens/clock_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lcd_screen.dart';
import 'screens/lighting_screen.dart';
import 'screens/macro_screen.dart';
import 'services/keyboard_service.dart';

class AulaApp extends StatefulWidget {
  AulaApp({super.key});

  @override
  State<AulaApp> createState() => _AulaAppState();
}

class _AulaAppState extends State<AulaApp> {
  final KeyboardService keyboard = KeyboardService();
  Locale? _localeOverride;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future(() => keyboard.getStatus());
    });
  }

  void _setLocale(Locale? locale) {
    setState(() => _localeOverride = locale);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: keyboard.deviceName,
      builder: (context, deviceName, _) {
        return MaterialApp(
          title: deviceName,
          debugShowCheckedModeBanner: false,
          locale: _localeOverride,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            if (_localeOverride != null) {
              return _localeOverride;
            }
            return resolveAppLocale(locale, supportedLocales);
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6750A4),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: MainShell(
            keyboard: keyboard,
            localeOverride: _localeOverride,
            onLocaleChanged: _setLocale,
          ),
        );
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.keyboard,
    required this.localeOverride,
    required this.onLocaleChanged,
  });

  final KeyboardService keyboard;
  final Locale? localeOverride;
  final ValueChanged<Locale?> onLocaleChanged;

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
    final l10n = AppLocalizations.of(context)!;
    final pages = [
      HomeScreen(keyboard: widget.keyboard),
      ClockScreen(keyboard: widget.keyboard),
      LightingScreen(keyboard: widget.keyboard),
      MacroScreen(keyboard: widget.keyboard),
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
                tooltip: l10n.deviceInfoTooltip,
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
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: Text(l10n.navHome),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.schedule_outlined),
                selectedIcon: const Icon(Icons.schedule),
                label: Text(l10n.navClock),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.light_mode_outlined),
                selectedIcon: const Icon(Icons.light_mode),
                label: Text(l10n.navRgb),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.keyboard_command_key_outlined),
                selectedIcon: const Icon(Icons.keyboard_command_key),
                label: Text(l10n.navMacro),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.gif_box_outlined),
                selectedIcon: const Icon(Icons.gif_box),
                label: Text(l10n.navLcd),
              ),
            ],
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PopupMenuButton<Locale?>(
                tooltip: l10n.language,
                icon: const Icon(Icons.translate),
                onSelected: widget.onLocaleChanged,
                itemBuilder: (context) {
                  final menuL10n = AppLocalizations.of(context)!;
                  Locale? selected = widget.localeOverride;
                  return [
                    CheckedPopupMenuItem<Locale?>(
                      value: null,
                      checked: selected == null,
                      child: Text(menuL10n.languageSystem),
                    ),
                    for (final locale in appLocaleOptions)
                      CheckedPopupMenuItem<Locale?>(
                        value: locale,
                        checked: localesMatch(selected, locale),
                        child: Text(localeLabel(menuL10n, locale)),
                      ),
                  ];
                },
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: pages,
            ),
          ),
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
    final l10n = AppLocalizations.of(context)!;
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
              _sectionTitle(theme, l10n.usbIdentification),
              _row(l10n.model, details.deviceName),
              _row(l10n.vendorId, DeviceDetails.hex(KeyboardConstants.vendorId)),
              _row(l10n.productId, DeviceDetails.hex(KeyboardConstants.productId)),
              _row(
                l10n.status,
                details.connected ? l10n.connected : l10n.notConnected,
              ),
              const SizedBox(height: 16),
              _sectionTitle(theme, l10n.controlHidInterface),
              if (control != null) ...[
                _row(l10n.path, control.path),
                _row(
                  l10n.usagePage,
                  '${DeviceDetails.hex(control.usagePage)} (${control.usagePage})',
                ),
                _row(l10n.usage, '${control.usage}'),
                _row(l10n.interface, '${control.interfaceNumber}'),
              ] else
                _row(l10n.interface, l10n.notFound),
              const SizedBox(height: 16),
              _sectionTitle(theme, l10n.lcdHidInterface),
              if (lcd != null) ...[
                _row(l10n.path, lcd.path),
                _row(
                  l10n.usagePage,
                  '${DeviceDetails.hex(lcd.usagePage)} (${lcd.usagePage})',
                ),
                _row(l10n.usage, '${lcd.usage}'),
                _row(l10n.interface, '${lcd.interfaceNumber}'),
              ] else
                _row(l10n.interface, l10n.notFound),
              const SizedBox(height: 16),
              _sectionTitle(theme, l10n.protocol),
              _row(
                l10n.hidReportSize,
                l10n.bytesUnit(KeyboardConstants.reportSize),
              ),
              _row(
                l10n.commandDelay,
                l10n.millisecondsUnit(KeyboardConstants.cmdDelayMs),
              ),
              _row(
                l10n.lcdResolution,
                l10n.resolutionValue(
                  KeyboardConstants.screenWidth,
                  KeyboardConstants.screenHeight,
                ),
              ),
              _row(
                l10n.pixelFormat,
                l10n.pixelFormatValue(KeyboardConstants.bytesPerPixel),
              ),
              _row(
                l10n.frameSize,
                l10n.bytesUnit(KeyboardConstants.frameSize),
              ),
              _row(l10n.maxFramesLabel, '${KeyboardConstants.maxFrames}'),
              _row(
                l10n.flashPageSize,
                l10n.bytesUnit(KeyboardConstants.pageSize),
              ),
              _row(
                l10n.lcdAckTimeout,
                l10n.millisecondsUnit(KeyboardConstants.lcdAckTimeoutMs),
              ),
              if (details.interfaces.length > 1) ...[
                const SizedBox(height: 16),
                _sectionTitle(
                  theme,
                  l10n.allHidInterfaces(details.interfaces.length),
                ),
                for (final iface in details.interfaces)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      l10n.interfaceSummary(
                        iface.interfaceNumber,
                        DeviceDetails.hex(iface.usagePage),
                        iface.usage,
                      ),
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
          child: Text(l10n.close),
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
