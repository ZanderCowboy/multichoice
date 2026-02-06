import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late ChangelogBloc changelogBloc;
  late MockChangelogRepository mockChangelogRepository;

  setUp(() {
    mockChangelogRepository = MockChangelogRepository();
    changelogBloc = ChangelogBloc(mockChangelogRepository);
  });

  tearDown(() {
    changelogBloc.close();
  });

  group('ChangelogBloc', () {
    final testChangelog = Changelog(
      versions: {
        '2.0.0': ChangelogEntry(
          date: '2024-02-01',
          changes: ['Major update', 'New features'],
        ),
        '1.0.0': ChangelogEntry(
          date: '2024-01-01',
          changes: ['Initial release'],
        ),
      },
    );

    final initialState = ChangelogState.initial();

    group('fetch', () {
      blocTest<ChangelogBloc, ChangelogState>(
        'emits [isLoading: true, errorMessage: null] then [isLoading: false, changelog: Changelog, errorMessage: null] when fetch succeeds',
        seed: () => initialState,
        build: () {
          when(mockChangelogRepository.getChangelog()).thenAnswer(
            (_) async => Right(testChangelog),
          );
          return changelogBloc;
        },
        act: (bloc) => bloc.add(const ChangelogEvent.fetch()),
        expect: () => [
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', null),
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.changelog, 'changelog', testChangelog)
              .having((s) => s.errorMessage, 'errorMessage', null),
        ],
        verify: (_) {
          verify(mockChangelogRepository.getChangelog()).called(1);
        },
      );

      blocTest<ChangelogBloc, ChangelogState>(
        'emits [isLoading: true, errorMessage: null] then [isLoading: false, errorMessage: String, changelog: null] when fetch fails',
        seed: () => initialState,
        build: () {
          when(mockChangelogRepository.getChangelog()).thenAnswer(
            (_) async => Left<ChangelogException, Changelog>(
              ChangelogException('Failed to fetch changelog'),
            ),
          );
          return changelogBloc;
        },
        act: (bloc) => bloc.add(const ChangelogEvent.fetch()),
        expect: () => [
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', null),
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Failed to fetch changelog',
              )
              .having((s) => s.changelog, 'changelog', null),
        ],
        verify: (_) {
          verify(mockChangelogRepository.getChangelog()).called(1);
        },
      );

      blocTest<ChangelogBloc, ChangelogState>(
        'clears previous error message when starting new fetch',
        seed: () => ChangelogState(
          isLoading: false,
          errorMessage: 'Previous error',
          changelog: null,
        ),
        build: () {
          when(mockChangelogRepository.getChangelog()).thenAnswer(
            (_) async => Right<ChangelogException, Changelog>(testChangelog),
          );
          return changelogBloc;
        },
        act: (bloc) => bloc.add(const ChangelogEvent.fetch()),
        expect: () => [
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', null),
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.changelog, 'changelog', testChangelog)
              .having((s) => s.errorMessage, 'errorMessage', null),
        ],
      );

      blocTest<ChangelogBloc, ChangelogState>(
        'handles empty changelog correctly',
        seed: () => initialState,
        build: () {
          final emptyChangelog = Changelog(versions: {});
          when(mockChangelogRepository.getChangelog()).thenAnswer(
            (_) async => Right<ChangelogException, Changelog>(emptyChangelog),
          );
          return changelogBloc;
        },
        act: (bloc) => bloc.add(const ChangelogEvent.fetch()),
        expect: () => [
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', null),
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having(
                (s) => s.changelog?.versions.isEmpty,
                'changelog.versions.isEmpty',
                true,
              )
              .having((s) => s.errorMessage, 'errorMessage', null),
        ],
      );

      blocTest<ChangelogBloc, ChangelogState>(
        'preserves changelog state when error occurs',
        seed: () => ChangelogState(
          isLoading: false,
          errorMessage: null,
          changelog: testChangelog,
        ),
        build: () {
          when(mockChangelogRepository.getChangelog()).thenAnswer(
            (_) async => Left<ChangelogException, Changelog>(
              ChangelogException('Network error'),
            ),
          );
          return changelogBloc;
        },
        act: (bloc) => bloc.add(const ChangelogEvent.fetch()),
        expect: () => [
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', null),
          isA<ChangelogState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', 'Network error')
              .having((s) => s.changelog, 'changelog', null),
        ],
      );
    });

    group('initial state', () {
      test('initial state has correct default values', () {
        expect(changelogBloc.state.isLoading, false);
        expect(changelogBloc.state.errorMessage, null);
        expect(changelogBloc.state.changelog, null);
      });
    });
  });
}
