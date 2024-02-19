// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TabsDTOImpl _$$TabsDTOImplFromJson(Map<String, dynamic> json) =>
    _$TabsDTOImpl(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$TabsDTOImplToJson(_$TabsDTOImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'timestamp': instance.timestamp.toIso8601String(),
    };
