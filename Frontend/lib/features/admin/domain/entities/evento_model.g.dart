// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evento_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventoModelImpl _$$EventoModelImplFromJson(Map<String, dynamic> json) =>
    _$EventoModelImpl(
      id: (json['id'] as num).toInt(),
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      fecha: json['fecha'] as String,
      tipo: json['tipo'] as String,
      cursoId: (json['cursoId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EventoModelImplToJson(_$EventoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descripcion': instance.descripcion,
      'fecha': instance.fecha,
      'tipo': instance.tipo,
      'cursoId': instance.cursoId,
    };
