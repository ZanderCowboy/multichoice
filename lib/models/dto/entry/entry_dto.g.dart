// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntryDTOImpl _$$EntryDTOImplFromJson(Map<String, dynamic> json) =>
    _$EntryDTOImpl(
      id: json['id'] as int,
      tabId: json['tabId'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$EntryDTOImplToJson(_$EntryDTOImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tabId': instance.tabId,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
