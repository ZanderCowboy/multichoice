import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/dto/extensions/string.dart';

part 'entry.g.dart';

@CopyWith()
@Collection(ignore: {'copyWith'})
@JsonSerializable()
class Entry {
  const Entry({
    required this.uuid,
    required this.tabId,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  factory Entry.empty() => const Entry(
    uuid: '',
    tabId: 0,
    title: '',
    subtitle: null,
    timestamp: null,
  );

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  final String uuid;
  final int tabId;
  final String title;
  final String? subtitle;
  final DateTime? timestamp;

  Map<String, dynamic> toJson() => _$EntryToJson(this);

  Id get id => uuid.fastHash();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entry &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid &&
          tabId == other.tabId &&
          title == other.title &&
          subtitle == other.subtitle &&
          timestamp == other.timestamp;

  @override
  int get hashCode =>
      uuid.hashCode ^
      tabId.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      timestamp.hashCode;

  @override
  String toString() =>
      'Entry(uuid: $uuid, tabId: $tabId, title: $title, subtitle: $subtitle, timestamp: $timestamp)';
}
