import 'package:freezed_annotation/freezed_annotation.dart';

part 'profesor_model.freezed.dart';
part 'profesor_model.g.dart';

/// Modelo de dominio de Profesor.
/// Mapea el JSON del endpoint GET /api/profesores/{id}.
@freezed
class ProfesorModel with _$ProfesorModel {
  const factory ProfesorModel({
    required int    id,
    required String nombre,
    required String apellidos,
    required String nombreCompleto,
    required String username,
    required String email,
    required String estado,
    required String rol,
    required String avatar,
    String?         fotoUrl,
    String?         especialidades,
    SustitutoInfo?  sustituto,
    @Default([]) List<int>    cursosTutorIds,
    @Default([]) List<String> cursosTutorCodigos,
  }) = _ProfesorModel;

  factory ProfesorModel.fromJson(Map<String, dynamic> json) =>
      _$ProfesorModelFromJson(json);
}

/// Información resumida del sustituto, anidada en ProfesorModel.
@freezed
class SustitutoInfo with _$SustitutoInfo {
  const factory SustitutoInfo({
    required int    id,
    required String nombreCompleto,
    required String avatar,
  }) = _SustitutoInfo;

  factory SustitutoInfo.fromJson(Map<String, dynamic> json) =>
      _$SustitutoInfoFromJson(json);
}

extension ProfesorModelX on ProfesorModel {
  bool get esActivo    => estado.toUpperCase() == 'ACTIVO';
  bool get esInactivo  => estado.toUpperCase() == 'INACTIVO';
  bool get esDeBaja    => estado.toUpperCase() == 'DE_BAJA';
  bool get esAdmin     => rol.toUpperCase() == 'ADMIN';
  bool get tieneSubst  => sustituto != null;

  /// Iniciales para el avatar.
  String get iniciales {
    final p = nombreCompleto.split(' ');
    return p.length >= 2 ? '${p[0][0]}${p[1][0]}'.toUpperCase()
                         : p[0][0].toUpperCase();
  }
}
