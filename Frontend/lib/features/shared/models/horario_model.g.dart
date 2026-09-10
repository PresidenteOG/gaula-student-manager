// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HorarioSesionModelImpl _$$HorarioSesionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HorarioSesionModelImpl(
      id: (json['id'] as num).toInt(),
      diaSemana: json['diaSemana'] as String,
      diaEspanol: json['diaEspanol'] as String,
      horaInicio: json['horaInicio'] as String,
      horaFin: json['horaFin'] as String,
      aula: json['aula'] as String?,
      materiaId: (json['materiaId'] as num?)?.toInt(),
      materiaNombre: json['materiaNombre'] as String?,
      materiaCodigo: json['materiaCodigo'] as String?,
      profesorId: (json['profesorId'] as num?)?.toInt(),
      profesorNombre: json['profesorNombre'] as String?,
      profesorAvatar: json['profesorAvatar'] as String?,
      sustitutoId: (json['sustitutoId'] as num?)?.toInt(),
      sustitutoNombre: json['sustitutoNombre'] as String?,
      sustitutoAvatar: json['sustitutoAvatar'] as String?,
      cursoId: (json['cursoId'] as num?)?.toInt(),
      codigoGrupo: json['codigoGrupo'] as String?,
      colorCiclo: json['colorCiclo'] as String?,
    );

Map<String, dynamic> _$$HorarioSesionModelImplToJson(
        _$HorarioSesionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'diaSemana': instance.diaSemana,
      'diaEspanol': instance.diaEspanol,
      'horaInicio': instance.horaInicio,
      'horaFin': instance.horaFin,
      'aula': instance.aula,
      'materiaId': instance.materiaId,
      'materiaNombre': instance.materiaNombre,
      'materiaCodigo': instance.materiaCodigo,
      'profesorId': instance.profesorId,
      'profesorNombre': instance.profesorNombre,
      'profesorAvatar': instance.profesorAvatar,
      'sustitutoId': instance.sustitutoId,
      'sustitutoNombre': instance.sustitutoNombre,
      'sustitutoAvatar': instance.sustitutoAvatar,
      'cursoId': instance.cursoId,
      'codigoGrupo': instance.codigoGrupo,
      'colorCiclo': instance.colorCiclo,
    };
