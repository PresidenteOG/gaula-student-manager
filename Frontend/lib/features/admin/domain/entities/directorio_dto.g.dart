// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directorio_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DirectorioDtoImpl _$$DirectorioDtoImplFromJson(Map<String, dynamic> json) =>
    _$DirectorioDtoImpl(
      nombre: json['nombre'] as String,
      ruta: json['ruta'] as String,
      esDirectorio: json['esDirectorio'] as bool,
    );

Map<String, dynamic> _$$DirectorioDtoImplToJson(_$DirectorioDtoImpl instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'ruta': instance.ruta,
      'esDirectorio': instance.esDirectorio,
    };
