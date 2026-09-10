// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curso_plantilla_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CursoPlantillaModelImpl _$$CursoPlantillaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CursoPlantillaModelImpl(
      id: (json['id'] as num).toInt(),
      codigo: json['codigo'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      color: json['color'] as String,
      materias: (json['materias'] as List<dynamic>?)
              ?.map((e) =>
                  MateriaPlantillaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CursoPlantillaModelImplToJson(
        _$CursoPlantillaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo': instance.codigo,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'color': instance.color,
      'materias': instance.materias,
    };
