// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      id: (json['id'] as num).toInt(),
      token: json['token'] as String,
      tipo: json['tipo'] as String,
      username: json['username'] as String,
      nombre: json['nombre'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      avatar: json['avatar'] as String,
      theme: json['theme'] as String? ?? 'light',
      cursosTutorIds: (json['cursosTutorIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'tipo': instance.tipo,
      'username': instance.username,
      'nombre': instance.nombre,
      'roles': instance.roles,
      'avatar': instance.avatar,
      'theme': instance.theme,
      'cursosTutorIds': instance.cursosTutorIds,
    };
