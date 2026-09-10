import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Modelo de respuesta del backend tras un login exitoso.
/// Mapea el DTO LoginResponse del backend Spring Boot.
///
/// El cliente guarda [token] en SecureStorage y [roles] para decidir
/// qué pantalla inicial mostrar (admin → dashboard, teacher → horario, etc.)
@freezed
class LoginResponse with _$LoginResponse {
  const LoginResponse._(); // Constructor privado para permitir métodos personalizados

  const factory LoginResponse({
    /// ID único del usuario en la base de datos (clave primaria).
    required int id,

    /// Token JWT firmado con HS512 para incluir en peticiones futuras.
    required String token,

    /// Tipo de token, siempre "Bearer".
    required String tipo,

    /// Username del usuario autenticado.
    required String username,

    /// Nombre completo: "Isabel Fernández Ruiz"
    required String nombre,

    /// Roles de Spring Security: ["ROLE_ADMIN"], ["ROLE_TEACHER"], ["ROLE_STUDENT"]
    required List<String> roles,

    /// Emoji o URL de avatar para la cabecera de navegación.
    required String avatar,

    /// Preferencia de tema: "light" o "dark".
    @Default('light') String theme,

    /// IDs de los cursos de los que este profesor es tutor.
    /// Vacío para alumnos y admins.
    @Default([]) List<int> cursosTutorIds,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  /// Devuelve el rol principal (el primero de la lista).
  String get rolPrincipal => roles.isNotEmpty ? roles.first : '';

  /// True si el usuario es administrador.
  bool get esAdmin   => roles.contains('ROLE_ADMIN');

  /// True si el usuario es profesor (docente).
  bool get esDocente => roles.contains('ROLE_TEACHER');

  /// Alias compatible con el router
  bool get esProfesor => esDocente;

  /// True si el usuario es alumno.
  bool get esAlumno  => roles.contains('ROLE_STUDENT');
}
