import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

@LazySingleton(as: IChangelogRepository)
class ChangelogRepository implements IChangelogRepository {
  ChangelogRepository(this._firebaseService);

  final IFirebaseService _firebaseService;

  @override
  Future<Either<ChangelogException, Changelog>> getChangelog() async {
    try {
      final changelog = await _firebaseService.getConfig<Changelog>(
        FirebaseConfigKeys.changelog,
        Changelog.fromJson,
      );

      if (changelog == null) {
        return Left(
          ChangelogException('Changelog not found in Remote Config'),
        );
      }

      // Sort versions (newest first) and create a new Changelog with sorted versions
      final versionEntries = changelog.versions.entries.toList()
        ..sort(
          (a, b) => _compareVersions(b.key, a.key),
        );

      // Create a new map with sorted entries (LinkedHashMap preserves insertion order)
      final sortedVersions = {
        for (final entry in versionEntries) entry.key: entry.value,
      };

      final sortedChangelog = Changelog(versions: sortedVersions);

      return Right(sortedChangelog);
    } catch (e) {
      return Left(
        ChangelogException('Failed to fetch changelog: $e'),
      );
    }
  }

  /// Compare two version strings (e.g., "1.0.0" vs "1.1.0")
  /// Returns negative if version1 < version2, positive if version1 > version2, 0 if equal
  int _compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.').map(int.tryParse).toList();
    final v2Parts = version2.split('.').map(int.tryParse).toList();

    final maxLength = v1Parts.length > v2Parts.length
        ? v1Parts.length
        : v2Parts.length;

    for (var i = 0; i < maxLength; i++) {
      final v1Part = i < v1Parts.length ? (v1Parts[i] ?? 0) : 0;
      final v2Part = i < v2Parts.length ? (v2Parts[i] ?? 0) : 0;

      if (v1Part < v2Part) return -1;
      if (v1Part > v2Part) return 1;
    }

    return 0;
  }
}
