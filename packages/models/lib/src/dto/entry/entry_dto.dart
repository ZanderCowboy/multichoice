import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry_dto.g.dart';

@CopyWith()
@JsonSerializable()
class EntryDTO {
  const EntryDTO({
    required this.id,
    required this.tabId,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  final int id;
  final int tabId;
  final String title;
  final String subtitle;
  final DateTime timestamp;

  factory EntryDTO.empty() => EntryDTO(
    id: 0,
    tabId: 0,
    title: '',
    subtitle: '',
    timestamp: DateTime.now(),
  );

  factory EntryDTO.fromJson(Map<String, dynamic> json) =>
      _$EntryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$EntryDTOToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryDTO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          tabId == other.tabId &&
          title == other.title &&
          subtitle == other.subtitle &&
          timestamp == other.timestamp;

  @override
  int get hashCode =>
      id.hashCode ^
      tabId.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      timestamp.hashCode;

  @override
  String toString() =>
      'EntryDTO(id: $id, tabId: $tabId, title: $title, subtitle: $subtitle, timestamp: $timestamp)';
}
