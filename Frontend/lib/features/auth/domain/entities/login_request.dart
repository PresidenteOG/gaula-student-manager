import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

/// Modelo de petición de login.
/// Se serializa a JSON antes de enviarse al endpoint POST /api/auth/login.
///
/// Freezed genera automáticamente:
///   - Constructor immutable con @freezed
///   - copyWith, toString, ==, hashCode
///   - fromJson / toJson con json_serializable
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    /// Nombre de usuario del sistema. Ej: "ifernandez", "clopez"
    required String username,

    /// Contraseña en texto plano (solo en tránsito, nunca se almacena).
    required String password,
  }) = _LoginRequest;

  /// Deserializa desde JSON del backend (no se usa en la práctica para requests).
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
