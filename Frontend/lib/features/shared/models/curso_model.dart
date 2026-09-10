import 'package:freezed_annotation/freezed_annotation.dart';
import 'materia_model.dart';

part 'curso_model.freezed.dart';
part 'curso_model.g.dart';

/// Modelo de dominio de Curso (Grupo de clase).
/// Mapea el JSON devuelto por los endpoints /api/cursos.
@freezed
class CursoModel with _$CursoModel {
  const factory CursoModel({
    required int id,
    /// Código del grupo clase. Ej: "1DAM-M"
    required String codigoGrupo,
    /// Código del ciclo. Ej: "DAM"
    required String codigoCiclo,
    /// Nombre del ciclo. Ej: "Desarrollo de Aplicaciones Multiplataforma"
    required String nombreCiclo,
    /// Color del ciclo.
    required String colorCiclo,
    int? anioEscolarId,
    String? turno,
    String? desdoblamiento,
    int? etapaCurso,
    int? tutorId,
    String? tutorNombre,
    String? tutorAvatar,
    int? totalAlumnos,
    int? totalMaterias,

    @Default([]) List<MateriaModel> materias,
  }) = _CursoModel;

  factory CursoModel.fromJson(Map<String, dynamic> json) =>
      _$CursoModelFromJson(json);
}
