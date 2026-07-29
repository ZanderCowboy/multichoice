import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late ProfileBloc bloc;
  late MockLoginService mockLoginService;
  late MockAppStorageService mockAppStorageService;
  late MockRegistrationRepository mockRegistrationRepository;

  setUp(() {
    mockLoginService = MockLoginService();
    mockAppStorageService = MockAppStorageService();
    mockRegistrationRepository = MockRegistrationRepository();
    bloc = ProfileBloc(
      mockLoginService,
      mockAppStorageService,
      mockRegistrationRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ProfileBloc', () {
    test('initial state is correct', () {
      expect(bloc.state, ProfileState.initial());
    });

    blocTest<ProfileBloc, ProfileState>(
      'ProfileLoadStarted loads email and username from login service',
      build: () {
        when(mockLoginService.getProfileEmail()).thenAnswer(
          (_) async => 'user@example.com',
        );
        when(mockLoginService.getProfileUsername()).thenAnswer(
          (_) async => 'alice',
        );
        when(mockRegistrationRepository.hasPasswordProvider()).thenAnswer(
          (_) async => true,
        );
        return bloc;
      },
      act: (b) => b.add(const ProfileLoadStarted()),
      expect: () => [
        isA<ProfileState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ProfileState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.email, 'email', 'user@example.com')
            .having((s) => s.username, 'username', 'alice')
            .having((s) => s.hasPasswordProvider, 'hasPasswordProvider', true),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'ProfileLoadStarted falls back to lastUsedEmail when profile email is empty',
      build: () {
        when(mockLoginService.getProfileEmail()).thenAnswer((_) async => '');
        when(mockLoginService.getProfileUsername()).thenAnswer(
          (_) async => 'alice',
        );
        when(mockAppStorageService.lastUsedEmail).thenAnswer(
          (_) async => 'stored@example.com',
        );
        when(mockRegistrationRepository.hasPasswordProvider()).thenAnswer(
          (_) async => false,
        );
        return bloc;
      },
      act: (b) => b.add(const ProfileLoadStarted()),
      expect: () => [
        isA<ProfileState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ProfileState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.email, 'email', 'stored@example.com')
            .having((s) => s.username, 'username', 'alice')
            .having(
              (s) => s.hasPasswordProvider,
              'hasPasswordProvider',
              false,
            ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'ProfileLogoutRequested signs out and marks logged out',
      build: () {
        when(mockRegistrationRepository.signOut()).thenAnswer(
          (_) async => const Right(null),
        );
        return bloc;
      },
      act: (b) => b.add(const ProfileLogoutRequested()),
      expect: () => [
        isA<ProfileState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ProfileState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isLoggedOut, 'isLoggedOut', true),
      ],
      verify: (_) {
        verify(mockRegistrationRepository.signOut()).called(1);
      },
    );
  });
}
