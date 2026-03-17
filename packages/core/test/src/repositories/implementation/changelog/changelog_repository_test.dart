import 'package:core/core.dart';
import 'package:core/src/repositories/implementation/changelog/changelog_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late ChangelogRepository repository;
  late MockFirebaseService mockFirebaseService;

  setUp(() {
    mockFirebaseService = MockFirebaseService();
    repository = ChangelogRepository(mockFirebaseService);
  });

  group('ChangelogRepository', () {
    group('getChangelog', () {
      test('returns Right with sorted changelog when fetch succeeds', () async {
        // Arrange
        final unsortedChangelog = Changelog(
          versions: {
            '1.0.0': ChangelogEntry(
              date: '2024-01-01',
              changes: ['Initial release'],
            ),
            '2.0.0': ChangelogEntry(
              date: '2024-02-01',
              changes: ['Major update'],
            ),
            '1.5.0': ChangelogEntry(
              date: '2024-01-15',
              changes: ['Minor update'],
            ),
          },
        );

        when(
          mockFirebaseService.getConfig<Changelog>(
            FirebaseConfigKeys.changelog,
            any,
          ),
        ).thenAnswer((_) async => unsortedChangelog);

        // Act
        final result = await repository.getChangelog();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected Right but got Left: $error'),
          (changelog) {
            expect(changelog.versions.length, 3);
            // Check that versions are sorted (newest first)
            final versionKeys = changelog.versions.keys.toList();
            expect(versionKeys[0], '2.0.0');
            expect(versionKeys[1], '1.5.0');
            expect(versionKeys[2], '1.0.0');
          },
        );
      });

      test(
        'returns Left with ChangelogException when changelog is null',
        () async {
          // Arrange
          when(
            mockFirebaseService.getConfig<Changelog>(
              FirebaseConfigKeys.changelog,
              any,
            ),
          ).thenAnswer((_) async => null);

          // Act
          final result = await repository.getChangelog();

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (error) {
              expect(error, isA<ChangelogException>());
              expect(error.message, 'Changelog not found in Remote Config');
            },
            (_) => fail('Expected Left but got Right'),
          );
        },
      );

      test(
        'returns Left with ChangelogException when FirebaseService throws',
        () async {
          // Arrange
          when(
            mockFirebaseService.getConfig<Changelog>(
              FirebaseConfigKeys.changelog,
              any,
            ),
          ).thenThrow(Exception('Firebase error'));

          // Act
          final result = await repository.getChangelog();

          // Assert
          expect(result.isLeft(), true);
          result.fold(
            (error) {
              expect(error, isA<ChangelogException>());
              expect(error.message, contains('Failed to fetch changelog'));
            },
            (_) => fail('Expected Left but got Right'),
          );
        },
      );

      test('sorts versions correctly with different version formats', () async {
        // Arrange
        final unsortedChangelog = Changelog(
          versions: {
            '1.0.0': ChangelogEntry(
              date: '2024-01-01',
              changes: ['Version 1.0.0'],
            ),
            '10.0.0': ChangelogEntry(
              date: '2024-10-01',
              changes: ['Version 10.0.0'],
            ),
            '2.0.0': ChangelogEntry(
              date: '2024-02-01',
              changes: ['Version 2.0.0'],
            ),
            '1.0.1': ChangelogEntry(
              date: '2024-01-02',
              changes: ['Version 1.0.1'],
            ),
          },
        );

        when(
          mockFirebaseService.getConfig<Changelog>(
            FirebaseConfigKeys.changelog,
            any,
          ),
        ).thenAnswer((_) async => unsortedChangelog);

        // Act
        final result = await repository.getChangelog();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected Right but got Left: $error'),
          (changelog) {
            final versionKeys = changelog.versions.keys.toList();
            expect(versionKeys[0], '10.0.0');
            expect(versionKeys[1], '2.0.0');
            expect(versionKeys[2], '1.0.1');
            expect(versionKeys[3], '1.0.0');
          },
        );
      });

      test('handles empty changelog correctly', () async {
        // Arrange
        final emptyChangelog = Changelog(versions: {});

        when(
          mockFirebaseService.getConfig<Changelog>(
            FirebaseConfigKeys.changelog,
            any,
          ),
        ).thenAnswer((_) async => emptyChangelog);

        // Act
        final result = await repository.getChangelog();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected Right but got Left: $error'),
          (changelog) {
            expect(changelog.versions.isEmpty, true);
          },
        );
      });

      test('handles single version correctly', () async {
        // Arrange
        final singleVersionChangelog = Changelog(
          versions: {
            '1.0.0': ChangelogEntry(
              date: '2024-01-01',
              changes: ['Initial release'],
            ),
          },
        );

        when(
          mockFirebaseService.getConfig<Changelog>(
            FirebaseConfigKeys.changelog,
            any,
          ),
        ).thenAnswer((_) async => singleVersionChangelog);

        // Act
        final result = await repository.getChangelog();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (error) => fail('Expected Right but got Left: $error'),
          (changelog) {
            expect(changelog.versions.length, 1);
            expect(changelog.versions.containsKey('1.0.0'), true);
          },
        );
      });
    });
  });
}
