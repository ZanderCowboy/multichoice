import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/dto/extensions/string.dart';

part 'tabs.g.dart';

@CopyWith()
@Collection(ignore: {'copyWith'})
@JsonSerializable()
class Tabs {
  const Tabs({
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.entryIds,
    required this.order,
  });

  factory Tabs.empty() => const Tabs(
    uuid: '',
    title: '',
    subtitle: null,
    timestamp: null,
    entryIds: null,
    order: 0,
  );

  factory Tabs.fromJson(Map<String, dynamic> json) => _$TabsFromJson(json);

  final String uuid;
  final String title;
  final String? subtitle;
  final DateTime? timestamp;
  final List<int>? entryIds;
  final int order;

  Map<String, dynamic> toJson() => _$TabsToJson(this);

  Id get id => uuid.fastHash();

  // TODO: Remove == and hashCode methods if not needed (not used in Sets/Maps)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tabs &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid &&
          title == other.title &&
          subtitle == other.subtitle &&
          timestamp == other.timestamp &&
          entryIds == other.entryIds &&
          order == other.order;

  // TODO: Remove == and hashCode methods if not needed (not used in Sets/Maps)
  @override
  int get hashCode =>
      uuid.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      timestamp.hashCode ^
      entryIds.hashCode ^
      order.hashCode;

  @override
  String toString() =>
      'Tabs(uuid: $uuid, title: $title, subtitle: $subtitle, timestamp: $timestamp, entryIds: $entryIds, order: $order)';
}
