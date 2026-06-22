import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../l10n/message_localizer.dart';
import '../models/macro.dart';
import '../protocol/key_map.dart' as keymap;
import '../protocol/hid_scancodes.dart';
import '../protocol/macro_trigger_codec.dart';
import '../services/keyboard_service.dart';
import '../services/macro_storage.dart';

class MacroScreen extends StatefulWidget {
  const MacroScreen({super.key, required this.keyboard});

  final KeyboardService keyboard;

  @override
  State<MacroScreen> createState() => _MacroScreenState();
}

class _MacroScreenState extends State<MacroScreen> {
  static const _maxMacros = 10;

  final FocusNode _recordFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _customDelayController = TextEditingController();
  final TextEditingController _maxRepeatsController = TextEditingController();

  static final _maxRepeatsInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(2),
  ];

  List<MacroDefinition> _macros = List<MacroDefinition>.from(defaultMacros());
  int _selectedIndex = 0;
  bool _recording = false;
  bool _assigningTrigger = false;
  bool _busy = false;
  String? _message;
  String? _error;
  DateTime? _lastEventTime;
  final Set<LogicalKeyboardKey> _pressedKeys = {};
  Timer? _persistTimer;
  bool _loadingMacros = true;

  MacroDefinition get _selected => _macros[_selectedIndex];

  @override
  void initState() {
    super.initState();
    _loadMacros();
  }

  Future<void> _loadMacros() async {
    final macros = await MacroStorage.load();
    if (!mounted) return;
    setState(() {
      _macros = List<MacroDefinition>.from(macros);
      _selectedIndex = _selectedIndex.clamp(0, _macros.length - 1);
      _loadingMacros = false;
      _syncEditorsFromSelected();
    });
  }

  void _schedulePersist() {
    _persistTimer?.cancel();
    _persistTimer = Timer(const Duration(milliseconds: 250), () {
      MacroStorage.save(_macros);
    });
  }

  void _persistNow() {
    _persistTimer?.cancel();
    MacroStorage.saveSync(_macros);
  }

  @override
  void dispose() {
    _persistTimer?.cancel();
    MacroStorage.saveSync(_macros);
    _recordFocusNode.dispose();
    _nameController.dispose();
    _customDelayController.dispose();
    _maxRepeatsController.dispose();
    super.dispose();
  }

  void _syncEditorsFromSelected() {
    _nameController.text = _selected.name;
    _customDelayController.text = '${_selected.customDelayMs}';
    _maxRepeatsController.text = '${_selected.maxRepeats}';
  }

  int _maxRepeatsFromInput() {
    final parsed = int.tryParse(_maxRepeatsController.text.trim());
    if (parsed == null || parsed < 1) return 1;
    return parsed.clamp(1, MacroDefinition.maxRepeatsLimit);
  }

  void _applyMaxRepeatsInput() {
    final maxRepeats = _maxRepeatsFromInput();
    if (maxRepeats != _selected.maxRepeats) {
      _updateSelected(_selected.copyWith(maxRepeats: maxRepeats));
    }
    final text = '$maxRepeats';
    if (_maxRepeatsController.text != text) {
      _maxRepeatsController.text = text;
    }
  }

  void _selectMacro(int index) {
    if (_recording || _assigningTrigger || _busy) return;
    setState(() {
      _selectedIndex = index;
      _syncEditorsFromSelected();
      _message = null;
      _error = null;
    });
  }

  void _updateSelected(
    MacroDefinition macro, {
    bool persistImmediately = false,
  }) {
    final next = List<MacroDefinition>.from(_macros);
    next[_selectedIndex] = macro;
    setState(() => _macros = next);
    if (persistImmediately) {
      _persistNow();
    } else {
      _schedulePersist();
    }
  }

  void _addMacro() {
    if (_macros.length >= _maxMacros || _recording || _busy) return;
    final macros = [
      ..._macros,
      MacroDefinition(name: 'Macro ${_macros.length + 1}'),
    ];
    setState(() {
      _macros = macros;
      _selectedIndex = macros.length - 1;
      _syncEditorsFromSelected();
    });
    _schedulePersist();
  }

  void _deleteMacro() {
    if (_macros.length <= 1 || _recording || _assigningTrigger || _busy) return;
    final macros = List<MacroDefinition>.from(_macros)..removeAt(_selectedIndex);
    setState(() {
      _macros = macros;
      if (_selectedIndex >= _macros.length) {
        _selectedIndex = _macros.length - 1;
      }
      _syncEditorsFromSelected();
    });
    _schedulePersist();
  }

  void _clearEvents() {
    if (_recording || _assigningTrigger || _busy) return;
    final next = List<MacroDefinition>.from(_macros);
    next[_selectedIndex] = _selected.copyWith(clearEvents: true);
    setState(() => _macros = next);
    _persistNow();
    _syncMacrosToKeyboard(successOnClear: true);
  }

  Future<void> _syncMacrosToKeyboard({bool successOnClear = false}) async {
    setState(() {
      _busy = true;
      _message = null;
      _error = null;
    });

    try {
      final macros = List<MacroDefinition>.from(_macros);
      final name = _nameController.text.trim();
      if (name.isNotEmpty) {
        macros[_selectedIndex] = macros[_selectedIndex].copyWith(name: name);
      }
      _applyMaxRepeatsInput();
      macros[_selectedIndex] = macros[_selectedIndex].copyWith(
        maxRepeats: _selected.playbackMode == MacroPlaybackMode.once
            ? _maxRepeatsFromInput()
            : 1,
        playbackMode: _selected.playbackMode,
      );
      final result = await widget.keyboard.uploadMacrosWithBindings(macros);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        if (successOnClear || result.upload.macroCount == 0) {
          _message = l10n.macroEventsCleared;
        } else if (result.bindings!.bindingCount > 0) {
          _message = l10n.macroUploadedWithBinding(
            result.upload.macroCount,
            result.upload.eventCount,
            result.bindings!.bindingCount,
          );
        } else {
          _message = l10n.macroUploadedAssignTrigger(
            result.upload.macroCount,
            result.upload.eventCount,
          );
        }
      });
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _error = l10n.localizeError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _upload() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty && name != _selected.name) {
      _updateSelected(_selected.copyWith(name: name));
    }
    _applyMaxRepeatsInput();
    await _syncMacrosToKeyboard();
  }

  void _removeEvent(int index) {
    if (_recording || _busy) return;
    final events = List<MacroEvent>.from(_selected.events)..removeAt(index);
    _updateSelected(_selected.copyWith(events: events));
  }

  void _startAssigningTrigger() {
    if (_busy || _recording) return;
    setState(() {
      _assigningTrigger = true;
      _message = null;
      _error = null;
    });
    _recordFocusNode.requestFocus();
  }

  void _stopAssigningTrigger() {
    if (!_assigningTrigger) return;
    setState(() {
      _assigningTrigger = false;
    });
  }

  String _triggerErrorForCode(String code) {
    final l10n = AppLocalizations.of(context)!;
    return switch (code) {
      'modifierNotAllowed' => l10n.errorMacroTriggerModifierNotAllowed,
      'singleKeyOnly' => l10n.errorMacroTriggerSingleKeyOnly,
      _ => l10n.errorMacroUnsupportedTriggerKey,
    };
  }

  void _assignTriggerKey(keymap.KeyboardKey key) {
    try {
      final info = parseMacroTrigger([key.index]);
      _updateSelected(
        _selected.copyWith(
          triggerKeyIndices: [info.sourceIndex],
          triggerKeyLabel: info.label,
        ),
      );
      setState(() {
        _assigningTrigger = false;
        _error = null;
      });
    } on MacroTriggerFormatException catch (error) {
      if (!mounted) return;
      setState(() => _error = _triggerErrorForCode(error.code));
    }
  }

  void _clearTrigger() {
    if (_busy || _recording || _assigningTrigger) return;
    _updateSelected(
      _selected.copyWith(clearTrigger: true),
      persistImmediately: true,
    );
    _syncMacrosToKeyboard();
  }

  void _startRecording() {
    if (_busy || _assigningTrigger) return;
    setState(() {
      _recording = true;
      _lastEventTime = null;
      _pressedKeys.clear();
      _message = null;
      _error = null;
    });
    _recordFocusNode.requestFocus();
  }

  void _stopRecording() {
    if (!_recording) return;
    setState(() {
      _recording = false;
      _lastEventTime = null;
      _pressedKeys.clear();
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (_busy) return;

    if (_assigningTrigger) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _stopAssigningTrigger();
        return;
      }
      if (event is! KeyDownEvent) return;
      final key = keymap.KeyboardKeyMap.byLogicalKey(event.logicalKey);
      if (key == null) {
        if (!mounted) return;
        setState(() {
          _error = AppLocalizations.of(context)!
              .errorMacroUnsupportedTriggerKey;
        });
        return;
      }
      _assignTriggerKey(key);
      return;
    }

    if (!_recording) return;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _stopRecording();
      return;
    }

    final hid = HidScancodes.logicalToHid(event.logicalKey);
    if (hid == null) return;

    if (event is KeyDownEvent) {
      if (_pressedKeys.contains(event.logicalKey)) return;
      _pressedKeys.add(event.logicalKey);
      _appendEvent(hid: hid, isKeyDown: true, key: event.logicalKey);
    } else if (event is KeyUpEvent) {
      if (!_pressedKeys.remove(event.logicalKey)) return;
      _appendEvent(hid: hid, isKeyDown: false, key: event.logicalKey);
    }
  }

  void _appendEvent({
    required int hid,
    required bool isKeyDown,
    required LogicalKeyboardKey key,
  }) {
    final now = DateTime.now();
    var delayMs = 0;
    if (_lastEventTime != null) {
      delayMs = now.difference(_lastEventTime!).inMilliseconds;
    }
    _lastEventTime = now;

    final label = HidScancodes.labelForKey(key);
    final events = List<MacroEvent>.from(_selected.events)
      ..add(
        MacroEvent(
          hidCode: hid,
          isKeyDown: isKeyDown,
          delayMs: delayMs,
          label: label,
        ),
      );
    _updateSelected(_selected.copyWith(events: events));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_loadingMacros) {
      return const Center(child: CircularProgressIndicator());
    }

    return KeyboardListener(
      focusNode: _recordFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.macroTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(l10n.macroSubtitle),
            const SizedBox(height: 24),
            SizedBox(
              height: 720,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              l10n.macroListTitle,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _macros.length,
                              itemBuilder: (context, index) {
                                final macro = _macros[index];
                                final selected = index == _selectedIndex;
                                return ListTile(
                                  selected: selected,
                                  enabled: !_busy && !_recording && !_assigningTrigger,
                                  title: Text(macro.name),
                                  subtitle: Text(
                                    macro.hasTrigger
                                        ? l10n.macroListEntryWithTrigger(
                                            macro.events.length,
                                            macro.triggerKeyLabel,
                                          )
                                        : l10n.macroEventCount(macro.events.length),
                                  ),
                                  onTap: () => _selectMacro(index),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: OutlinedButton.icon(
                              onPressed: (_macros.length < _maxMacros &&
                                      !_busy &&
                                      !_recording &&
                                      !_assigningTrigger)
                                  ? _addMacro
                                  : null,
                              icon: const Icon(Icons.add),
                              label: Text(l10n.macroAdd),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                                      controller: _nameController,
                                      enabled: !_busy && !_recording,
                                      decoration: InputDecoration(
                                        labelText: l10n.macroName,
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (value) => _updateSelected(
                                        _selected.copyWith(name: value),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    DropdownButtonFormField<MacroPlaybackMode>(
                                      value: _selected.playbackMode,
                                      decoration: InputDecoration(
                                        labelText: l10n.macroPlaybackMode,
                                        helperText: l10n.macroPlaybackModeHint,
                                        border: const OutlineInputBorder(),
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: MacroPlaybackMode.once,
                                          child: Text(l10n.macroPlaybackOnce),
                                        ),
                                        DropdownMenuItem(
                                          value: MacroPlaybackMode.toggle,
                                          child: Text(l10n.macroPlaybackToggle),
                                        ),
                                      ],
                                      onChanged:
                                          (_busy || _recording || _assigningTrigger)
                                              ? null
                                              : (value) {
                                                  if (value == null) return;
                                                  _updateSelected(
                                                    _selected.copyWith(
                                                      playbackMode: value,
                                                    ),
                                                  );
                                                },
                                    ),
                                    if (_selected.playbackMode ==
                                        MacroPlaybackMode.once) ...[
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: _maxRepeatsController,
                                        enabled: !_busy &&
                                            !_recording &&
                                            !_assigningTrigger,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: _maxRepeatsInputFormatters,
                                        decoration: InputDecoration(
                                          labelText: l10n.macroMaxRepeats,
                                          helperText: l10n.macroMaxRepeatsHint,
                                          border: const OutlineInputBorder(),
                                        ),
                                        onChanged: (_) => _applyMaxRepeatsInput(),
                                        onEditingComplete: _applyMaxRepeatsInput,
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButtonFormField<
                                              MacroDelayMode>(
                                            value: _selected.delayMode,
                                            decoration: InputDecoration(
                                              labelText: l10n.macroDelayMode,
                                              border: const OutlineInputBorder(),
                                            ),
                                            items: [
                                              DropdownMenuItem(
                                                value: MacroDelayMode.recorded,
                                                child: Text(l10n.macroDelayRecorded),
                                              ),
                                              DropdownMenuItem(
                                                value: MacroDelayMode.none,
                                                child: Text(l10n.macroDelayNone),
                                              ),
                                              DropdownMenuItem(
                                                value: MacroDelayMode.custom,
                                                child: Text(l10n.macroDelayCustom),
                                              ),
                                            ],
                                            onChanged: (_busy || _recording)
                                                ? null
                                                : (value) {
                                                    if (value == null) return;
                                                    _updateSelected(
                                                      _selected.copyWith(
                                                        delayMode: value,
                                                      ),
                                                    );
                                                  },
                                          ),
                                        ),
                                        if (_selected.delayMode ==
                                            MacroDelayMode.custom) ...[
                                          const SizedBox(width: 12),
                                          SizedBox(
                                            width: 120,
                                            child: TextField(
                                              controller: _customDelayController,
                                              enabled: !_busy && !_recording,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                labelText: l10n.macroDelayMs,
                                                border: const OutlineInputBorder(),
                                              ),
                                              onSubmitted: (value) {
                                                final parsed = int.tryParse(value);
                                                if (parsed != null) {
                                                  _updateSelected(
                                                    _selected.copyWith(
                                                      customDelayMs:
                                                          parsed.clamp(10, 65535),
                                                    ),
                                                  );
                                                  _customDelayController.text =
                                                      '${_selected.customDelayMs}';
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Card(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.macroTriggerTitle,
                                              style: theme.textTheme.titleSmall,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              _selected.hasTrigger
                                                  ? l10n.macroTriggerAssigned(
                                                      _selected.triggerKeyLabel,
                                                    )
                                                  : l10n.macroTriggerNone,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              l10n.macroTriggerSingleKeyNote,
                                              style: theme.textTheme.bodySmall,
                                            ),
                                            if (triggerOverlapsMacroEvents(
                                              _selected,
                                            )) ...[
                                              const SizedBox(height: 8),
                                              Text(
                                                l10n.warningMacroTriggerOverlap(
                                                  _selected.triggerKeyLabel,
                                                ),
                                                style: TextStyle(
                                                  color: theme.colorScheme.error,
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 12),
                                            Wrap(
                                              spacing: 12,
                                              runSpacing: 12,
                                              children: [
                                                OutlinedButton.icon(
                                                  onPressed: (_busy || _recording)
                                                      ? null
                                                      : (_assigningTrigger
                                                          ? _stopAssigningTrigger
                                                          : _startAssigningTrigger),
                                                  icon: Icon(
                                                    _assigningTrigger
                                                        ? Icons.stop
                                                        : Icons.touch_app_outlined,
                                                  ),
                                                  label: Text(
                                                    _assigningTrigger
                                                        ? l10n.macroStop
                                                        : l10n.macroAssignTrigger,
                                                  ),
                                                ),
                                                OutlinedButton.icon(
                                                  onPressed: (_busy ||
                                                          _recording ||
                                                          _assigningTrigger ||
                                                          !_selected.hasTrigger)
                                                      ? null
                                                      : _clearTrigger,
                                                  icon: const Icon(Icons.link_off),
                                                  label: Text(l10n.macroClearTrigger),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_assigningTrigger) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          l10n.macroAssigningTriggerHint,
                                          style: TextStyle(
                                            color:
                                                theme.colorScheme.onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (_recording) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.errorContainer,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          l10n.macroRecordingHint,
                                          style: TextStyle(
                                            color: theme.colorScheme.onErrorContainer,
                                          ),
                                        ),
                                      ),
                                    ],
                            const SizedBox(height: 12),
                            Expanded(
                              child: _selected.events.isEmpty
                                  ? Center(
                                      child: Text(
                                        l10n.macroNoEvents,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      key: ValueKey(
                                        'macro-events-$_selectedIndex-${_selected.events.length}',
                                      ),
                                      itemCount: _selected.events.length,
                                      itemBuilder: (context, index) {
                                        final event = _selected.events[index];
                                        final action = event.hidCode == 0
                                            ? l10n.macroActionDelay
                                            : event.isKeyDown
                                                ? l10n.macroActionDown
                                                : l10n.macroActionUp;
                                        final label = event.hidCode == 0
                                            ? '${event.delayMs} ms'
                                            : event.label.isNotEmpty
                                                ? event.label
                                                : HidScancodes.labelForHid(
                                                    event.hidCode,
                                                  );
                                        return ListTile(
                                          dense: true,
                                          leading: CircleAvatar(
                                            radius: 14,
                                            child: Text('${index + 1}'),
                                          ),
                                          title: Text('$action — $label'),
                                          subtitle: event.delayMs > 0 &&
                                                  event.hidCode != 0
                                              ? Text(l10n.macroGapDelay(
                                                  event.delayMs,
                                                ))
                                              : null,
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete_outline),
                                            onPressed: (_busy || _recording || _assigningTrigger)
                                                ? null
                                                : () => _removeEvent(index),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton.icon(
                                  onPressed: _busy
                                      ? null
                                      : (_recording ? _stopRecording : _startRecording),
                                  icon: Icon(_recording ? Icons.stop : Icons.fiber_manual_record),
                                  label: Text(
                                    _recording ? l10n.macroStop : l10n.macroRecord,
                                  ),
                                ),
                                Tooltip(
                                  message: l10n.macroClearHint,
                                  child: OutlinedButton.icon(
                                    onPressed: (_busy || _recording || _assigningTrigger)
                                        ? null
                                        : _clearEvents,
                                    icon: const Icon(Icons.clear_all),
                                    label: Text(l10n.macroClear),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: (_busy || _recording || _assigningTrigger)
                                      ? null
                                      : _deleteMacro,
                                  icon: const Icon(Icons.delete_forever_outlined),
                                  label: Text(l10n.macroDelete),
                                ),
                                FilledButton.icon(
                                  onPressed: (_busy || _recording || _assigningTrigger)
                                      ? null
                                      : _upload,
                                  icon: _busy
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.upload),
                                  label: Text(l10n.macroUpload),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Text(
                _message!,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
