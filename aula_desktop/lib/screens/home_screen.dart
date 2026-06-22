import 'package:flutter/material.dart';

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
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 8),
          Text(
            'Native desktop controller — HID protocol implemented in Dart.',
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.outline),
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
                  title: 'Keyboard',
                  value: status?.connected == true ? 'Connected' : 'Not found',
                  subtitle: status?.controlPath ?? 'USB wired required',
                  icon: status?.connected == true ? Icons.usb : Icons.usb_off,
                  tone: status?.connected == true ? Colors.green : Colors.orange,
                ),
                _InfoCard(
                  title: 'LCD interface',
                  value: status?.lcdReady == true ? 'Ready' : 'Missing',
                  subtitle: 'Required for GIF upload',
                  icon: Icons.monitor,
                  tone: status?.lcdReady == true ? Colors.green : Colors.orange,
                ),
                _InfoCard(
                  title: 'Frame limit',
                  value: '${widget.keyboard.maxFrames} frames',
                  subtitle: '240×135 RGB565',
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
                    const Text('Requirements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    const Text('• Connect the keyboard over USB (not Bluetooth only).'),
                    const Text('• Close AULA utility software before using this app.'),
                    Text('• GIFs over ${KeyboardConstants.maxFrames} frames are trimmed automatically.'),
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
