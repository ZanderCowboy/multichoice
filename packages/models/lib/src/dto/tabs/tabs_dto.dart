import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/dto/export_dto.dart';

part 'tabs_dto.g.dart';

@CopyWith()
@JsonSerializable()
class TabsDTO extends Equatable {
  const TabsDTO({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.entries,
    required this.order,
    this.isFirst,
  });

  factory TabsDTO.fromJson(Map<String, dynamic> json) =>
      _$TabsDTOFromJson(json);

  factory TabsDTO.empty() => TabsDTO(
    id: 0,
    title: '',
    subtitle: '',
    timestamp: DateTime.now(),
    entries: const [],
    order: 0,
  );

  final int id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final List<EntryDTO> entries;
  @JsonKey(defaultValue: 0)
  final int order;
  final bool? isFirst;

  Map<String, dynamic> toJson() => _$TabsDTOToJson(this);

  @override
  String toString() =>
      'TabsDTO(id: $id, title: $title, subtitle: $subtitle, timestamp: $timestamp, entries: $entries, order: $order, isFirst: $isFirst)';

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    timestamp,
    entries,
    order,
    isFirst,
  ];
}
