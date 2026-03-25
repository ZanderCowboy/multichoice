import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late RegistrationBloc bloc;
  late MockRegistrationRepository mockRepository;
  late MockPasswordService mockPasswordService;
  late MockAppStorageService mockAppStorage;

  final authSuccess = AuthResultDTO(accessToken: 't', userId: 'uid');

  RegistrationState seededState({
    String email = 'test@example.com',
    String username = 'user1',
    String password = 'Secure1!',
    bool isLoading = false,
    bool isSuccess = false,
    bool isError = false,
    String? errorMessage,
  }) =>
      RegistrationState(
        email: email,
        username: username,
        password: password,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isError: isError,
        errorMessage: errorMessage,
      );

  setUp(() {
    mockRepository = MockRegistrationRepository();
    mockPasswordService = MockPasswordService();
    mockAppStorage = MockAppStorageService();
    bloc = RegistrationBloc(
      mockRepository,
      mockPasswordService,
      mockAppStorage,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('RegistrationBloc', () {
    test('initial state is correct', () {
      expect(bloc.state, RegistrationState.initial());
    });

    blocTest<RegistrationBloc, RegistrationState>(
      'fieldsChanged updates email',
      build: () => bloc,
      act: (b) => b.add(
        const RegistrationEvent.fieldsChanged(
          field: RegistrationField.email,
          value: 'new@example.com',
        ),
      ),
      expect: () => [
        isA<RegistrationState>().having(
          (s) => s.email,
          'email',
          'new@example.com',
        ),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'fieldsChanged clears error flag',
      build: () => bloc,
      seed: () => seededState(isError: true, errorMessage: 'old'),
      act: (b) => b.add(
        const RegistrationEvent.fieldsChanged(
          field: RegistrationField.username,
          value: 'x',
        ),
      ),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.username, 'username', 'x')
            .having((s) => s.isError, 'isError', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signupClicked emits error when password validation fails',
      build: () {
        when(
          mockPasswordService.validate(any),
        ).thenReturn('Password must include: 1 number');
        return bloc;
      },
      seed: () => seededState(),
      act: (b) => b.add(const RegistrationEvent.signupClicked()),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.isError, 'isError', true)
            .having((s) => s.errorMessage, 'errorMessage', 'Password must include: 1 number'),
      ],
      verify: (_) {
        verify(mockPasswordService.validate('Secure1!')).called(1);
        verifyNever(mockRepository.signUp(any));
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signupClicked emits loading then success when sign up succeeds',
      build: () {
        when(mockPasswordService.validate(any)).thenReturn(null);
        when(
          mockRepository.signUp(any),
        ).thenAnswer((_) async => Right(authSuccess));
        return bloc;
      },
      seed: () => seededState(),
      act: (b) => b.add(const RegistrationEvent.signupClicked()),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.isError, 'isError', false),
        isA<RegistrationState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.isError, 'isError', false),
      ],
      verify: (_) {
        verify(
          mockRepository.signUp(
            const SignupRequestDTO(
              email: 'test@example.com',
              username: 'user1',
              password: 'Secure1!',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signupClicked emits loading then error when sign up fails',
      build: () {
        when(mockPasswordService.validate(any)).thenReturn(null);
        when(mockRepository.signUp(any)).thenAnswer(
          (_) async => const Left(AuthException('Email in use')),
        );
        return bloc;
      },
      seed: () => seededState(),
      act: (b) => b.add(const RegistrationEvent.signupClicked()),
      expect: () => [
        isA<RegistrationState>().having((s) => s.isLoading, 'isLoading', true),
        isA<RegistrationState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', false)
            .having((s) => s.isError, 'isError', true)
            .having((s) => s.errorMessage, 'errorMessage', 'Email in use'),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signInClicked emits error when email is empty',
      build: () => bloc,
      seed: () => seededState(email: '', password: 'x'),
      act: (b) => b.add(const RegistrationEvent.signInClicked()),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.isError, 'isError', true)
            .having((s) => s.errorMessage, 'errorMessage', 'Email is required'),
      ],
      verify: (_) {
        verifyNever(mockRepository.signIn(any, any));
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signInClicked emits error when password is empty',
      build: () => bloc,
      seed: () => seededState(password: ''),
      act: (b) => b.add(const RegistrationEvent.signInClicked()),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Password is required',
            ),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signInClicked emits loading then success when sign in succeeds',
      build: () {
        when(
          mockRepository.signIn('test@example.com', 'Secure1!'),
        ).thenAnswer((_) async => Right(authSuccess));
        return bloc;
      },
      seed: () => seededState(),
      act: (b) => b.add(const RegistrationEvent.signInClicked()),
      expect: () => [
        isA<RegistrationState>().having((s) => s.isLoading, 'isLoading', true),
        isA<RegistrationState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', true),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'googleSignInClicked emits loading then success',
      build: () {
        when(
          mockRepository.signInWithGoogle(),
        ).thenAnswer((_) async => Right(authSuccess));
        return bloc;
      },
      act: (b) => b.add(const RegistrationEvent.googleSignInClicked()),
      expect: () => [
        isA<RegistrationState>().having((s) => s.isLoading, 'isLoading', true),
        isA<RegistrationState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', true),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'cancelClicked resets to initial state',
      build: () => bloc,
      seed: () => seededState(email: 'x', isSuccess: true),
      act: (b) => b.add(const RegistrationEvent.cancelClicked()),
      expect: () => [RegistrationState.initial()],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'prefillRequested sets email from storage when present',
      build: () {
        when(mockAppStorage.lastUsedEmail).thenAnswer((_) async => 'saved@x.com');
        return bloc;
      },
      act: (b) => b.add(const RegistrationEvent.prefillRequested()),
      expect: () => [
        isA<RegistrationState>().having(
          (s) => s.email,
          'email',
          'saved@x.com',
        ),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'prefillRequested does not emit when storage has no email',
      build: () {
        when(mockAppStorage.lastUsedEmail).thenAnswer((_) async => null);
        return bloc;
      },
      act: (b) => b.add(const RegistrationEvent.prefillRequested()),
      expect: () => <RegistrationState>[],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signupFormOpened resets to initial state',
      build: () => bloc,
      seed: () => seededState(email: 'old@example.com', username: 'u', password: 'x'),
      act: (b) => b.add(const RegistrationEvent.signupFormOpened()),
      expect: () => [RegistrationState.initial()],
    );
  });
}
