// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alumno_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlumnoModelImpl _$$AlumnoModelImplFromJson(Map<String, dynamic> json) =>
    _$AlumnoModelImpl(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      apellidos: json['apellidos'] as String,
      nombreCompleto: json['nombreCompleto'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      estado: json['estado'] as String,
      avatar: json['avatar'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      dni: json['dni'] as String?,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      fechaNacimiento: json['fechaNacimiento'] as String?,
      cursoId: (json['cursoId'] as num?)?.toInt(),
      codigoGrupo: json['codigoGrupo'] as String?,
      nombreCurso: json['nombreCurso'] as String?,
      materiaIds: (json['materiaIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      nombresMaterias: (json['nombresMaterias'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AlumnoModelImplToJson(_$AlumnoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellidos': instance.apellidos,
      'nombreCompleto': instance.nombreCompleto,
      'username': instance.username,
      'email': instance.email,
      'estado': instance.estado,
      'avatar': instance.avatar,
      'fotoUrl': instance.fotoUrl,
      'dni': instance.dni,
      'telefono': instance.telefono,
      'direccion': instance.direccion,
      'fechaNacimiento': instance.fechaNacimiento,
      'cursoId': instance.cursoId,
      'codigoGrupo': instance.codigoGrupo,
      'nombreCurso': instance.nombreCurso,
      'materiaIds': instance.materiaIds,
      'nombresMaterias': instance.nombresMaterias,
    };
