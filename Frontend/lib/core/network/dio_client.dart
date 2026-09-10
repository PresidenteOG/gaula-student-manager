import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/application/providers/auth_provider.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

/// Cliente Dio centralizado para todas las peticiones HTTP al backend GAULA.
///
/// Responsabilidades:
///   1. Configurar la URL base y los timeouts globales
///   2. Inyectar el token JWT en cada petición (Bearer Authentication)
///   3. Interceptar respuestas 401 y disparar logout global
///   4. Loguear peticiones y respuestas en modo debug
///
/// Se provee como singleton a través de Riverpod para que todos los
/// repositorios compartan la misma instancia configurada.


/// Provider del cliente Dio — accesible desde cualquier repositorio.
/// Recibe [SecureStorageService] ví­a Riverpod para compartir la misma
/// instancia que [authRepositoryProvider] y evitar desincronización de estado.
final dioClientProvider = Provider<Dio>((ref) {
  // CORRECCIÓN #1: inyectar storage desde Riverpod, no instanciar aquí­.
  // Garantiza que el interceptor 401 opera sobre el mismo objeto de
  // almacenamiento que el AuthRepository → elimina race condition.
  final storage = ref.watch(secureStorageProvider);

  // Pasar ref al interceptor para invalidar authNotifierProvider en el 401.
  return DioClient(storage, ref).dio;
});

class DioClient {
  late final Dio dio;
  final SecureStorageService _storage;

  DioClient(this._storage, Ref ref) {
    // ── Configuración base ──
    dio = Dio(
      BaseOptions(
        baseUrl:        ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout:    ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept':       'application/json',
        },
      ),
    );

    // ── Interceptores (orden: primero el de auth, luego el logger) ──
    dio.interceptors.addAll([
      _AuthInterceptor(_storage, ref),
      _LogInterceptor(),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Interceptor de Autenticación
// Inyecta el token JWT en el header Authorization de cada petición.
// Si la respuesta es 401, limpia la sesión (el router redirigirá al login).
// ─────────────────────────────────────────────────────────────────────────────
class _AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Ref _ref;

  _AuthInterceptor(this._storage, this._ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Always read from storage so a stale in-memory value can never send
    // a previous user's token after logout + re-login with a different account.
    final token = await _storage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    // LOGGING PARA DEPURACIÓN (Ver en consola de Flutter)
    debugPrint('[GAULA HTTP ERROR] Type: ${err.type}, Status: $statusCode, Path: ${err.requestOptions.path}');
    if (err.error != null) debugPrint('[GAULA HTTP ERROR] Detail: ${err.error}');

    final bool isAuthEndpoint = err.requestOptions.path.contains('/auth/');

    // Read auth state once — used by both branches below.
    final currentState = _ref.read(authNotifierProvider);
    final alreadyInactive = currentState.maybeWhen(
      unauthenticated: () => true,
      maintenance:     () => true,
      orElse:          () => false,
    );

    if (statusCode == 401) {
      // Guard: only invalidate if currently authenticated.
      // Without this, the 401 rebuilds the notifier → _checkSesionActiva
      // (cleared storage) → unauthenticated → but concurrent providers
      // still in flight fire more 401s → infinite invalidate loop.
      if (!alreadyInactive) {
        await _storage.clearAll();
        _ref.invalidate(authNotifierProvider);
      }
    } else if (!isAuthEndpoint &&
               (err.type == DioExceptionType.connectionTimeout ||
                err.type == DioExceptionType.receiveTimeout ||
                err.type == DioExceptionType.connectionError ||
                err.type == DioExceptionType.unknown ||
                statusCode == 502 || statusCode == 503 || statusCode == 504)) {
      // Guard: only trigger maintenance if still authenticated.
      // Without this, every simultaneous provider timeout fires
      // POST /api/auth/logout, compounding the request storm.
      if (!alreadyInactive) {
        _ref.read(authNotifierProvider.notifier).setMaintenanceMode();
      }
    }

    if (statusCode == 429) {
      assert(() {
        // ignore: avoid_print
        print('⚠️ [GAULA HTTP] Rate limit excedido para esta IP.');
        return true;
      }());
    }

    handler.next(err);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Interceptor de Logging
// Solo activo en modo debug. Muestra peticiones y respuestas en consola.
// ─────────────────────────────────────────────────────────────────────────────
class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('🌐 [GAULA HTTP] ${options.method} ${options.uri}');
      if (options.data != null) {
        // ignore: avoid_print
        print('   Body: ${options.data}');
      }
      return true;
    }());
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('✅ [GAULA HTTP] ${response.statusCode} ${response.realUri}');
      return true;
    }());
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('❌ [GAULA HTTP] Error ${err.response?.statusCode}: ${err.message}');
      if (err.response?.data != null) {
        // ignore: avoid_print
        print('   Respuesta: ${err.response?.data}');
      }
      return true;
    }());
    return handler.next(err);
  }
}

