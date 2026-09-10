import 'package:freezed_annotation/freezed_annotation.dart';

part 'alumno_model.freezed.dart';
part 'alumno_model.g.dart';

/// Modelo de dominio de Alumno.
/// Mapea el JSON que devuelve el endpoint GET /api/alumnos/{id} del backend.
@freezed
class AlumnoModel with _$AlumnoModel {
  const factory AlumnoModel({
    required int    id,
    required String nombre,
    required String apellidos,
    required String nombreCompleto,
    required String username,
    required String email,
    required String estado,
    required String avatar,
    String?         fotoUrl,
    String?         dni,
    String?         telefono,
    String?         direccion,
    String?         fechaNacimiento,
    int?            cursoId,
    String?         codigoGrupo,
    String?         nombreCurso,
    @Default([]) List<int>    materiaIds,
    @Default([]) List<String> nombresMaterias,
  }) = _AlumnoModel;

  factory AlumnoModel.fromJson(Map<String, dynamic> json) =>
      _$AlumnoModelFromJson(json);
}

/// Extensión de utilidad para la UI.
extension AlumnoModelX on AlumnoModel {
  /// True si el alumno está activo.
  bool get esActivo   => estado.toUpperCase() == 'ACTIVO';
  bool get esInactivo => estado.toUpperCase() == 'INACTIVO';
  bool get esDeBaja   => estado.toUpperCase() == 'DE_BAJA';

  /// Iniciales para mostrar en avatares sin imagen.
  String get iniciales {
    // split(' ') sobre '' devuelve [''], no []. Filtramos partes vacías.
    final partes = nombreCompleto.split(' ').where((p) => p.isNotEmpty).toList();
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return partes.isNotEmpty ? partes[0][0].toUpperCase() : '?';
  }
}
