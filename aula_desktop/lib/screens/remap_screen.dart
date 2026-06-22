import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../l10n/message_localizer.dart';
import '../models/remap.dart';
import '../protocol/key_map.dart' as keymap;
import '../services/keyboard_service.dart';
import '../services/macro_storage.dart';
import '../services/remap_storage.dart';

class RemapScreen extends StatefulWidget {
  const RemapScreen({super.key, required this.keyboard});

  final KeyboardService keyboard;

  @override
  State<RemapScreen> createState() => _RemapScreenState();
}

class _RemapScreenState extends State<RemapScreen> {
  final FocusNode _captureFocusNode = FocusNode();

  List<RemapBinding> _bindings = [];
  List<RemapBinding> _appliedBindings = [];
  bool _fnLayer = false;
  bool _loading = true;
  bool _busy = false;
  bool _capturingSource = false;
  bool _capturingTargetKey = false;
  int? _editingIndex;
  String? _message;
  String? _error;
  Timer? _persistTimer;
  bool _bindingsDirty = false;

  List<RemapBinding> get _activeBindings => activeRemapBindings(_bindings);

  bool get _hasUnappliedChanges =>
      remapBindingsChanged(_appliedBindings, _bindings);

  bool _layerNeedsUpload(bool fnLayer) {
    final appliedOnLayer = _appliedBindings
        .where((binding) => binding.fnLayer == fnLayer)
        .map((binding) => binding.sourceIndex)
        .toSet();
    final activeOnLayer = _activeBindings
        .where((binding) => binding.fnLayer == fnLayer)
        .map((binding) => binding.sourceIndex)
        .toSet();
    return appliedOnLayer != activeOnLayer ||
        _bindings.any((binding) => binding.fnLayer == fnLayer && binding.pendingDelete);
  }

  void _commitAppliedState() {
    _appliedBindings = _activeBindings
        .map((binding) => binding.copyWith(pendingDelete: false))
        .toList();
    _bindings = List<RemapBinding>.from(_appliedBindings);
    _bindingsDirty = false;
  }

  List<RemapBinding> get _visibleBindings =>
      _bindings.where((binding) => binding.fnLayer == _fnLayer).toList();

  @override
  void initState() {
    super.initState();
    _loadBindings();
  }

