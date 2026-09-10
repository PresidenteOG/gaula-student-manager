// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profesor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfesorModelImpl _$$ProfesorModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfesorModelImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      apellidos: json['apellidos'] as String,
      nombreCompleto: json['nombreCompleto'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      estado: json['estado'] as String,
      rol: json['rol'] as String,
      avatar: json['avatar'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      especialidades: json['especialidades'] as String?,
      sustituto: json['sustituto'] == null
          ? null
          : SustitutoInfo.fromJson(json['sustituto'] as Map<String, dynamic>),
      cursosTutorIds: (json['cursosTutorIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      cursosTutorCodigos: (json['cursosTutorCodigos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProfesorModelImplToJson(_$ProfesorModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellidos': instance.apellidos,
      'nombreCompleto': instance.nombreCompleto,
      'username': instance.username,
      'email': instance.email,
      'estado': instance.estado,
      'rol': instance.rol,
      'avatar': instance.avatar,
      'fotoUrl': instance.fotoUrl,
      'especialidades': instance.especialidades,
      'sustituto': instance.sustituto,
      'cursosTutorIds': instance.cursosTutorIds,
      'cursosTutorCodigos': instance.cursosTutorCodigos,
    };

_$SustitutoInfoImpl _$$SustitutoInfoImplFromJson(Map<String, dynamic> json) =>
    _$SustitutoInfoImpl(
      id: (json['id'] as num).toInt(),
      nombreCompleto: json['nombreCompleto'] as String,
      avatar: json['avatar'] as String,
    );

Map<String, dynamic> _$$SustitutoInfoImplToJson(_$SustitutoInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombreCompleto': instance.nombreCompleto,
      'avatar': instance.avatar,
    };
