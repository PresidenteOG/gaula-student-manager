import 'package:freezed_annotation/freezed_annotation.dart';

part 'reglamento_model.freezed.dart';
part 'reglamento_model.g.dart';

@freezed
class ReglamentoModel with _$ReglamentoModel {
  const factory ReglamentoModel({
    required int id,
    required String nombreVersion,
    required String contenido,
    required DateTime fechaCreacion,
    required String creadoPor,
    required bool activo,
  }) = _ReglamentoModel;

  factory ReglamentoModel.fromJson(Map<String, dynamic> json) => _$ReglamentoModelFromJson(json);
}
