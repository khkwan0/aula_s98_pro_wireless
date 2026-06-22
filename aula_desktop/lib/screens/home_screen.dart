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
  String? _message;
  bool _loading = true;
  bool _resetting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final status = await Future(() => widget.keyboard.getStatus());
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

  Future<void> _factoryReset() async {
    final l10n = AppLocalizations.of(context)!;
    final connected = _status?.connected == true;
    if (!connected) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final dialogL10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(dialogL10n.factoryResetDialogTitle),
          content: Text(dialogL10n.factoryResetDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(dialogL10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(dialogL10n.factoryResetButton),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _resetting = true;
      _error = null;
      _message = null;
    });

    try {
      final result = await widget.keyboard.factoryReset();
      if (!mounted) return;
      setState(() => _message = l10n.factoryResetSuccess(result.lightingMode));
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = l10n.localizeError(error));
    } finally {
      if (mounted) setState(() => _resetting = false);
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
          if (_loading || _resetting) const LinearProgressIndicator(),
          if (_message != null)
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_message!),
              ),
            ),
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
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.factoryResetTitle,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.factoryResetSubtitle),
                    const SizedBox(height: 16),
                    FilledButton.tonalIcon(
                      onPressed: status?.connected == true && !_resetting
                          ? _factoryReset
                          : null,
                      icon: const Icon(Icons.restart_alt),
                      label: Text(l10n.factoryResetButton),
                    ),
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
