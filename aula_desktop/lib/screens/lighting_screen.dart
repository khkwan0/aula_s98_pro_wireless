import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

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

  static const _directionModes = {10, 11, 12, 16, 18};

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
      setState(() => _message = 'Applied ${result.modeName}');
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
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
      setState(() {
        _modeId = 0;
        _message = 'Backlight turned off';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showColor = _modeId != 0 && _modeId != 6 && _modeId != 8;
    final showDirection = _directionModes.contains(_modeId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RGB Lighting', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Set backlight mode, color, brightness, and speed.'),
          const SizedBox(height: 24),
          DropdownButtonFormField<int>(
            value: _modeId,
            decoration: const InputDecoration(labelText: 'Mode', border: OutlineInputBorder()),
            items: [
              for (var i = 0; i < lightingModeNames.length; i++)
                DropdownMenuItem(value: i, child: Text('${i.toString().padLeft(2)} — ${lightingModeNames[i]}')),
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
              title: const Text('Rainbow / colorful'),
              value: _colorful,
              onChanged: _busy ? null : (value) => setState(() => _colorful = value),
            ),
          if (showColor && !_colorful) ...[
            const SizedBox(height: 8),
            ColorPicker(
              color: _color,
              onColorChanged: (color) => setState(() => _color = color),
              width: 36,
              height: 36,
              borderRadius: 8,
              pickersEnabled: const {ColorPickerType.wheel: true, ColorPickerType.primary: true},
            ),
          ],
          const SizedBox(height: 16),
          Text('Brightness: $_brightness'),
          Slider(
            min: 0,
            max: 5,
            divisions: 5,
            value: _brightness.toDouble(),
            label: _brightness.toString(),
            onChanged: _busy ? null : (value) => setState(() => _brightness = value.round()),
          ),
          if (_modeId != 0 && _modeId != 1) ...[
            Text('Speed: $_speed'),
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
            Text('Direction: $_direction'),
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
                label: const Text('Apply'),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _turnOff,
                icon: const Icon(Icons.power_settings_new),
                label: const Text('Turn off'),
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
