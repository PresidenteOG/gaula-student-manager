// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materia_plantilla_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MateriaPlantillaModelImpl _$$MateriaPlantillaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MateriaPlantillaModelImpl(
      id: (json['id'] as num).toInt(),
      codigo: json['codigo'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      tipo: json['tipo'] as String,
      horasTotales: (json['horasTotales'] as num).toInt(),
    );

Map<String, dynamic> _$$MateriaPlantillaModelImplToJson(
        _$MateriaPlantillaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo': instance.codigo,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'tipo': instance.tipo,
      'horasTotales': instance.horasTotales,
    };
