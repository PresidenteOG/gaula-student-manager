import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/entities/login_response.dart';

/// Provider del repositorio de autenticación.
/// Expone [AuthRepository] para ser inyectado en los providers de Riverpod.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio:     ref.watch(dioClientProvider),
    // Compartir la misma instancia de SecureStorageService que el interceptor
    // de Dio. Sin esto, AuthRepository y _AuthInterceptor operan sobre objetos
    // distintos → clearAll() en uno no afecta al otro → race condition.
    storage: ref.watch(secureStorageProvider),
  );
});

/// Repositorio de autenticación.
///
/// Responsabilidades:
///   1. Llamar al endpoint POST /api/auth/login
///   2. Guardar el token JWT y datos del usuario en SecureStorage
///   3. Limpiar la sesión en el logout
///   4. Comprobar si hay sesión activa al arrancar la app
///
/// Centraliza el manejo de errores HTTP: lanza excepciones tipadas
/// que el provider interpreta para mostrar mensajes de error en la UI.
class AuthRepository {
  final Dio                _dio;
  final SecureStorageService _storage;

  AuthRepository({required Dio dio, required SecureStorageService storage})
    : _dio     = dio,
      _storage = storage;

  /// Autentica al usuario con username y password.
  ///
  /// Si el login es exitoso:
  ///   - Guarda el token JWT en SecureStorage
  ///   - Guarda los datos del usuario (username, nombre, rol, avatar)
  ///   - Devuelve el [LoginResponse] completo
  ///
  /// Si falla, lanza una [AuthException] con el mensaje del backend.
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      // Parsear la respuesta del backend
      final loginResponse = LoginResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      // Guardar la sesión en almacenamiento seguro
      // Wrap individual para detectar si el error viene del storage (no del HTTP)
      try {
        await _storage.saveToken(loginResponse.token);
        await _storage.saveUserData(
          id:       loginResponse.id,
          username: loginResponse.username,
          nombre:   loginResponse.nombre,
          rol:      loginResponse.rolPrincipal,
          avatar:   loginResponse.avatar,
          theme:    loginResponse.theme,
        );
      } catch (storageError) {
        // El login HTTP fue exitoso pero el almacenamiento fallo.
        // En Flutter Web con builds de producción esto puede ocurrir si
        // flutter_secure_storage no puede acceder a localStorage desde este origen.
        // Continuamos igual — la sesión funciona en memoria aunque no persista.
        assert(() {
          // ignore: avoid_print
          print('[GAULA AUTH] Storage error (non-fatal): $storageError');
          return true;
        }());
      }

