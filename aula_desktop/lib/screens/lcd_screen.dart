import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
      setState(() => _error = 'Could not open file picker: $error');
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
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _convertAndSave() async {
    final file = _selectedFile;
    if (file?.path == null || file!.extension?.toLowerCase() != 'gif') return;

    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save LCD binary',
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
        _message = _formatResultMessage('Saved to $savePath', converted.warnings);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _upload() async {
    final selected = _selectedFile;
    if (selected == null || selected.path == null) return;
    final path = selected.path!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload LCD animation?'),
        content: Text(
          'Uploading images can permanently corrupt the keyboard menu graphics '
          'if too many frames are written to SPI flash. This is not recoverable by factory reset.\n\n'
          'GIFs over ${KeyboardConstants.maxFrames} frames are trimmed automatically unless force upload is enabled.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Upload')),
        ],
      ),
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
            'Uploaded ${result.frameCount} frames (${result.pageCount} pages)',
            result.warnings,
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
            'Uploaded ${result.frameCount} frames (${result.pageCount} pages)',
            result.warnings,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _formatResultMessage(String base, List<String> warnings) {
    if (warnings.isEmpty) return base;
    return '$base\n${warnings.map((w) => '⚠ $w').join('\n')}';
  }

  @override
  Widget build(BuildContext context) {
    final inspect = _inspect;
    final maxFrames = widget.keyboard.maxFrames;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('LCD Animation', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Upload a 240×135 GIF (up to $maxFrames frames). Converts to RGB565 in Dart.'),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.35),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'GIFs with more than $maxFrames frames are trimmed to the first $maxFrames automatically. '
                'Enable force upload to send every frame (may overwrite menu graphics in SPI flash).',
              ),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Force upload (use all frames)'),
            subtitle: const Text('Dangerous — skips frame trimming'),
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
                label: const Text('Choose GIF or .bin'),
              ),
              if (_selectedFile?.extension?.toLowerCase() == 'gif')
                OutlinedButton.icon(
                  onPressed: _busy ? null : _convertAndSave,
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Convert to .bin'),
                ),
              FilledButton.icon(
                onPressed: _busy || _selectedFile == null ? null : _upload,
                icon: const Icon(Icons.upload),
                label: const Text('Upload to keyboard'),
              ),
            ],
          ),
          if (_selectedFile != null) ...[
            const SizedBox(height: 16),
            Text('Selected: ${_selectedFile!.name}'),
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
                          ? '${inspect.frameCount} frames • ${inspect.width}×${inspect.height} • ${inspect.pageCount} pages'
                          : '${inspect.frameCount} frames → using ${inspect.outputFrameCount} • '
                              '${inspect.width}×${inspect.height} • ${inspect.pageCount} pages',
                    ),
                    for (final warning in inspect.warnings)
                      Text(
                        '⚠ $warning',
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
            Text('Uploading ${(_progress * 100).toStringAsFixed(0)}%'),
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
