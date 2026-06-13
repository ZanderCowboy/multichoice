import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late ProfileBloc bloc;
  late MockLoginService mockLoginService;
  late MockAppStorageService mockAppStorageService;

  setUp(() {
    mockLoginService = MockLoginService();
    mockAppStorageService = MockAppStorageService();
    bloc = ProfileBloc(mockLoginService, mockAppStorageService);
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
        return bloc;
      },
      act: (b) => b.add(const ProfileLoadStarted()),
      expect: () => [
        isA<ProfileState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ProfileState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.email, 'email', 'user@example.com')
            .having((s) => s.username, 'username', 'alice'),
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
        return bloc;
      },
      act: (b) => b.add(const ProfileLoadStarted()),
      expect: () => [
        isA<ProfileState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ProfileState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.email, 'email', 'stored@example.com')
            .having((s) => s.username, 'username', 'alice'),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'ProfileLogoutRequested clears session and marks logged out',
      build: () {
        when(mockLoginService.deleteLoginInfo()).thenAnswer((_) async {});
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
        verify(mockLoginService.deleteLoginInfo()).called(1);
      },
    );
  });
}
