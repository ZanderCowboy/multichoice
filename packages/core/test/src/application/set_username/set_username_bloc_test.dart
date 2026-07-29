import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late SetUsernameBloc bloc;
  late MockRegistrationRepository mockRepository;
  late MockCredentialValidationService mockCredentialValidationService;

  setUp(() {
    mockRepository = MockRegistrationRepository();
    mockCredentialValidationService = MockCredentialValidationService();
    bloc = SetUsernameBloc(
      mockRepository,
      mockCredentialValidationService,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('SetUsernameBloc', () {
    test('initial state is correct', () {
      expect(bloc.state, SetUsernameState.initial());
    });

    blocTest<SetUsernameBloc, SetUsernameState>(
      'usernameChanged updates username and clears error',
      build: () => bloc,
      seed: () => const SetUsernameState(
        username: '',
        isLoading: false,
        isSuccess: false,
        isError: true,
        errorMessage: 'old error',
      ),
      act: (b) => b.add(const SetUsernameEvent.usernameChanged('newuser')),
      expect: () => [
        isA<SetUsernameState>()
            .having((s) => s.username, 'username', 'newuser')
            .having((s) => s.isError, 'isError', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<SetUsernameBloc, SetUsernameState>(
      'submitted emits error when username validation fails',
      build: () {
        when(
          mockCredentialValidationService.validateUsername(any),
        ).thenReturn('Username is required');
        return bloc;
      },
      act: (b) => b.add(const SetUsernameEvent.submitted()),
      expect: () => [
        isA<SetUsernameState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Username is required',
            ),
      ],
      verify: (_) {
        verifyNever(mockRepository.setUsername(any));
      },
    );

    blocTest<SetUsernameBloc, SetUsernameState>(
      'submitted emits loading then success when setUsername succeeds',
      build: () {
        when(
          mockCredentialValidationService.validateUsername(any),
        ).thenReturn(null);
        when(
          mockRepository.setUsername(any),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const SetUsernameState(
        username: 'cooluser',
        isLoading: false,
        isSuccess: false,
        isError: false,
        errorMessage: null,
      ),
      act: (b) => b.add(const SetUsernameEvent.submitted()),
      expect: () => [
        isA<SetUsernameState>().having((s) => s.isLoading, 'isLoading', true),
        isA<SetUsernameState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.isError, 'isError', false),
      ],
      verify: (_) {
        verify(mockRepository.setUsername('cooluser')).called(1);
      },
    );

    blocTest<SetUsernameBloc, SetUsernameState>(
      'submitted emits loading then error when setUsername fails',
      build: () {
        when(
          mockCredentialValidationService.validateUsername(any),
        ).thenReturn(null);
        when(mockRepository.setUsername(any)).thenAnswer(
          (_) async => const Left(AuthException('Username already taken')),
        );
        return bloc;
      },
      seed: () => const SetUsernameState(
        username: 'taken',
        isLoading: false,
        isSuccess: false,
        isError: false,
        errorMessage: null,
      ),
      act: (b) => b.add(const SetUsernameEvent.submitted()),
      expect: () => [
        isA<SetUsernameState>().having((s) => s.isLoading, 'isLoading', true),
        isA<SetUsernameState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', false)
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Username already taken',
            ),
      ],
    );
  });
}