      return loginResponse;

    } on DioException catch (e) {
      // Extraer el mensaje de error del backend (GlobalExceptionHandler)
      final mensaje = _extraerMensajeError(e);
      throw AuthException(mensaje);
    }
  }

  /// Sube una nueva foto de perfil al servidor.
  Future<String> uploadAvatar(List<int> bytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
      });

      final response = await _dio.post(
        ApiConstants.profileAvatar,
        data: formData,
      );

      // Backend returns 'avatar' key (fallback to 'url' for older responses)
      final data = response.data as Map;
      final newAvatar = (data['avatar'] ?? data['url']) as String;

      // Actualizar el avatar en el almacenamiento local
      await _storage.saveAvatar(newAvatar);

      return newAvatar;

    } on DioException catch (e) {
      throw AuthException(_extraerMensajeError(e));
    }
  }

  /// Elimina la foto de perfil del usuario (vuelve al avatar por defecto).
  Future<void> deleteAvatar() async {
    try {
      await _dio.delete(ApiConstants.profileAvatar);
      await _storage.saveAvatar('\uD83D\uDC64'); // Reset to default person emoji
    } on DioException catch (e) {
      throw AuthException(_extraerMensajeError(e));
    }
  }

  /// Obtiene los datos completos del perfil del usuario autenticado.
  /// Devuelve el JSON crudo (AlumnoDto o ProfesorDto) para precargar el formulario.
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      throw AuthException(_extraerMensajeError(e));
    }
  }

  /// Actualiza los datos del perfil propio (PUT /api/profile).
  ///
  /// En caso de error de validación (400) lanza [ValidationException] con el
  /// mapa campo→mensaje que devuelve `GlobalExceptionHandler`, para que la UI
  /// muestre errores inline por campo. Otros errores → [AuthException].
  /// Devuelve el perfil actualizado (JSON crudo).
  Future<Map<String, dynamic>> updatePerfil(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(ApiConstants.profile, data: data);
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      final resp = e.response?.data;
      if (e.response?.statusCode == 400 && resp is Map && resp['errores'] is Map) {
        final errores = (resp['errores'] as Map).map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        );
        throw ValidationException(
          resp['mensaje']?.toString() ?? 'Error de validación',
          errores,
        );
      }
      throw AuthException(_extraerMensajeError(e));
    }
  }

  /// Actualiza la preferencia de tema en el servidor y localmente.
  Future<void> updateTheme(String theme) async {
    try {
      await _dio.patch(
        ApiConstants.profileTheme,
        queryParameters: {'theme': theme},
      );

      // Actualizar localmente para persistencia entre reinicios
      await _storage.saveTheme(theme);

    } on DioException catch (e) {
      throw AuthException(_extraerMensajeError(e));
    }
  }

  /// Solicita el código de recuperación por email.
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(
        ApiConstants.forgotPassword,
        queryParameters: {'email': email},
      );
    } on DioException catch (e) {
      throw AuthException(_extraerMensajeError(e));
    }
  }

  /// Restablece la contraseña usando el código recibido.
  Future<void> resetPassword(String code, String newPassword) async {
    try {
      await _dio.post(
        ApiConstants.resetPassword,
        data: {
          'code': code,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw AuthException(_extraerMensajeError(e));
    }
  }

  /// Cierra la sesión del usuario.
  /// Invalida el JWT en el servidor y elimina los datos locales.
  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
    } catch (_) {
      // Server call is best-effort — always clear local state regardless.
    }
    await _storage.clearAll();
  }

  /// Comprueba si hay una sesión activa guardada.
  /// Se llama al arrancar la app para decidir si ir al login o al dashboard.
  Future<bool> isLoggedIn() => _storage.isLoggedIn();

  /// Lee datos especí­ficos del usuario guardados en SecureStorage.
  Future<int?> getUserId()     => _storage.getUserId();
  Future<String?> getUsername() => _storage.getUsername();
  Future<String?> getNombre()   => _storage.getNombre();
  Future<String?> getRol()      => _storage.getRol();
  Future<String?> getAvatar()   => _storage.getAvatar();
  Future<String?> getTheme()    => _storage.getTheme();
  /// Lee el token JWT guardado. Necesario para restaurar la sesión al arrancar.
  Future<String?> getToken()    => _storage.getToken();

  /// Lee el rol del usuario guardado en SecureStorage.

  /// Extrae el mensaje de error legible de una excepción DioException.
  String _extraerMensajeError(DioException e) {
    // Si el backend devuelve un JSON con "mensaje", usarlo
    final data = e.response?.data;
    if (data is Map && data.containsKey('mensaje')) {
      return data['mensaje'] as String;
    }
    // Errores de conectividad
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'No se puede conectar con el servidor. Verifica tu conexión.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Error de conexión. ¿Está el servidor arrancado?';
    }
    // Error genérico
    return 'Error de autenticación. Inténtalo de nuevo.';
  }
}

/// Excepción tipada de autenticación.
/// Se propaga desde el repositorio hasta el provider y la UI.
class AuthException implements Exception {
  final String mensaje;
  AuthException(this.mensaje);

  @override
  String toString() => 'AuthException: $mensaje';
}

/// Excepción de validación del backend (HTTP 400).
/// Contiene el mapa campo→mensaje para mostrar errores inline en el formulario.
class ValidationException implements Exception {
  final String mensaje;
  final Map<String, String> errores;
  ValidationException(this.mensaje, this.errores);

  @override
  String toString() => 'ValidationException: $mensaje $errores';
}

