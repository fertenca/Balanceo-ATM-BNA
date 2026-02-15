import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalStoreService {
  Future<File> _file(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, name));
  }

  Future<void> saveJson(String name, Map<String, dynamic> json) async {
    final file = await _file(name);
    await file.writeAsString(jsonEncode(json));
  }

  Future<Map<String, dynamic>?> readJson(String name) async {
    final file = await _file(name);
    if (!await file.exists()) return null;
    final raw = await file.readAsString();
    if (raw.isEmpty) return null;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }
}
