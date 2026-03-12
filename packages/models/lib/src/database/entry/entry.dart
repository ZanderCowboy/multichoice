import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/dto/extensions/string.dart';

part 'entry.g.dart';

@CopyWith()
@Collection(ignore: {'copyWith', 'props'})
@JsonSerializable()
class Entry extends Equatable {
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
  List<Object?> get props => [
    uuid,
    tabId,
    title,
    subtitle,
    timestamp,
  ];
}
