import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../l10n/message_localizer.dart';
import '../protocol/constants.dart';
import '../services/keyboard_service.dart';

class LightingScreen extends StatefulWidget {
  const LightingScreen({super.key, required this.keyboard});

  final KeyboardService keyboard;

  @override
  State<LightingScreen> createState() => _LightingScreenState();
}

class _LightingScreenState extends State<LightingScreen> {
  int _modeId = 7;
  int _brightness = 5;
  int _speed = 3;
  int _direction = 0;
  bool _colorful = false;
  Color _color = Colors.blue;
  bool _busy = false;
  String? _message;
  String? _error;
  late final TextEditingController _redController;
  late final TextEditingController _greenController;
  late final TextEditingController _blueController;
  bool _updatingRgbFields = false;

  static const _directionModes = {10, 11, 12, 16, 18};
  static final _rgbInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(3),
  ];

  @override
  void initState() {
    super.initState();
    _redController = TextEditingController(text: _color.red.toString());
    _greenController = TextEditingController(text: _color.green.toString());
    _blueController = TextEditingController(text: _color.blue.toString());
  }

  @override
  void dispose() {
    _redController.dispose();
    _greenController.dispose();
    _blueController.dispose();
    super.dispose();
  }

  void _syncRgbFieldsFromColor() {
    _updatingRgbFields = true;
    _redController.text = _color.red.toString();
    _greenController.text = _color.green.toString();
    _blueController.text = _color.blue.toString();
    _updatingRgbFields = false;
  }

  void _setColor(Color color) {
    if (color == _color) return;
    setState(() => _color = color);
    _syncRgbFieldsFromColor();
  }

  void _applyRgbFieldInput() {
    if (_updatingRgbFields || _busy) return;
    final r = int.tryParse(_redController.text);
    final g = int.tryParse(_greenController.text);
    final b = int.tryParse(_blueController.text);
    if (r == null || g == null || b == null) {
      _syncRgbFieldsFromColor();
      return;
    }
    _setColor(Color.fromARGB(255, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255)));
  }

  Future<void> _apply() async {
    setState(() {
      _busy = true;
      _message = null;
      _error = null;
    });
    try {
      final result = await widget.keyboard.applyLighting(
        mode: _modeId,
        r: _color.red,
        g: _color.green,
        b: _color.blue,
        brightness: _brightness,
        speed: _speed,
        direction: _direction,
        colorful: _colorful,
      );
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _message = l10n.appliedMode(l10n.lightingModeName(result.modeId)));
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _error = l10n.localizeError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _turnOff() async {
    setState(() {
      _busy = true;
      _message = null;
      _error = null;
    });
    try {
      await widget.keyboard.turnOffLighting();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _modeId = 0;
        _message = l10n.backlightTurnedOff;
      });
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _error = l10n.localizeError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showColor = _modeId != 0 && _modeId != 6 && _modeId != 8;
    final showDirection = _directionModes.contains(_modeId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.rgbTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(l10n.rgbSubtitle),
          const SizedBox(height: 24),
          DropdownButtonFormField<int>(
            value: _modeId,
            decoration: InputDecoration(labelText: l10n.mode, border: const OutlineInputBorder()),
            items: [
              for (var i = 0; i < lightingModeNames.length; i++)
                DropdownMenuItem(
                  value: i,
                  child: Text(
                    l10n.lightingModeEntry(
                      i.toString().padLeft(2),
                      l10n.lightingModeName(i),
                    ),
                  ),
                ),
            ],
            onChanged: _busy
                ? null
                : (value) => setState(() {
                      _modeId = value ?? _modeId;
                      if (_modeId == 6 || _modeId == 8) _colorful = true;
                    }),
          ),
          const SizedBox(height: 16),
          if (_modeId != 0 && _modeId != 6 && _modeId != 8)
            SwitchListTile(
              title: Text(l10n.rainbowColorful),
              value: _colorful,
              onChanged: _busy ? null : (value) => setState(() => _colorful = value),
            ),
          if (showColor && !_colorful) ...[
            const SizedBox(height: 8),
            ColorPicker(
              color: _color,
              onColorChanged: _setColor,
              width: 36,
              height: 36,
              borderRadius: 8,
              pickersEnabled: const {ColorPickerType.wheel: true, ColorPickerType.primary: true},
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.colorRgbValue(_color.red, _color.green, _color.blue),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _redController,
                    enabled: !_busy,
                    keyboardType: TextInputType.number,
                    inputFormatters: _rgbInputFormatters,
                    decoration: InputDecoration(
                      labelText: l10n.colorRed,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _applyRgbFieldInput(),
                    onEditingComplete: _applyRgbFieldInput,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _greenController,
                    enabled: !_busy,
                    keyboardType: TextInputType.number,
                    inputFormatters: _rgbInputFormatters,
                    decoration: InputDecoration(
                      labelText: l10n.colorGreen,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _applyRgbFieldInput(),
                    onEditingComplete: _applyRgbFieldInput,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _blueController,
                    enabled: !_busy,
                    keyboardType: TextInputType.number,
                    inputFormatters: _rgbInputFormatters,
                    decoration: InputDecoration(
                      labelText: l10n.colorBlue,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _applyRgbFieldInput(),
                    onEditingComplete: _applyRgbFieldInput,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Text(l10n.brightness(_brightness)),
          Slider(
            min: 0,
            max: 5,
            divisions: 5,
            value: _brightness.toDouble(),
            label: _brightness.toString(),
            onChanged: _busy ? null : (value) => setState(() => _brightness = value.round()),
          ),
          if (_modeId != 0 && _modeId != 1) ...[
            Text(l10n.speed(_speed)),
            Slider(
              min: 0,
              max: 5,
              divisions: 5,
              value: _speed.toDouble(),
              label: _speed.toString(),
              onChanged: _busy ? null : (value) => setState(() => _speed = value.round()),
            ),
          ],
          if (showDirection) ...[
            Text(l10n.direction(_direction)),
            Slider(
              min: 0,
              max: 3,
              divisions: 3,
              value: _direction.toDouble(),
              label: _direction.toString(),
              onChanged: _busy ? null : (value) => setState(() => _direction = value.round()),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              FilledButton.icon(
                onPressed: _busy ? null : _apply,
                icon: const Icon(Icons.check),
                label: Text(l10n.apply),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _turnOff,
                icon: const Icon(Icons.power_settings_new),
                label: Text(l10n.turnOff),
              ),
            ],
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
