import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de almacenamiento de sesión para GAULA.
///
/// Estrategia dual según plataforma:
///   • Móvil/Desktop → flutter_secure_storage (Android: AES-256, iOS: Keychain)
///   • Web (HTTP/HTTPS) → shared_preferences (localStorage plano)
///     ↳ flutter_secure_storage_web requiere Web Crypto API que solo funciona
///       en contextos seguros (HTTPS o localhost). En HTTP desde IP local falla,
///       impidiendo guardar el JWT y provocando redireccion inmediata al login.
class SecureStorageService {
  // ── Storage nativo (móvil/desktop) ──────────────────────────────────────────
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // ── Claves de almacenamiento (compartidas entre ambos backends) ─────────────
  static const String _keyToken    = 'gaula_jwt_token';
  static const String _keyUserId   = 'gaula_user_id';
  static const String _keyUsername = 'gaula_username';
  static const String _keyNombre   = 'gaula_nombre';
  static const String _keyRol      = 'gaula_rol';
  static const String _keyAvatar   = 'gaula_avatar';
  static const String _keyTheme    = 'gaula_theme';
  static const String _keyLocale   = 'gaula_locale';

  static const List<String> _allKeys = [
    _keyToken, _keyUserId, _keyUsername,
    _keyNombre, _keyRol, _keyAvatar, _keyTheme, _keyLocale,
  ];

  // ── API unificada de lectura/escritura ─────────────────────────────────────

  Future<void> _write(String key, String value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await _secureStorage.write(key: key, value: value);
    }
  }

  Future<String?> _read(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } else {
      return _secureStorage.read(key: key);
    }
  }

  // ── API pública ─────────────────────────────────────────────────────────────

  /// Guarda el token JWT.
  Future<void> saveToken(String token) => _write(_keyToken, token);

  /// Lee el token JWT. Devuelve null si no existe.
  Future<String?> getToken() => _read(_keyToken);

  /// Guarda los datos básicos del usuario autenticado.
  Future<void> saveUserData({
    required int    id,
    required String username,
    required String nombre,
    required String rol,
    required String avatar,
    required String theme,
  }) async {
    await Future.wait([
      _write(_keyUserId,   id.toString()),
      _write(_keyUsername, username),
      _write(_keyNombre,   nombre),
      _write(_keyRol,      rol),
      _write(_keyAvatar,   avatar),
      _write(_keyTheme,    theme),
    ]);
  }

  Future<int?>     getUserId()  async { final v = await _read(_keyUserId);   return v != null ? int.tryParse(v) : null; }
  Future<String?>  getUsername()       => _read(_keyUsername);
  Future<String?>  getNombre()         => _read(_keyNombre);
  Future<String?>  getRol()            => _read(_keyRol);
  Future<String?>  getAvatar()         => _read(_keyAvatar);
  Future<String?>  getTheme()          => _read(_keyTheme);

  Future<void>     saveAvatar(String avatar) => _write(_keyAvatar, avatar);
  Future<void>     saveTheme(String theme)   => _write(_keyTheme,  theme);
  Future<void>     saveLocale(String code)   => _write(_keyLocale, code);
  Future<String?>  getLocale()               => _read(_keyLocale);

  /// Verifica si hay una sesión activa con JWT válido y no caducado.
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    if (_isJwtExpired(token)) {
      await clearAll();
      return false;
    }
    return true;
  }

  /// Decodifica el claim `exp` del JWT sin dependencias externas.
  bool _isJwtExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (payload.length % 4 != 0) { payload += '='; }
      final map = jsonDecode(utf8.decode(base64.decode(payload))) as Map<String, dynamic>;
      final exp = map['exp'] as int?;
      if (exp == null) return true;
      return DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(exp * 1000));
    } catch (_) {
      return true;
    }
  }

  /// Elimina todos los datos de sesión. Usado en el logout.
  Future<void> clearAll() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      for (final key in _allKeys) {
        await prefs.remove(key);
      }
    } else {
      await _secureStorage.deleteAll();
    }
  }
}

final secureStorageProvider = Provider((ref) => SecureStorageService());
