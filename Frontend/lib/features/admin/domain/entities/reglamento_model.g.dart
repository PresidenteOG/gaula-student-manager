// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reglamento_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReglamentoModelImpl _$$ReglamentoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReglamentoModelImpl(
      id: (json['id'] as num).toInt(),
      nombreVersion: json['nombreVersion'] as String,
      contenido: json['contenido'] as String,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      creadoPor: json['creadoPor'] as String,
      activo: json['activo'] as bool,
    );

Map<String, dynamic> _$$ReglamentoModelImplToJson(
        _$ReglamentoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombreVersion': instance.nombreVersion,
      'contenido': instance.contenido,
      'fechaCreacion': instance.fechaCreacion.toIso8601String(),
      'creadoPor': instance.creadoPor,
      'activo': instance.activo,
    };
