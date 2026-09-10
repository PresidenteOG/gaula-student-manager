// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materia_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MateriaModelImpl _$$MateriaModelImplFromJson(Map<String, dynamic> json) =>
    _$MateriaModelImpl(
      id: (json['id'] as num).toInt(),
      codigo: json['codigo'] as String,
      nombre: json['nombre'] as String,
      horasSemanales: (json['horasSemanales'] as num?)?.toInt(),
      horasTotales: (json['horasTotales'] as num).toInt(),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$MateriaModelImplToJson(_$MateriaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo': instance.codigo,
      'nombre': instance.nombre,
      'horasSemanales': instance.horasSemanales,
      'horasTotales': instance.horasTotales,
      'color': instance.color,
    };
