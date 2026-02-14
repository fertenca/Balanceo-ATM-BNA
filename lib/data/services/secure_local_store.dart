import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SecureLocalStore {
  static final _key = enc.Key.fromUtf8('mvp-balanceo-key-32-bytes-string!!');
  static final _iv = enc.IV.fromUtf8('16bytesinitvector');

  Future<File> _file(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, name));
  }

  Future<void> writeJson(String name, Map<String, dynamic> data) async {
    final file = await _file(name);
    final payload = jsonEncode(data);
    final encrypted = enc.Encrypter(enc.AES(_key)).encrypt(payload, iv: _iv);
    await file.writeAsString(encrypted.base64);
  }

  Future<Map<String, dynamic>?> readJson(String name) async {
    final file = await _file(name);
    if (!await file.exists()) return null;
    final raw = await file.readAsString();
    if (raw.isEmpty) return null;
    final decrypted = enc.Encrypter(enc.AES(_key)).decrypt64(raw, iv: _iv);
    return Map<String, dynamic>.from(jsonDecode(decrypted));
  }

  Future<void> appendJsonList(String name, Map<String, dynamic> entry) async {
    final current = await readJson(name);
    final list = List<Map<String, dynamic>>.from(current?['items'] ?? []);
    list.add(entry);
    await writeJson(name, {'items': list});
  }
}
