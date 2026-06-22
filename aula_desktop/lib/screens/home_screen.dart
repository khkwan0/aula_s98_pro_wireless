import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/message_localizer.dart';
import '../protocol/constants.dart';
import '../services/keyboard_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.keyboard});

  final KeyboardService keyboard;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DeviceStatus? _status;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final status = widget.keyboard.getStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.localizeError(error);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final status = _status;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                status?.deviceName ?? widget.keyboard.deviceName.value,
                style: theme.textTheme.headlineMedium,
              ),
              const Spacer(),
              IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
            ],
          ),
          const SizedBox(height: 24),
          if (_loading) const LinearProgressIndicator(),
          if (_error != null)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!),
              ),
            )
          else ...[
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _InfoCard(
                  title: l10n.keyboardCardTitle,
                  value: status?.connected == true ? l10n.connected : l10n.notFound,
                  subtitle: status?.controlPath ?? l10n.usbWiredRequired,
                  icon: status?.connected == true ? Icons.usb : Icons.usb_off,
                  tone: status?.connected == true ? Colors.green : Colors.orange,
                ),
                _InfoCard(
                  title: l10n.lcdInterfaceCardTitle,
                  value: status?.lcdReady == true ? l10n.ready : l10n.missing,
                  subtitle: l10n.lcdInterfaceCardSubtitle,
                  icon: Icons.monitor,
                  tone: status?.lcdReady == true ? Colors.green : Colors.orange,
                ),
                _InfoCard(
                  title: l10n.frameLimitCardTitle,
                  value: l10n.frameLimitValue(widget.keyboard.maxFrames),
                  subtitle: l10n.frameLimitSubtitle,
                  icon: Icons.warning_amber,
                  tone: theme.colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.requirementsTitle,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Text(l10n.requirementUsb),
                    Text(l10n.requirementCloseUtility),
                    Text(l10n.requirementGifTrim(KeyboardConstants.maxFrames)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: tone),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(subtitle),
            ],
          ),
        ),
      ),
    );
  }
}
