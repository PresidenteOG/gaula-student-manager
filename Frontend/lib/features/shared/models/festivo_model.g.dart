// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'festivo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FestivoModelImpl _$$FestivoModelImplFromJson(Map<String, dynamic> json) =>
    _$FestivoModelImpl(
      date: json['date'] as String,
      localName: json['localName'] as String,
      name: json['name'] as String,
      counties: (json['counties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isNational: json['isNational'] as bool? ?? true,
    );

Map<String, dynamic> _$$FestivoModelImplToJson(_$FestivoModelImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'localName': instance.localName,
      'name': instance.name,
      'counties': instance.counties,
      'isNational': instance.isNational,
    };
