import 'dart:convert';
import 'dart:io';

import '../models/remap.dart';

const _storageVersion = 1;

class RemapStorage {
  RemapStorage._();

  static String storagePath() {
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '.';
    return '$home/.aula_desktop/remaps.json';
  }

  static Future<List<RemapBinding>> load() async {
    try {
      final file = File(storagePath());
      if (!await file.exists()) {
        return [];
      }
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) {
        return [];
      }
      final bindingsJson = decoded['bindings'];
      if (bindingsJson is! List<dynamic>) {
        return [];
      }
      return bindingsJson
          .map((entry) => RemapBinding.fromJson(entry as Map<String, dynamic>))
          .where((binding) => binding.sourceIndex > 0)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<RemapBinding> bindings) async {
    final file = File(storagePath());
    await file.parent.create(recursive: true);
    await file.writeAsString(_encode(bindings));
  }

  static void saveSync(List<RemapBinding> bindings) {
    final file = File(storagePath());
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(_encode(bindings));
  }

  static Future<void> clear() async {
    final file = File(storagePath());
    if (await file.exists()) {
      await file.delete();
    }
  }

  static String _encode(List<RemapBinding> bindings) {
    final payload = <String, Object?>{
      'version': _storageVersion,
      'bindings': bindings.map((binding) => binding.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }
}
