import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../l10n/message_localizer.dart';
import '../protocol/constants.dart';
import '../services/keyboard_service.dart';
import '../utils/color_rgb.dart';

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
  late final ValueNotifier<Color> _colorNotifier;
  late final ValueNotifier<Color> _pickerColorNotifier;
  bool _busy = false;
  String? _message;
  String? _error;
  late final TextEditingController _redController;
  late final TextEditingController _greenController;
  late final TextEditingController _blueController;
  late final FocusNode _redFocus;
  late final FocusNode _greenFocus;
  late final FocusNode _blueFocus;
  bool _updatingRgbFields = false;

  static const _directionModes = {10, 11, 12, 16, 18};
  static final _rgbInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(3),
    _RgbRangeInputFormatter(),
  ];

  @override
  void initState() {
    super.initState();
    _colorNotifier = ValueNotifier(_color);
    _pickerColorNotifier = ValueNotifier(_color);
    _redController = TextEditingController(text: '${rgbChannelsFromColor(_color).$1}');
    _greenController = TextEditingController(text: '${rgbChannelsFromColor(_color).$2}');
    _blueController = TextEditingController(text: '${rgbChannelsFromColor(_color).$3}');
    _redFocus = FocusNode();
    _greenFocus = FocusNode();
    _blueFocus = FocusNode();
    _redFocus.addListener(_onRedFocusChange);
    _greenFocus.addListener(_onGreenFocusChange);
    _blueFocus.addListener(_onBlueFocusChange);
  }

  void _onRedFocusChange() {
    if (!_redFocus.hasFocus) _commitRgbFieldInput();
  }

  void _onGreenFocusChange() {
    if (!_greenFocus.hasFocus) _commitRgbFieldInput();
  }

  void _onBlueFocusChange() {
    if (!_blueFocus.hasFocus) _commitRgbFieldInput();
  }

  @override
  void dispose() {
    _colorNotifier.dispose();
    _pickerColorNotifier.dispose();
    _redController.dispose();
    _greenController.dispose();
    _blueController.dispose();
    _redFocus.removeListener(_onRedFocusChange);
    _greenFocus.removeListener(_onGreenFocusChange);
    _blueFocus.removeListener(_onBlueFocusChange);
    _redFocus.dispose();
    _greenFocus.dispose();
    _blueFocus.dispose();
    super.dispose();
  }

  void _syncRgbFieldsFromColor() {
    final (r, g, b) = rgbChannelsFromColor(_color);
    _updatingRgbFields = true;
    _redController.text = r.toString();
    _greenController.text = g.toString();
    _blueController.text = b.toString();
    _updatingRgbFields = false;
  }

  (int, int, int)? _rgbFromFieldText() {
    final r = int.tryParse(_redController.text.trim());
    final g = int.tryParse(_greenController.text.trim());
    final b = int.tryParse(_blueController.text.trim());
    if (r == null || g == null || b == null) return null;
    return (r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
  }

  void _setColor(Color color) {
    if (color == _color) return;
    _color = color;
    _colorNotifier.value = color;
    _pickerColorNotifier.value = color;
    _syncRgbFieldsFromColor();
  }

  void _applyRgbFieldInput({bool revertInvalid = false}) {
    if (_updatingRgbFields || _busy) return;
    final parsed = _rgbFromFieldText();
    if (parsed == null) {
      if (revertInvalid) _syncRgbFieldsFromColor();
      return;
    }
    final (r, g, b) = parsed;
    final newColor = colorFromRgb(r, g, b);
    if (newColor != _color) {
      _color = newColor;
      _colorNotifier.value = newColor;
    } else if (revertInvalid) {
      _syncRgbFieldsFromColor();
    }
    // Do not push RGB text edits into ColorPicker. flex_color_picker switches
    // to the wheel tab whenever its `color` prop changes to a non-swatch RGB.
  }

  void _commitRgbFieldInput() => _applyRgbFieldInput(revertInvalid: true);

  (int, int, int) _resolveApplyRgb() {
    final parsed = _rgbFromFieldText();
    if (parsed != null) return parsed;
    return rgbChannelsFromColor(_color);
  }

  Future<void> _apply() async {
    _commitRgbFieldInput();
    setState(() {
      _busy = true;
      _message = null;
      _error = null;
    });
    try {
      final (r, g, b) = _resolveApplyRgb();
      _color = colorFromRgb(r, g, b);
      _colorNotifier.value = _color;
      _syncRgbFieldsFromColor();
      final result = await widget.keyboard.applyLighting(
        mode: _modeId,
        r: r,
        g: g,
        b: b,
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
            ValueListenableBuilder<Color>(
              valueListenable: _pickerColorNotifier,
              builder: (context, color, _) => ColorPicker(
                color: color,
                onColorChanged: _setColor,
                width: 36,
                height: 36,
                borderRadius: 8,
                enableShadesSelection: false,
                pickersEnabled: const {
                  ColorPickerType.primary: true,
                  ColorPickerType.accent: false,
                  ColorPickerType.wheel: true,
                },
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<Color>(
              valueListenable: _colorNotifier,
              builder: (context, color, _) {
                final (r, g, b) = rgbChannelsFromColor(color);
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.colorRgbValue(r, g, b),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey('rgb-red'),
                    controller: _redController,
                    focusNode: _redFocus,
                    enabled: !_busy,
                    keyboardType: TextInputType.number,
                    inputFormatters: _rgbInputFormatters,
                    decoration: InputDecoration(
                      labelText: l10n.colorRed,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _applyRgbFieldInput(),
                    onEditingComplete: _commitRgbFieldInput,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    key: const ValueKey('rgb-green'),
                    controller: _greenController,
                    focusNode: _greenFocus,
                    enabled: !_busy,
                    keyboardType: TextInputType.number,
                    inputFormatters: _rgbInputFormatters,
                    decoration: InputDecoration(
                      labelText: l10n.colorGreen,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _applyRgbFieldInput(),
                    onEditingComplete: _commitRgbFieldInput,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    key: const ValueKey('rgb-blue'),
                    controller: _blueController,
                    focusNode: _blueFocus,
                    enabled: !_busy,
                    keyboardType: TextInputType.number,
                    inputFormatters: _rgbInputFormatters,
                    decoration: InputDecoration(
                      labelText: l10n.colorBlue,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _applyRgbFieldInput(),
                    onEditingComplete: _commitRgbFieldInput,
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

/// Keeps RGB text fields in the 0–255 range while still allowing empty input while editing.
class _RgbRangeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    final value = int.tryParse(text);
    if (value == null || value > 255) return oldValue;
    return newValue;
  }
}
