import 'package:freezed_annotation/freezed_annotation.dart';

part 'materia_plantilla_model.freezed.dart';
part 'materia_plantilla_model.g.dart';

/// Modelo de dominio de Materia.
/// Mapea el JSON devuelto por los endpoints /api/materias.
@freezed
class MateriaPlantillaModel with _$MateriaPlantillaModel {
  const factory MateriaPlantillaModel({
    required int id,
    required String codigo,
    required String nombre,
    required String? descripcion,
    required String tipo,
    required int horasTotales,
  }) = _MateriaPlantillaModel;

  factory MateriaPlantillaModel.fromJson(Map<String, dynamic> json) =>
      _$MateriaPlantillaModelFromJson(json);
}
