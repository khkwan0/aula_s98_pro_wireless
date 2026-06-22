import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../l10n/message_localizer.dart';
import '../services/keyboard_service.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key, required this.keyboard});

  final KeyboardService keyboard;

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  DateTime _selected = DateTime.now();
  bool _useCustom = false;
  bool _busy = false;
  String? _message;
  String? _error;

  Future<void> _sync() async {
    setState(() {
      _busy = true;
      _message = null;
      _error = null;
    });
    try {
      final when = _useCustom ? _selected : DateTime.now();
      final synced = await widget.keyboard.syncClock(when: when);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final locale = Localizations.localeOf(context).toString();
      setState(() {
        _message = l10n.syncedTo(
          DateFormat.yMMMd(locale).add_jms().format(synced),
        );
      });
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _error = l10n.localizeError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime(2020),
      lastDate: DateTime(2099),
    );
    if (date == null || !mounted) return;
    setState(() => _selected = DateTime(
          date.year,
          date.month,
          date.day,
          _selected.hour,
          _selected.minute,
          _selected.second,
        ));
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selected),
    );
    if (time == null || !mounted) return;
    setState(() => _selected = DateTime(
          _selected.year,
          _selected.month,
          _selected.day,
          time.hour,
          time.minute,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.clockTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(l10n.clockSubtitle),
          const SizedBox(height: 24),
          SwitchListTile(
            title: Text(l10n.useCustomDateTime),
            subtitle: Text(l10n.useCustomDateTimeSubtitle),
            value: _useCustom,
            onChanged: _busy ? null : (value) => setState(() => _useCustom = value),
          ),
          if (_useCustom) ...[
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(DateFormat.yMMMMd(locale).format(_selected)),
              trailing: OutlinedButton(
                onPressed: _busy ? null : _pickDate,
                child: Text(l10n.date),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(DateFormat.jm(locale).format(_selected)),
              trailing: OutlinedButton(
                onPressed: _busy ? null : _pickTime,
                child: Text(l10n.time),
              ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy ? null : _sync,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            label: Text(_useCustom ? l10n.syncCustomTime : l10n.syncSystemTime),
          ),
          if (_message != null) ...[
            const SizedBox(height: 16),
            Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
        ],
      ),
    );
  }
}
