import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'changelog_entry.g.dart';

@CopyWith()
@JsonSerializable()
class ChangelogEntry extends Equatable {
  const ChangelogEntry({
    required this.date,
    required this.changes,
  });

  factory ChangelogEntry.fromJson(Map<String, dynamic> json) =>
      _$ChangelogEntryFromJson(json);

  final String date;
  final List<String> changes;

  Map<String, dynamic> toJson() => _$ChangelogEntryToJson(this);

  @override
  String toString() => 'ChangelogEntry(date: $date, changes: $changes)';

  @override
  List<Object?> get props => [
    date,
    changes,
  ];
}
