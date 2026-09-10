// Lector de entorno en tiempo de compilación para GAULA.
// En Flutter Web, la URL del backend se resuelve en tiempo de ejecucion
// a partir del host actual del navegador (Uri.base) para que el mismo
// build funcione en cualquier maquina sin recompilar.

import 'package:flutter/foundation.dart' show kIsWeb;

/// Entorno de ejecución activo (compilado en el binario).
enum AppEnvironment { dev, staging, prod }

/// Constantes de entorno leídas en tiempo de compilación.
///
/// Todos los valores son `const` — no existe ninguna lógica
/// de selección en runtime; el compilador de Dart los incrusta
/// directamente en el bytecode del binario generado.
abstract final class AppEnv {
  // ── Entorno ──────────────────────────────────────────────────────────────

  /// Nombre del entorno activo: "dev" | "staging" | "prod".
  /// Inyectado con: --dart-define=APP_ENV=prod
  static const String _envName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev', // Seguro: nunca apunta a producción por defecto
  );

  /// Entorno tipado derivado del nombre compilado.
  static AppEnvironment get environment => switch (_envName) {
        'prod'    => AppEnvironment.prod,
        'staging' => AppEnvironment.staging,
        _         => AppEnvironment.dev,
      };

  static bool get isDev     => environment == AppEnvironment.dev;
  static bool get isStaging => environment == AppEnvironment.staging;
  static bool get isProd    => environment == AppEnvironment.prod;

  // ── URLs de API ───────────────────────────────────────────────────────────

  /// URL base de la API REST.
  /// - En Flutter Web: se resuelve en runtime usando el host del navegador
  ///   (mismo host, puerto 8080). Funciona con cualquier IP de la red.
  /// - En mobile/desktop: valor inyectado por --dart-define-from-file.
  static String get apiBaseUrl {
    if (kIsWeb) {
      // Uri.base = 'http://10.103.140.160:8081/' (lo que sea que sirva la app)
      // Construimos: 'http://10.103.140.160:8080/api/'
      final host = Uri.base.host; // '10.103.140.160'
      final scheme = Uri.base.scheme; // 'http'
      return '$scheme://$host:8080/api/';
    }
    return const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080/api/',
    ).replaceAll('"', '').replaceAll("'", '').trim();
  }

  /// URL base del servidor de uploads (imágenes de perfil).
  /// Misma lógica: en web usa el host actual; en mobile usa dart-define.
  static String get uploadsBaseUrl {
    if (kIsWeb) {
      final host = Uri.base.host;
      final scheme = Uri.base.scheme;
      return '$scheme://$host:8080/uploads/profiles/';
    }
    return const String.fromEnvironment(
      'UPLOADS_BASE_URL',
      defaultValue: 'http://localhost:8080/uploads/profiles/',
    ).replaceAll('"', '').replaceAll("'", '').trim();
  }

  // ── Timeouts de red ───────────────────────────────────────────────────────

  /// Timeout de conexión en segundos.
  /// Inyectado con: --dart-define=CONNECT_TIMEOUT_S=15
  static const int _connectTimeoutS = int.fromEnvironment(
    'CONNECT_TIMEOUT_S',
    defaultValue: 15,
  );

  /// Timeout de recepción en segundos.
  static const int _receiveTimeoutS = int.fromEnvironment(
    'RECEIVE_TIMEOUT_S',
    defaultValue: 30,
  );

  /// Timeout de envío en segundos.
  static const int _sendTimeoutS = int.fromEnvironment(
    'SEND_TIMEOUT_S',
    defaultValue: 15,
  );

  static Duration get connectTimeout => Duration(seconds: _connectTimeoutS);
  static Duration get receiveTimeout => Duration(seconds: _receiveTimeoutS);
  static Duration get sendTimeout    => Duration(seconds: _sendTimeoutS);
}
