import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:models/src/models/changelog/changelog_entry.dart';

@CopyWith()
class Changelog extends Equatable {
  const Changelog({
    required this.versions,
  });

  factory Changelog.fromJson(Map<String, dynamic> json) =>
      _$ChangelogFromJson(json);

  final Map<String, ChangelogEntry> versions;

  Map<String, dynamic> toJson() => _$ChangelogToJson(this);

  @override
  List<Object?> get props => [
    versions,
  ];
}
