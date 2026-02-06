import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:models/src/models/changelog/changelog_entry.dart';

@CopyWith()
class Changelog {
  const Changelog({
    required this.versions,
  });

  factory Changelog.fromJson(Map<String, dynamic> json) {
    final versions = <String, ChangelogEntry>{};
    json.forEach((version, entryData) {
      if (entryData is Map<String, dynamic>) {
        versions[version] = ChangelogEntry.fromJson(entryData);
      }
    });
    return Changelog(versions: versions);
  }

  final Map<String, ChangelogEntry> versions;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    versions.forEach((version, entry) {
      json[version] = entry.toJson();
    });
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Changelog &&
          runtimeType == other.runtimeType &&
          versions == other.versions;

  @override
  int get hashCode => versions.hashCode;

  @override
  String toString() => 'Changelog(versions: $versions)';
}
