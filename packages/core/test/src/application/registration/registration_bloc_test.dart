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
  late MockCredentialValidationService mockCredentialValidationService;
  late MockAppStorageService mockAppStorage;
  late MockLoginService mockLoginService;

  final authSuccess = AuthResultDTO(accessToken: 't', userId: 'uid');

  RegistrationState seededState({
    String email = 'test@example.com',
    String username = 'user1',
    String password = 'Secure1!',
    String confirmPassword = 'Secure1!',
    bool isLoading = false,
    bool isSuccess = false,
    bool isError = false,
    String? errorMessage,
    bool needsUsernameSetup = false,
  }) => RegistrationState(
    email: email,
    username: username,
    password: password,
    confirmPassword: confirmPassword,
    isLoading: isLoading,
    isSuccess: isSuccess,
    isError: isError,
    errorMessage: errorMessage,
    needsUsernameSetup: needsUsernameSetup,
  );

  setUp(() {
    mockRepository = MockRegistrationRepository();
    mockCredentialValidationService = MockCredentialValidationService();
    mockAppStorage = MockAppStorageService();
    mockLoginService = MockLoginService();
    bloc = RegistrationBloc(
      mockRepository,
      mockCredentialValidationService,
      mockAppStorage,
      mockLoginService,
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
      'signupClicked emits error when email validation fails',
      build: () {
        when(
          mockCredentialValidationService.validateEmail(any),
        ).thenReturn('Email is required');
        return bloc;
      },
      seed: () => seededState(email: ''),
      act: (b) => b.add(const RegistrationEvent.signupClicked()),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.isError, 'isError', true)
            .having((s) => s.errorMessage, 'errorMessage', 'Email is required'),
      ],
      verify: (_) {
        verifyNever(mockRepository.signUp(any));
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signupClicked emits error when username validation fails',
      build: () {
        when(
          mockCredentialValidationService.validateEmail(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validateUsername(any),
        ).thenReturn('Username must be at least 2 characters');
        return bloc;
      },
      seed: () => seededState(username: 'a'),
      act: (b) => b.add(const RegistrationEvent.signupClicked()),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Username must be at least 2 characters',
            ),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signupClicked emits error when password validation fails',
      build: () {
        when(
          mockCredentialValidationService.validateEmail(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validateUsername(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePassword(any),
        ).thenReturn('Password must include: 1 number');
        return bloc;
      },
      seed: () => seededState(),
      act: (b) => b.add(const RegistrationEvent.signupClicked()),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Password must include: 1 number',
            ),
      ],
      verify: (_) {
        verify(
          mockCredentialValidationService.validateEmail('test@example.com'),
        ).called(1);
        verify(
          mockCredentialValidationService.validateUsername('user1'),
        ).called(1);
        verify(
          mockCredentialValidationService.validatePassword('Secure1!'),
        ).called(1);
        verifyNever(
          mockCredentialValidationService.validatePasswordConfirmation(
            password: anyNamed('password'),
            confirmation: anyNamed('confirmation'),
          ),
        );
        verifyNever(mockRepository.signUp(any));
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signupClicked emits error when confirm password does not match',
      build: () {
        when(
          mockCredentialValidationService.validateEmail(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validateUsername(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePassword(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordConfirmation(
            password: anyNamed('password'),
            confirmation: anyNamed('confirmation'),
          ),
        ).thenReturn('Passwords do not match');
        return bloc;
      },
      seed: () => seededState(confirmPassword: 'Mismatch1!'),
      act: (b) => b.add(const RegistrationEvent.signupClicked()),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Passwords do not match',
            ),
      ],
      verify: (_) {
        verify(
          mockCredentialValidationService.validatePasswordConfirmation(
            password: 'Secure1!',
            confirmation: 'Mismatch1!',
          ),
        ).called(1);
        verifyNever(mockRepository.signUp(any));
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signupClicked emits loading then success when sign up succeeds',
      build: () {
        when(
          mockCredentialValidationService.validateEmail(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validateUsername(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePassword(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordConfirmation(
            password: anyNamed('password'),
            confirmation: anyNamed('confirmation'),
          ),
        ).thenReturn(null);
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
            .having((s) => s.isError, 'isError', false)
            .having((s) => s.needsUsernameSetup, 'needsUsernameSetup', false),
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
        when(
          mockCredentialValidationService.validateEmail(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validateUsername(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePassword(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordConfirmation(
            password: anyNamed('password'),
            confirmation: anyNamed('confirmation'),
          ),
        ).thenReturn(null);
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
      'signInClicked emits error when identifier is empty',
      build: () => bloc,
      seed: () => seededState(email: '', password: 'x'),
      setUp: () {
        when(mockCredentialValidationService.validateLoginIdentifier(any))
            .thenReturn('Email or username is required');
      },
      act: (b) => b.add(const RegistrationEvent.signInClicked()),
      expect: () => [
        isA<RegistrationState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Email or username is required',
            ),
      ],
      verify: (_) {
        verifyNever(mockLoginService.resolveEmailForLogin(any));
        verifyNever(mockRepository.signIn(any, any));
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signInClicked emits error when password is empty',
      build: () => bloc,
      seed: () => seededState(password: ''),
      setUp: () {
        when(
          mockCredentialValidationService.validateLoginIdentifier(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordRequired(any),
        ).thenReturn('Password is required');
      },
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
      'signInClicked emits error when resolveEmailForLogin returns null',
      build: () {
        when(
          mockCredentialValidationService.validateLoginIdentifier(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordRequired(any),
        ).thenReturn(null);
        when(
          mockLoginService.resolveEmailForLogin('alice'),
        ).thenAnswer((_) async => null);
        return bloc;
      },
      seed: () => seededState(email: 'alice', password: 'Secure1!'),
      act: (b) => b.add(const RegistrationEvent.signInClicked()),
      expect: () => [
        isA<RegistrationState>().having((s) => s.isLoading, 'isLoading', true),
        isA<RegistrationState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'No account found for this username.',
            ),
      ],
      verify: (_) {
        verifyNever(mockRepository.signIn(any, any));
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signInClicked resolves username to email before sign in',
      build: () {
        when(
          mockCredentialValidationService.validateLoginIdentifier(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordRequired(any),
        ).thenReturn(null);
        when(
          mockLoginService.resolveEmailForLogin('alice'),
        ).thenAnswer((_) async => 'alice@example.com');
        when(
          mockRepository.signIn('alice@example.com', 'Secure1!'),
        ).thenAnswer((_) async => Right(authSuccess));
        return bloc;
      },
      seed: () => seededState(email: 'alice', password: 'Secure1!'),
      act: (b) => b.add(const RegistrationEvent.signInClicked()),
      expect: () => [
        seededState(
          email: 'alice',
          password: 'Secure1!',
          isLoading: true,
        ),
        seededState(
          email: 'alice',
          password: 'Secure1!',
          isSuccess: true,
        ),
      ],
      verify: (_) {
        verify(mockRepository.signIn('alice@example.com', 'Secure1!')).called(1);
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signInClicked emits loading then success when sign in succeeds',
      build: () {
        when(
          mockCredentialValidationService.validateLoginIdentifier(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordRequired(any),
        ).thenReturn(null);
        when(
          mockLoginService.resolveEmailForLogin('test@example.com'),
        ).thenAnswer((_) async => 'test@example.com');
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
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.needsUsernameSetup, 'needsUsernameSetup', false),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'signInClicked emits loading then error when sign in fails',
      build: () {
        when(
          mockCredentialValidationService.validateLoginIdentifier(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordRequired(any),
        ).thenReturn(null);
        when(
          mockLoginService.resolveEmailForLogin('test@example.com'),
        ).thenAnswer((_) async => 'test@example.com');
        when(mockRepository.signIn('test@example.com', 'Secure1!')).thenAnswer(
          (_) async => const Left(AuthException('Invalid credentials')),
        );
        return bloc;
      },
      seed: () => seededState(),
      act: (b) => b.add(const RegistrationEvent.signInClicked()),
      expect: () => [
        isA<RegistrationState>().having((s) => s.isLoading, 'isLoading', true),
        isA<RegistrationState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', false)
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Invalid credentials',
            ),
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
            .having((s) => s.isSuccess, 'isSuccess', true)
            .having((s) => s.needsUsernameSetup, 'needsUsernameSetup', false),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'googleSignInClicked sets needsUsernameSetup from auth result',
      build: () {
        when(mockRepository.signInWithGoogle()).thenAnswer(
          (_) async => const Right(
            AuthResultDTO(
              accessToken: 't',
              userId: 'uid',
              needsUsernameSetup: true,
            ),
          ),
        );
        return bloc;
      },
      seed: () => seededState(),
      act: (b) => b.add(const RegistrationEvent.googleSignInClicked()),
      expect: () => [
        seededState(isLoading: true),
        seededState(isSuccess: true, needsUsernameSetup: true),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'googleSignInClicked emits loading then error when sign in fails',
      build: () {
        when(mockRepository.signInWithGoogle()).thenAnswer(
          (_) async => const Left(AuthException('Google sign-in cancelled')),
        );
        return bloc;
      },
      act: (b) => b.add(const RegistrationEvent.googleSignInClicked()),
      expect: () => [
        isA<RegistrationState>().having((s) => s.isLoading, 'isLoading', true),
        isA<RegistrationState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isSuccess, 'isSuccess', false)
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Google sign-in cancelled',
            )
            .having((s) => s.needsUsernameSetup, 'needsUsernameSetup', false),
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
        when(
          mockAppStorage.lastUsedEmail,
        ).thenAnswer((_) async => 'saved@x.com');
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
      seed: () =>
          seededState(email: 'old@example.com', username: 'u', password: 'x'),
      act: (b) => b.add(const RegistrationEvent.signupFormOpened()),
      expect: () => [RegistrationState.initial()],
    );
  });
}
