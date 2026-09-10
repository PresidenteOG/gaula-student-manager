import 'package:freezed_annotation/freezed_annotation.dart';

part 'evento_model.freezed.dart';
part 'evento_model.g.dart';

@freezed
class EventoModel with _$EventoModel {
  const factory EventoModel({
    required int id,
    required String titulo,
    required String descripcion,
    required String fecha, // ISO 8601 (yyyy-MM-dd)
    required String tipo,   // EXAMEN, FESTIVO, EVENTO
    int? cursoId,
  }) = _EventoModel;

  factory EventoModel.fromJson(Map<String, dynamic> json) =>
      _$EventoModelFromJson(json);
}
