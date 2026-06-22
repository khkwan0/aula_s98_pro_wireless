import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/message_localizer.dart';
import '../l10n/user_message.dart';
import '../protocol/constants.dart';
import '../protocol/lcd_converter.dart';
import '../services/keyboard_service.dart';

class LcdScreen extends StatefulWidget {
  const LcdScreen({super.key, required this.keyboard});

  final KeyboardService keyboard;

  @override
  State<LcdScreen> createState() => _LcdScreenState();
}

class _LcdScreenState extends State<LcdScreen> {
  PlatformFile? _selectedFile;
  GifInspectInfo? _inspect;
  bool _force = false;
  bool _busy = false;
  double _progress = 0;
  String? _message;
  String? _error;

  Future<void> _pickGif() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['gif', 'bin'],
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      setState(() {
        _selectedFile = file;
        _inspect = null;
        _message = null;
        _error = null;
        _progress = 0;
      });

      if (file.path != null && file.extension?.toLowerCase() == 'gif') {
        await _inspectSelected();
      }
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _error = l10n.errorFilePicker('$error'));
    }
  }

  Future<void> _inspectSelected() async {
    final file = _selectedFile;
    if (file?.path == null || file!.extension?.toLowerCase() != 'gif') return;

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final bytes = await File(file.path!).readAsBytes();
      final info = widget.keyboard.inspectGif(bytes);
      if (!mounted) return;
      setState(() => _inspect = info);
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _error = l10n.localizeError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _convertAndSave() async {
    final file = _selectedFile;
    if (file?.path == null || file!.extension?.toLowerCase() != 'gif') return;

    final l10n = AppLocalizations.of(context)!;
    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: l10n.saveLcdBinary,
      fileName: '${file.name.replaceAll('.gif', '')}.bin',
      type: FileType.custom,
      allowedExtensions: ['bin'],
    );
    if (savePath == null) return;

    setState(() {
      _busy = true;
      _error = null;
      _message = null;
    });
    try {
      final converted = await widget.keyboard.convertGifFileToBin(file.path!, savePath, force: _force);
      if (!mounted) return;
      setState(() {
        _message = _formatResultMessage(l10n.savedTo(savePath), converted.warnings, l10n);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = l10n.localizeError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _upload() async {
    final selected = _selectedFile;
    if (selected == null || selected.path == null) return;
    final path = selected.path!;
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final dialogL10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(dialogL10n.uploadDialogTitle),
          content: Text(dialogL10n.uploadDialogBody(KeyboardConstants.maxFrames)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(dialogL10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(dialogL10n.upload),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _busy = true;
      _error = null;
      _message = null;
      _progress = 0;
    });

    try {
      if (selected.extension?.toLowerCase() == 'gif') {
        final bytes = await File(path).readAsBytes();
        final result = await widget.keyboard.uploadGif(
          bytes,
          force: _force,
          onProgress: (sent, total) {
            if (!mounted) return;
            setState(() => _progress = sent / total);
          },
        );
        if (!mounted) return;
        setState(
          () => _message = _formatResultMessage(
            l10n.uploadedFrames(result.frameCount, result.pageCount),
            result.warnings,
            l10n,
          ),
        );
      } else {
        final result = await widget.keyboard.uploadFromPath(
          path,
          force: _force,
          onProgress: (sent, total) {
            if (!mounted) return;
            setState(() => _progress = sent / total);
          },
        );
        if (!mounted) return;
        setState(
          () => _message = _formatResultMessage(
            l10n.uploadedFrames(result.frameCount, result.pageCount),
            result.warnings,
            l10n,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = l10n.localizeError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _formatResultMessage(
    String base,
    List<UserMessage> warnings,
    AppLocalizations l10n,
  ) {
    if (warnings.isEmpty) return base;
    return '$base\n${warnings.map(l10n.formatWarning).join('\n')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inspect = _inspect;
    final maxFrames = widget.keyboard.maxFrames;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.lcdTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(l10n.lcdSubtitle(maxFrames)),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.35),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.lcdTrimWarning(maxFrames)),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(l10n.forceUploadTitle),
            subtitle: Text(l10n.forceUploadSubtitle),
            value: _force,
            onChanged: _busy ? null : (value) => setState(() => _force = value),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: _busy ? null : _pickGif,
                icon: const Icon(Icons.folder_open),
                label: Text(l10n.chooseGifOrBin),
              ),
              if (_selectedFile?.extension?.toLowerCase() == 'gif')
                OutlinedButton.icon(
                  onPressed: _busy ? null : _convertAndSave,
                  icon: const Icon(Icons.save_alt),
                  label: Text(l10n.convertToBin),
                ),
              FilledButton.icon(
                onPressed: _busy || _selectedFile == null ? null : _upload,
                icon: const Icon(Icons.upload),
                label: Text(l10n.uploadToKeyboard),
              ),
            ],
          ),
          if (_selectedFile != null) ...[
            const SizedBox(height: 16),
            Text(l10n.selectedFile(_selectedFile!.name)),
          ],
          if (inspect != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inspect.frameCount == inspect.outputFrameCount
                          ? l10n.inspectFramesExact(
                              inspect.frameCount,
                              inspect.width,
                              inspect.height,
                              inspect.pageCount,
                            )
                          : l10n.inspectFramesTrimmed(
                              inspect.frameCount,
                              inspect.outputFrameCount,
                              inspect.width,
                              inspect.height,
                              inspect.pageCount,
                            ),
                    ),
                    for (final warning in inspect.warnings)
                      Text(
                        l10n.formatWarning(warning),
                        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                      ),
                  ],
                ),
              ),
            ),
          ],
          if (_busy && _progress > 0) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _progress),
            Text(l10n.uploadingPercent((_progress * 100).toStringAsFixed(0))),
          ],
          if (_message != null) ...[
            const SizedBox(height: 16),
            Text(
              _message!,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
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
