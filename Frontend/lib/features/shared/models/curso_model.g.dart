// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curso_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CursoModelImpl _$$CursoModelImplFromJson(Map<String, dynamic> json) =>
    _$CursoModelImpl(
      id: (json['id'] as num).toInt(),
      codigoGrupo: json['codigoGrupo'] as String,
      codigoCiclo: json['codigoCiclo'] as String,
      nombreCiclo: json['nombreCiclo'] as String,
      colorCiclo: json['colorCiclo'] as String,
      anioEscolarId: (json['anioEscolarId'] as num?)?.toInt(),
      turno: json['turno'] as String?,
      desdoblamiento: json['desdoblamiento'] as String?,
      etapaCurso: (json['etapaCurso'] as num?)?.toInt(),
      tutorId: (json['tutorId'] as num?)?.toInt(),
      tutorNombre: json['tutorNombre'] as String?,
      tutorAvatar: json['tutorAvatar'] as String?,
      totalAlumnos: (json['totalAlumnos'] as num?)?.toInt(),
      totalMaterias: (json['totalMaterias'] as num?)?.toInt(),
      materias: (json['materias'] as List<dynamic>?)
              ?.map((e) => MateriaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CursoModelImplToJson(_$CursoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigoGrupo': instance.codigoGrupo,
      'codigoCiclo': instance.codigoCiclo,
      'nombreCiclo': instance.nombreCiclo,
      'colorCiclo': instance.colorCiclo,
      'anioEscolarId': instance.anioEscolarId,
      'turno': instance.turno,
      'desdoblamiento': instance.desdoblamiento,
      'etapaCurso': instance.etapaCurso,
      'tutorId': instance.tutorId,
      'tutorNombre': instance.tutorNombre,
      'tutorAvatar': instance.tutorAvatar,
      'totalAlumnos': instance.totalAlumnos,
      'totalMaterias': instance.totalMaterias,
      'materias': instance.materias,
    };
