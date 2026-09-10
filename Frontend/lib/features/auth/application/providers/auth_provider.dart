import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/login_request.dart';
import '../../domain/entities/login_response.dart';
import '../../infrastructure/repositories/auth_repository.dart';
import '../../../../shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../../admin/application/providers/cursos_provider.dart';
import '../../../admin/application/providers/alumnos_provider.dart';
import '../../../admin/application/providers/admin_dashboard_provider.dart';
import '../../../admin/application/providers/profesores_provider.dart';
import '../../../admin/application/providers/notification_provider.dart';
import '../../../teacher/application/providers/teacher_dashboard_provider.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Estado de la sesión de autenticación
// ─────────────────────────────────────────────────────────────────────────────

/// Estado inmutable de la sesión GAULA.
/// El router observa [authStateProvider] y redirige según el estado.
@freezed
class AuthState with _$AuthState {
  /// Estado inicial: verificando si hay sesión guardada en SecureStorage.
  const factory AuthState.initial() = _Initial;

  /// No autenticado: mostrar pantalla de login.
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Autenticado: datos del usuario disponibles.
  const factory AuthState.authenticated({
    required LoginResponse usuario,
  }) = _Authenticated;

  /// Error de autenticación: mostrar mensaje en la UI.
  const factory AuthState.error({
    required String mensaje,
  }) = _Error;

  /// Cargando: petición al backend en curso.
  const factory AuthState.loading() = _Loading;

  /// Servidor en mantenimiento.
  const factory AuthState.maintenance() = _Maintenance;
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier — lógica de autenticación
// ─────────────────────────────────────────────────────────────────────────────

/// Provider principal de autenticación.
/// Gestiona el ciclo de vida de la sesión JWT.
///
/// FLUJO DE ARRANQUE:
///   1. build() se ejecuta al crear el provider
///   2. Comprueba SecureStorage (isLoggedIn)
///   3. Si hay sesión → estado Authenticated (lee datos del storage)
///   4. Si no → estado Unauthenticated (ir al login)
///
/// NOTA: Los archivos .freezed.dart y .g.dart se generan ejecutando:
///   dart run build_runner build --delete-conflicting-outputs
@riverpod
class AuthNotifier extends _$AuthNotifier {
  /// Static guard — must be static so it survives Riverpod invalidate() calls
  /// that destroy and recreate this notifier instance. An instance field would
  /// reset to false on every rebuild, defeating the re-entrancy protection.
  static bool _isLoggingOut = false;

  @override
  AuthState build() {
    // Verificar sesión al inicializar el provider (de forma así­ncrona)
    _checkSesionActiva();
    return const AuthState.initial();
  }

  /// Verifica si hay una sesión guardada en SecureStorage al arrancar la app.
  /// Lee el token real del storage y lo embebe en el LoginResponse para que
  /// el interceptor Dio lo pueda inyectar en el header Authorization.
  Future<void> _checkSesionActiva() async {
    final repo     = ref.read(authRepositoryProvider);
    final loggedIn = await repo.isLoggedIn();

    if (loggedIn) {
      final id       = await repo.getUserId();
      final username = await repo.getUsername();
      final nombre   = await repo.getNombre();
      final rol      = await repo.getRol();
      final avatar   = await repo.getAvatar();
      final themeStr = await repo.getTheme();
      // CRITICAL FIX: read the actual JWT so Dio can attach it to every request.
      // Previously this was hardcoded to '' which caused every API call to be
      // anonymous → 401 → provider invalidated → infinite rebuild/logout loop.
      final token    = await repo.getToken();

      // Sincronizar el tema local con el guardado
      if (themeStr != null) {
        ref.read(themeModeProvider.notifier).setTheme(
          themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light
        );
      }

      if (username != null && token != null && token.isNotEmpty) {
        state = AuthState.authenticated(
          usuario: LoginResponse(
            id:       id       ?? 0,
            token:    token,
            tipo:     'Bearer',
            username: username,
            nombre:   nombre   ?? username,
            roles:    rol      != null ? [rol] : ['ROLE_STUDENT'],
            avatar:   avatar   ?? '',
            theme:    themeStr ?? 'light',
          ),
        );
        return;
      }
    }

    state = const AuthState.unauthenticated();
  }

  /// Inicia sesión con username y password.
  /// Actualiza el estado a Loading → Authenticated | Error.
  Future<void> login(String username, String password) async {
    state = const AuthState.loading();

    try {
      final repo     = ref.read(authRepositoryProvider);
      final response = await repo.login(
        LoginRequest(username: username.trim(), password: password),
      );
      
      // Sincronizar el tema del usuario logueado
      ref.read(themeModeProvider.notifier).setTheme(
        response.theme == 'dark' ? ThemeMode.dark : ThemeMode.light
      );

      state = AuthState.authenticated(usuario: response);
    } on AuthException catch (e) {
      state = AuthState.error(mensaje: e.mensaje);
    } catch (e, stack) {
      // Log real para diagnóstico — visible en flutter run o DevTools
      assert(() {
        // ignore: avoid_print
        print('[GAULA AUTH] Error inesperado en login: ${e.runtimeType}: $e');
        // ignore: avoid_print
        print('[GAULA AUTH] Stack: $stack');
        return true;
      }());
      // Si el interceptor de Dio ya puso la app en mantenimiento, no sobreescribimos con error
      final isMaintenance = state.maybeMap(
        maintenance: (_) => true,
        orElse: () => false,
      );
      if (!isMaintenance) {
        state = AuthState.error(mensaje: 'Error inesperado. Inténtalo de nuevo.');
      }
    }
  }

