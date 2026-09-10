import 'package:freezed_annotation/freezed_annotation.dart';

part 'horario_model.freezed.dart';
part 'horario_model.g.dart';

/// Modelo de sesión en el horario semanal.
/// Mapea el JSON del endpoint GET /api/horario/profesor/{id}.
@freezed
class HorarioSesionModel with _$HorarioSesionModel {
  const factory HorarioSesionModel({
    required int    id,
    required String diaSemana,     // "MONDAY"
    required String diaEspanol,    // "Lunes"
    required String horaInicio,    // "08:00"
    required String horaFin,       // "09:30"
    String?         aula,
    // Materia
    int?            materiaId,
    String?         materiaNombre,
    String?         materiaCodigo,
    // Profesor
    int?            profesorId,
    String?         profesorNombre,
    String?         profesorAvatar,
    // Sustituto (si el profesor está de baja)
    int?            sustitutoId,
    String?         sustitutoNombre,
    String?         sustitutoAvatar,
    // Grupo y ciclo
    int?            cursoId,
    String?         codigoGrupo,
    String?         colorCiclo,
  }) = _HorarioSesionModel;

  factory HorarioSesionModel.fromJson(Map<String, dynamic> json) =>
      _$HorarioSesionModelFromJson(json);
}

extension HorarioSesionModelX on HorarioSesionModel {
  /// Duración de la sesion en minutos.
  int get duracionMinutos {
    final ini = _parseTime(horaInicio);
    final fin = _parseTime(horaFin);
    return fin - ini;
  }

  int _parseTime(String t) {
    final p = t.split(':');
    return int.parse(p[0]) * 60 + int.parse(p[1]);
  }

  /// True si hay sustituto asignado para esta clase.
  bool get haySubstituto => sustitutoId != null;

  /// Nombre del docente efectivo (sustituto si existe, titular si no).
  String get docenteEfectivo =>
      sustitutoNombre ?? profesorNombre ?? 'Sin asignar';
}
