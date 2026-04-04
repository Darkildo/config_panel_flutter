import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_storage_web.dart' if (dart.library.io) 'token_storage_stub.dart';

class TokenStorage {
  static const _keyToken = 'auth_token';
  static const _expiryBufferSeconds = 30;

  final FlutterSecureStorage _secureStorage;

  TokenStorage([FlutterSecureStorage? storage])
    : _secureStorage = storage ?? const FlutterSecureStorage();

  Future<void> save(String token) async {
    if (kIsWeb) {
      webStorageWrite(_keyToken, token);
    } else {
      await _secureStorage.write(key: _keyToken, value: token);
    }
  }

  Future<String?> load() async {
    String? token;
    if (kIsWeb) {
      token = webStorageRead(_keyToken);
    } else {
      token = await _secureStorage.read(key: _keyToken);
    }

    if (token == null) return null;

    if (isExpired(token)) {
      await clear();
      return null;
    }

    return token;
  }

  Future<void> clear() async {
    if (kIsWeb) {
      webStorageDelete(_keyToken);
    } else {
      await _secureStorage.delete(key: _keyToken);
    }
  }

  static bool isExpired(String token) {
    try {
      final payload = _decodePayload(token);
      if (payload == null) return true;

      final exp = payload['exp'];
      if (exp == null || exp is! num) return false;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(
        exp.toInt() * 1000,
        isUtc: true,
      );
      final now = DateTime.now().toUtc();

      return now.isAfter(
        expiryDate.subtract(const Duration(seconds: _expiryBufferSeconds)),
      );
    } catch (_) {
      return true;
    }
  }

  static Duration? remainingLifetime(String token) {
    try {
      final payload = _decodePayload(token);
      if (payload == null) return null;

      final exp = payload['exp'];
      if (exp == null || exp is! num) return null;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(
        exp.toInt() * 1000,
        isUtc: true,
      );
      final remaining = expiryDate.difference(DateTime.now().toUtc());
      return remaining.isNegative ? null : remaining;
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? _decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return json.decode(decoded) as Map<String, dynamic>?;
  }
}