  Future<void> _loadBindings() async {
    final bindings = await RemapStorage.load();
    if (!mounted) return;
    if (_bindingsDirty) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _bindings = bindings;
      _appliedBindings = activeRemapBindings(bindings)
          .map((binding) => binding.copyWith(pendingDelete: false))
          .toList();
      _loading = false;
    });
  }

  void _markDirty() {
    _bindingsDirty = true;
  }

  void _schedulePersist() {
    _markDirty();
    _persistTimer?.cancel();
    _persistTimer = Timer(const Duration(milliseconds: 250), () {
      RemapStorage.save(_bindings);
    });
  }

  void _persistNow() {
    _persistTimer?.cancel();
    RemapStorage.saveSync(_bindings);
  }

  @override
  void dispose() {
    _persistTimer?.cancel();
    RemapStorage.saveSync(_bindings);
    _captureFocusNode.dispose();
    super.dispose();
  }

  String _mediaLabel(AppLocalizations l10n, ConsumerMediaAction action) {
    return switch (action) {
      ConsumerMediaAction.playPause => l10n.remapMediaPlayPause,
      ConsumerMediaAction.stop => l10n.remapMediaStop,
      ConsumerMediaAction.previous => l10n.remapMediaPrevious,
      ConsumerMediaAction.next => l10n.remapMediaNext,
      ConsumerMediaAction.volumeUp => l10n.remapMediaVolumeUp,
      ConsumerMediaAction.volumeDown => l10n.remapMediaVolumeDown,
      ConsumerMediaAction.mute => l10n.remapMediaMute,
    };
  }

  IconData _mediaIcon(ConsumerMediaAction action) {
    return switch (action) {
      ConsumerMediaAction.playPause => Icons.play_circle_outline,
      ConsumerMediaAction.stop => Icons.stop_circle_outlined,
      ConsumerMediaAction.previous => Icons.skip_previous,
      ConsumerMediaAction.next => Icons.skip_next,
      ConsumerMediaAction.volumeUp => Icons.volume_up,
      ConsumerMediaAction.volumeDown => Icons.volume_down,
      ConsumerMediaAction.mute => Icons.volume_off,
    };
  }

  void _startAddBinding() {
    if (_busy) return;
    setState(() {
      _editingIndex = null;
      _capturingSource = true;
      _capturingTargetKey = false;
      _error = null;
      _message = null;
    });
    _captureFocusNode.requestFocus();
  }

  void _startEditBinding(int index) {
    if (_busy) return;
    final binding = _visibleBindings[index];
    if (binding.pendingDelete) return;
    final globalIndex = _bindings.indexOf(binding);
    setState(() {
      _editingIndex = globalIndex;
      _capturingSource = false;
      _capturingTargetKey = false;
      _error = null;
      _message = null;
    });
  }

  void _cancelCapture() {
    setState(() {
      _capturingSource = false;
      _capturingTargetKey = false;
      _editingIndex = null;
    });
  }

  void _upsertBinding(RemapBinding binding, {bool keepEditing = false}) {
    final next = List<RemapBinding>.from(_bindings)
      ..removeWhere(
        (entry) =>
            entry.sourceIndex == binding.sourceIndex &&
            entry.fnLayer == binding.fnLayer,
      )
      ..add(binding.copyWith(pendingDelete: false));
    final nextIndex = next.indexWhere(
      (entry) =>
          entry.sourceIndex == binding.sourceIndex &&
          entry.fnLayer == binding.fnLayer,
    );
    setState(() {
      _bindings = next;
      _capturingSource = false;
      _capturingTargetKey = false;
      _editingIndex = keepEditing ? nextIndex : null;
      _error = null;
    });
    _schedulePersist();
  }

  void _removeBinding(RemapBinding binding) {
    if (_busy || binding.pendingDelete) return;
    final index = _bindings.indexOf(binding);
    if (index == -1) return;
    setState(() {
      _bindings[index] = binding.copyWith(pendingDelete: true);
      if (_editingIndex == index) {
        _editingIndex = null;
      }
    });
    _schedulePersist();
  }

  void _undoDeleteBinding(RemapBinding binding) {
    if (_busy || !binding.pendingDelete) return;
    final index = _bindings.indexOf(binding);
    if (index == -1) return;
    setState(() {
      _bindings[index] = binding.copyWith(pendingDelete: false);
    });
    _schedulePersist();
  }

  void _assignSourceKey(keymap.KeyboardKey key) {
    if (_editingIndex != null) {
      final existing = _bindings[_editingIndex!];
      _upsertBinding(
        existing.copyWith(
          sourceIndex: key.index,
          sourceLabel: key.label,
        ),
        keepEditing: true,
      );
      return;
    }

    setState(() {
      _capturingSource = false;
      _bindings = [
        ..._bindings,
        RemapBinding(
          sourceIndex: key.index,
          sourceLabel: key.label,
          targetKind: RemapTargetKind.consumer,
          consumerAction: ConsumerMediaAction.playPause,
          fnLayer: _fnLayer,
        ),
      ];
      _editingIndex = _bindings.length - 1;
    });
    _schedulePersist();
  }

  void _selectSourceKey(int? index) {
    if (index == null || _busy) return;
    final key = keymap.KeyboardKeyMap.byIndex(index);
    if (key == null) return;
    _assignSourceKey(key);
  }

  void _selectTargetKey(int? index) {
    if (index == null || _editingIndex == null || _busy) return;
    final key = keymap.KeyboardKeyMap.byIndex(index);
    if (key == null) return;
    _assignTargetKey(key);
  }

  void _assignTargetKey(keymap.KeyboardKey key) {
    if (_editingIndex == null) return;
    final existing = _bindings[_editingIndex!];
    _upsertBinding(
      existing.copyWith(
        targetKind: RemapTargetKind.key,
        targetKeyIndex: key.index,
        targetKeyLabel: key.label,
        clearConsumer: true,
      ),
      keepEditing: true,
    );
  }

  void _setConsumerTarget(ConsumerMediaAction action) {
    if (_editingIndex == null) return;
    final existing = _bindings[_editingIndex!];
    _upsertBinding(
      existing.copyWith(
        targetKind: RemapTargetKind.consumer,
        consumerAction: action,
        clearTargetKey: true,
      ),
      keepEditing: true,
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (_busy) return;
    if (!_capturingSource && !_capturingTargetKey) return;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _cancelCapture();
      return;
    }
    if (event is! KeyDownEvent) return;

    final key = keymap.KeyboardKeyMap.byLogicalKey(event.logicalKey);
    if (key == null) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context)!.errorRemapUnsupportedKey;
      });
      return;
    }

    if (_capturingSource) {
      _assignSourceKey(key);
    } else if (_capturingTargetKey) {
      _assignTargetKey(key);
    }
  }

  Future<void> _applyToKeyboard() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_hasUnappliedChanges) {
      setState(() => _message = l10n.remapNoChangesToApply);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
      _message = null;
    });

    try {
      final macros = await MacroStorage.load();
      final uploadNormalLayer = _layerNeedsUpload(false);
      final uploadFnLayer = _layerNeedsUpload(true);
      final result = await widget.keyboard.applyRemapBindings(
        _bindings,
        macros: macros,
        uploadNormalLayer: uploadNormalLayer,
        uploadFnLayer: uploadFnLayer,
      );
      if (!mounted) return;
      _commitAppliedState();
      _persistNow();
      setState(() {
        _message = result.bindingCount > 0
            ? l10n.remapApplied(result.bindingCount)
            : l10n.remapChangesApplied;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = l10n.localizeError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clearLayer() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final dialogL10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(dialogL10n.remapClearLayerTitle),
          content: Text(
            _fnLayer
                ? dialogL10n.remapClearFnLayerBody
                : dialogL10n.remapClearNormalLayerBody,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(dialogL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(dialogL10n.remapClearLayerConfirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _bindings = _bindings
          .map(
            (binding) => binding.fnLayer == _fnLayer
                ? binding.copyWith(pendingDelete: true)
                : binding,
          )
          .toList();
      _editingIndex = null;
      _capturingSource = false;
      _capturingTargetKey = false;
    });
    _schedulePersist();
  }

  Widget _buildBindingTile(
    AppLocalizations l10n,
    RemapBinding binding,
    int listIndex,
  ) {
    final isEditing = _editingIndex != null && _bindings[_editingIndex!] == binding;
    final pendingDelete = binding.pendingDelete;
    final titleStyle = pendingDelete
        ? TextStyle(decoration: TextDecoration.lineThrough)
        : null;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: pendingDelete
          ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.35)
          : isEditing
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
      child: ListTile(
        leading: Icon(
          binding.targetKind == RemapTargetKind.consumer
              ? _mediaIcon(binding.consumerAction ?? ConsumerMediaAction.playPause)
              : Icons.keyboard,
        ),
        title: Text(binding.sourceLabel, style: titleStyle),
        subtitle: Text(
          pendingDelete
              ? l10n.remapPendingDelete
              : '→ ${binding.targetDescription(mediaLabel: (action) => _mediaLabel(l10n, action))}',
          style: pendingDelete
              ? TextStyle(color: Theme.of(context).colorScheme.error)
              : titleStyle,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pendingDelete)
              IconButton(
                tooltip: l10n.remapUndoDelete,
                onPressed: _busy ? null : () => _undoDeleteBinding(binding),
                icon: const Icon(Icons.undo),
              )
            else ...[
              IconButton(
                tooltip: l10n.remapEditBinding,
                onPressed: _busy ? null : () => _startEditBinding(listIndex),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: l10n.remapRemoveBinding,
                onPressed: _busy ? null : () => _removeBinding(binding),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ],
        ),
        onTap: pendingDelete || _busy
            ? null
            : () => _startEditBinding(listIndex),
      ),
    );
  }

  Widget _buildEditor(AppLocalizations l10n, ThemeData theme) {
    if (_editingIndex == null && !_capturingSource) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.remapEditorEmptyTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l10n.remapEditorEmptyBody),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _busy ? null : _startAddBinding,
                icon: const Icon(Icons.add),
                label: Text(l10n.remapAddBinding),
              ),
            ],
          ),
        ),
      );
    }

    final binding = _editingIndex != null ? _bindings[_editingIndex!] : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              binding == null ? l10n.remapNewBinding : l10n.remapEditBinding,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(l10n.remapSourceKey, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownMenu<int>(
              key: ValueKey('source-${binding?.sourceIndex ?? 'new'}-$_fnLayer'),
              initialSelection: binding?.sourceIndex,
              label: Text(l10n.remapChooseSourceKey),
              hintText: l10n.remapChooseSourceKeyHint,
              enabled: !_busy,
              dropdownMenuEntries: [
                for (final key in keymap.KeyboardKeyMap.pickableKeys)
                  DropdownMenuEntry(
                    value: key.index,
                    label: key.label,
                  ),
              ],
              onSelected: _selectSourceKey,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy
                        ? null
                        : () {
                            setState(() {
                              _capturingSource = true;
                              _capturingTargetKey = false;
                            });
                            _captureFocusNode.requestFocus();
                          },
                    icon: const Icon(Icons.keyboard),
                    label: Text(
                      binding?.sourceLabel ?? l10n.remapPressSourceKey,
                    ),
                  ),
                ),
              ],
            ),
            if (!_fnLayer) ...[
              const SizedBox(height: 8),
              Text(
                l10n.remapFunctionKeyHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
            if (_capturingSource) ...[
              const SizedBox(height: 8),
              Text(
                l10n.remapCapturingSourceHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(l10n.remapTargetType, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<RemapTargetKind>(
              segments: [
                ButtonSegment(
                  value: RemapTargetKind.consumer,
                  label: Text(l10n.remapTargetMedia),
                  icon: const Icon(Icons.play_circle_outline),
                ),
                ButtonSegment(
                  value: RemapTargetKind.key,
                  label: Text(l10n.remapTargetKey),
                  icon: const Icon(Icons.keyboard_alt_outlined),
                ),
              ],
              selected: {binding?.targetKind ?? RemapTargetKind.consumer},
              onSelectionChanged: binding == null || _busy
                  ? null
                  : (selection) {
                      final kind = selection.first;
                      if (kind == RemapTargetKind.consumer) {
                        _setConsumerTarget(
                          binding.consumerAction ?? ConsumerMediaAction.playPause,
                        );
                      } else {
                        setState(() {
                          _bindings[_editingIndex!] = binding.copyWith(
                            targetKind: RemapTargetKind.key,
                            clearConsumer: true,
                          );
                          _capturingTargetKey = true;
                          _capturingSource = false;
                        });
                        _schedulePersist();
                        _captureFocusNode.requestFocus();
                      }
                    },
            ),
            const SizedBox(height: 16),
            if ((binding?.targetKind ?? RemapTargetKind.consumer) ==
                RemapTargetKind.consumer) ...[
              Text(l10n.remapMediaControls, style: theme.textTheme.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final action in ConsumerMediaAction.values)
                    FilterChip(
                      avatar: Icon(_mediaIcon(action), size: 18),
                      label: Text(_mediaLabel(l10n, action)),
                      selected: binding?.consumerAction == action,
                      onSelected: binding == null || _busy
                          ? null
                          : (_) => _setConsumerTarget(action),
                    ),
                ],
              ),
            ] else ...[
              DropdownMenu<int>(
                key: ValueKey('target-${binding?.targetKeyIndex ?? 'new'}'),
                initialSelection: binding?.targetKeyIndex,
                label: Text(l10n.remapChooseTargetKey),
                hintText: l10n.remapChooseTargetKeyHint,
                enabled: binding != null && !_busy,
                dropdownMenuEntries: [
                  for (final key in keymap.KeyboardKeyMap.pickableKeys)
                    DropdownMenuEntry(
                      value: key.index,
                      label: key.label,
                    ),
                ],
                onSelected: _selectTargetKey,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: binding == null || _busy
                    ? null
                    : () {
                        setState(() {
                          _capturingTargetKey = true;
                          _capturingSource = false;
                        });
                        _captureFocusNode.requestFocus();
                      },
                icon: const Icon(Icons.keyboard_alt_outlined),
                label: Text(
                  binding?.targetKeyLabel ?? l10n.remapPressTargetKey,
                ),
              ),
              if (_capturingTargetKey) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.remapCapturingTargetHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
            if (binding != null) ...[
              const SizedBox(height: 24),
              Text(
                l10n.remapPreview(
                  binding.sourceLabel,
                  binding.targetDescription(
                    mediaLabel: (action) => _mediaLabel(l10n, action),
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return KeyboardListener(
      focusNode: _captureFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.remapTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(l10n.remapSubtitle),
            const SizedBox(height: 24),
            if (_loading || _busy) const LinearProgressIndicator(),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Card(
                  color: theme.colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(_message!),
                  ),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Card(
                  color: theme.colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(_error!),
                  ),
                ),
              ),
            Row(
              children: [
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(value: false, label: Text(l10n.remapNormalLayer)),
                    ButtonSegment(value: true, label: Text(l10n.remapFnLayer)),
                  ],
                  selected: {_fnLayer},
                  onSelectionChanged: _busy
                      ? null
                      : (selection) {
                          setState(() {
                            _fnLayer = selection.first;
                            _editingIndex = null;
                            _capturingSource = false;
                            _capturingTargetKey = false;
                          });
                        },
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: _busy || _visibleBindings.isEmpty ? null : _clearLayer,
                  icon: const Icon(Icons.clear_all),
                  label: Text(l10n.remapClearLayer),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _busy || !_hasUnappliedChanges ? null : _applyToKeyboard,
                  icon: const Icon(Icons.upload),
                  label: Text(l10n.remapApply),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 640,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              l10n.remapBindingsTitle,
                              style: theme.textTheme.titleMedium,
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: _busy ? null : _startAddBinding,
                              icon: const Icon(Icons.add),
                              label: Text(l10n.remapAddBinding),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _visibleBindings.isEmpty
                              ? Center(
                                  child: Text(
                                    l10n.remapNoBindings,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _visibleBindings.length,
                                  itemBuilder: (context, index) =>
                                      _buildBindingTile(
                                    l10n,
                                    _visibleBindings[index],
                                    index,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 3,
                    child: _buildEditor(l10n, theme),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