  /// Cierra sesión y redirige al login.
  /// La bandera [_isLoggingOut] evita que el interceptor 401 vuelva a
  /// disparar un segundo logout mientras el primero está en curso.
  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();
      _invalidateSessionProviders();
      state = const AuthState.unauthenticated();
    } finally {
      _isLoggingOut = false;
    }
  }

  /// Fuerza el modo de mantenimiento cuando el backend está caí­do.
  Future<void> setMaintenanceMode() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();
      _invalidateSessionProviders();
      state = const AuthState.maintenance();
    } finally {
      _isLoggingOut = false;
    }
  }

  /// Invalida todos los providers con datos de sesión para evitar
  /// que se muestren datos del usuario anterior tras el logout.
  void _invalidateSessionProviders() {
    Future.microtask(() {
      ref.invalidate(cursosListProvider);
      ref.invalidate(alumnosListProvider);
      ref.invalidate(adminDashboardProvider);
      ref.invalidate(profesoresListProvider);
      ref.invalidate(alumnosTodosProvider);
      ref.invalidate(notificationProvider);
      ref.invalidate(teacherDashboardProvider);
    });
  }

  /// Sube y actualiza el avatar del usuario.
  Future<void> updateAvatar(List<int> bytes, String fileName) async {
    final currentState = state;
    if (currentState is _Authenticated) {
      try {
        final repo      = ref.read(authRepositoryProvider);
        final newAvatar = await repo.uploadAvatar(bytes, fileName);
        
        final updatedUser = currentState.usuario.copyWith(avatar: newAvatar);
        state = AuthState.authenticated(usuario: updatedUser);
        
      } catch (e) {
        assert(() { debugPrint('Error al subir avatar: $e'); return true; }());
      }
    }
  }

  /// Obtiene los datos completos del perfil desde el backend (GET /api/profile).
  Future<Map<String, dynamic>> fetchProfile() async {
    final repo = ref.read(authRepositoryProvider);
    return repo.getProfile();
  }

  /// Actualiza el perfil propio. Propaga [ValidationException] para que la UI
  /// muestre errores por campo. En éxito sincroniza nombre/avatar en el estado.
  Future<Map<String, dynamic>> updatePerfil(Map<String, dynamic> data) async {
    final currentState = state;
    final repo = ref.read(authRepositoryProvider);
    final updated = await repo.updatePerfil(data);

    if (currentState is _Authenticated) {
      final nuevoNombre = (updated['nombreCompleto'] ?? updated['nombre'])?.toString();
      if (nuevoNombre != null && nuevoNombre.isNotEmpty) {
        state = AuthState.authenticated(
          usuario: currentState.usuario.copyWith(nombre: nuevoNombre),
        );
      }
    }
    return updated;
  }

  /// Elimina la foto de perfil y restaura el avatar por defecto.
  Future<void> deleteAvatar() async {
    final currentState = state;
    if (currentState is _Authenticated) {
      try {
        final repo = ref.read(authRepositoryProvider);
        await repo.deleteAvatar();
        final updatedUser = currentState.usuario.copyWith(avatar: '');
        state = AuthState.authenticated(usuario: updatedUser);

      } catch (e) {
        assert(() { debugPrint('Error al eliminar avatar: $e'); return true; }());
      }
    }
  }


  Future<void> updateTheme(ThemeMode mode) async {
    final currentState = state;
    if (currentState is _Authenticated) {
      try {
        final repo      = ref.read(authRepositoryProvider);
        final newTheme = mode == ThemeMode.dark ? 'dark' : 'light';
        await repo.updateTheme(newTheme);
        
        final updatedUser = currentState.usuario.copyWith(theme: newTheme);
        state = AuthState.authenticated(usuario: updatedUser);
        
      } catch (e) {
        assert(() { debugPrint('Error al actualizar tema: $e'); return true; }());
      }
    }
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Provider de conveniencia — datos del usuario actual
// ─────────────────────────────────────────────────────────────────────────────

/// Provider que devuelve el usuario autenticado o null si no hay sesión.
/// Útil para acceder a datos del usuario desde cualquier widget:
///   final usuario = ref.watch(usuarioActualProvider);
final usuarioActualProvider = Provider<LoginResponse?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.maybeWhen(
    authenticated: (usuario) => usuario,
    orElse: () => null,
  );
});

/// Provider que indica si el usuario es admin.
final esAdminProvider = Provider<bool>((ref) {
  return ref.watch(usuarioActualProvider)?.esAdmin ?? false;
});

/// Provider que indica si el usuario es profesor.
final esProfesorProvider = Provider<bool>((ref) {
  return ref.watch(usuarioActualProvider)?.esProfesor ?? false;
});

/// Provider que indica si el usuario es alumno.
final esAlumnoProvider = Provider<bool>((ref) {
  return ref.watch(usuarioActualProvider)?.esAlumno ?? false;
});






