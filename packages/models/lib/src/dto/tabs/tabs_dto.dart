import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/dto/export_dto.dart';

part 'tabs_dto.g.dart';

@CopyWith()
@JsonSerializable()
class TabsDTO {
  const TabsDTO({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.entries,
    this.isFirst,
  });

  factory TabsDTO.fromJson(Map<String, dynamic> json) =>
      _$TabsDTOFromJson(json);

  factory TabsDTO.empty() => TabsDTO(
    id: 0,
    title: '',
    subtitle: '',
    timestamp: DateTime.now(),
    entries: [],
  );

  final int id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final List<EntryDTO> entries;
  final bool? isFirst;

  Map<String, dynamic> toJson() => _$TabsDTOToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabsDTO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          subtitle == other.subtitle &&
          timestamp == other.timestamp &&
          entries == other.entries &&
          isFirst == other.isFirst;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      timestamp.hashCode ^
      entries.hashCode ^
      isFirst.hashCode;

  @override
  String toString() =>
      'TabsDTO(id: $id, title: $title, subtitle: $subtitle, timestamp: $timestamp, entries: $entries, isFirst: $isFirst)';
}
