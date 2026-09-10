import 'package:freezed_annotation/freezed_annotation.dart';
import 'materia_plantilla_model.dart';

part 'curso_plantilla_model.freezed.dart';
part 'curso_plantilla_model.g.dart';

/// Modelo de dominio de Curso (Grupo de clase).
/// Mapea el JSON devuelto por los endpoints /api/cursos.
@freezed
class CursoPlantillaModel with _$CursoPlantillaModel {
  const factory CursoPlantillaModel({
    required int id,
    /// Código del grupo clase. Ej: "1DAM-M"
    required String codigo,
    /// Nombre del ciclo. Ej: "Desarrollo de Aplicaciones Multiplataforma"
    required String nombre,
    /// Descripción del ciclo.
    required String? descripcion,
    /// Color del ciclo.
    required String color,

    @Default([]) List<MateriaPlantillaModel> materias,
  }) = _CursoPlantillaModel;

  factory CursoPlantillaModel.fromJson(Map<String, dynamic> json) =>
      _$CursoPlantillaModelFromJson(json);
}
