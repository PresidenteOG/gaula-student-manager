import 'package:freezed_annotation/freezed_annotation.dart';

part 'materia_model.freezed.dart';
part 'materia_model.g.dart';

/// Modelo de dominio de Materia.
/// Mapea el JSON devuelto por los endpoints /api/materias.
@freezed
class MateriaModel with _$MateriaModel {
  const factory MateriaModel({
    required int id,
    required String codigo,
    required String nombre,
    int? horasSemanales,
    required int horasTotales,
    String? color,
  }) = _MateriaModel;

  factory MateriaModel.fromJson(Map<String, dynamic> json) =>
      _$MateriaModelFromJson(json);
}
