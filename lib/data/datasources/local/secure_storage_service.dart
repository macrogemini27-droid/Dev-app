import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> writeJson(String key, Map<String, dynamic> json) async {
    await _storage.write(key: key, value: jsonEncode(json));
  }

  Future<Map<String, dynamic>?> readJson(String key) async {
    final jsonString = await _storage.read(key: key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
