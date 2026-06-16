import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late ResetPasswordBloc bloc;
  late MockRegistrationRepository mockRepository;
  late MockCredentialValidationService mockCredentialValidationService;

  setUp(() {
    mockRepository = MockRegistrationRepository();
    mockCredentialValidationService = MockCredentialValidationService();
    bloc = ResetPasswordBloc(
      mockRepository,
      mockCredentialValidationService,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ResetPasswordBloc', () {
    test('initial state is correct', () {
      expect(bloc.state, ResetPasswordState.initial());
    });

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'submitPressed emits error when password validation fails',
      build: () {
        when(
          mockCredentialValidationService.validatePassword(any),
        ).thenReturn('Password is required');
        return bloc;
      },
      act: (b) => b.add(
        const ResetPasswordEvent.submitPressed(
          isChangePassword: true,
          isSetPassword: false,
          oobCode: null,
        ),
      ),
      expect: () => [
        isA<ResetPasswordState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Password is required',
            ),
      ],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'submitPressed emits success when update password succeeds',
      build: () {
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
          mockCredentialValidationService.validatePasswordRequired(any),
        ).thenReturn(null);
        when(
          mockRepository.reauthenticateWithPassword(any),
        ).thenAnswer((_) async => const Right(null));
        when(
          mockRepository.updatePassword(any),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const ResetPasswordState(
        newPassword: 'ValidPass1!',
        confirmPassword: 'ValidPass1!',
        currentPassword: 'OldPass1!',
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: null,
        shouldNavigateOnSuccess: false,
      ),
      act: (b) => b.add(
        const ResetPasswordEvent.submitPressed(
          isChangePassword: true,
          isSetPassword: false,
          oobCode: null,
        ),
      ),
      expect: () => [
        isA<ResetPasswordState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ResetPasswordState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having(
              (s) => s.successMessage,
              'successMessage',
              'Password updated successfully!',
            )
            .having(
              (s) => s.shouldNavigateOnSuccess,
              'shouldNavigateOnSuccess',
              true,
            ),
      ],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'submitPressed emits success when linkPassword succeeds',
      build: () {
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
          mockRepository.linkPassword(any),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const ResetPasswordState(
        newPassword: 'ValidPass1!',
        confirmPassword: 'ValidPass1!',
        currentPassword: '',
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: null,
        shouldNavigateOnSuccess: false,
      ),
      act: (b) => b.add(
        const ResetPasswordEvent.submitPressed(
          isChangePassword: true,
          isSetPassword: true,
          oobCode: null,
        ),
      ),
      expect: () => [
        isA<ResetPasswordState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ResetPasswordState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having(
              (s) => s.successMessage,
              'successMessage',
              'Password set successfully!',
            )
            .having(
              (s) => s.shouldNavigateOnSuccess,
              'shouldNavigateOnSuccess',
              true,
            ),
      ],
      verify: (_) {
        verify(mockRepository.linkPassword('ValidPass1!')).called(1);
        verifyNever(mockRepository.reauthenticateWithPassword(any));
      },
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'submitPressed emits error when linkPassword fails',
      build: () {
        when(
          mockCredentialValidationService.validatePassword(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordConfirmation(
            password: anyNamed('password'),
            confirmation: anyNamed('confirmation'),
          ),
        ).thenReturn(null);
        when(mockRepository.linkPassword(any)).thenAnswer(
          (_) async => const Left(AuthException('Provider already linked')),
        );
        return bloc;
      },
      seed: () => const ResetPasswordState(
        newPassword: 'ValidPass1!',
        confirmPassword: 'ValidPass1!',
        currentPassword: '',
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: null,
        shouldNavigateOnSuccess: false,
      ),
      act: (b) => b.add(
        const ResetPasswordEvent.submitPressed(
          isChangePassword: true,
          isSetPassword: true,
          oobCode: null,
        ),
      ),
      expect: () => [
        isA<ResetPasswordState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ResetPasswordState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Provider already linked',
            ),
      ],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'submitPressed emits error when reauthentication fails',
      build: () {
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
          mockCredentialValidationService.validatePasswordRequired(any),
        ).thenReturn(null);
        when(mockRepository.reauthenticateWithPassword(any)).thenAnswer(
          (_) async => const Left(
            AuthException('Current password is incorrect'),
          ),
        );
        return bloc;
      },
      seed: () => const ResetPasswordState(
        newPassword: 'ValidPass1!',
        confirmPassword: 'ValidPass1!',
        currentPassword: 'WrongPass1!',
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: null,
        shouldNavigateOnSuccess: false,
      ),
      act: (b) => b.add(
        const ResetPasswordEvent.submitPressed(
          isChangePassword: true,
          isSetPassword: false,
          oobCode: null,
        ),
      ),
      expect: () => [
        isA<ResetPasswordState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ResetPasswordState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Current password is incorrect',
            ),
      ],
      verify: (_) {
        verifyNever(mockRepository.updatePassword(any));
      },
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'newPasswordChanged updates state and clears error',
      build: () => bloc,
      seed: () => const ResetPasswordState(
        newPassword: '',
        confirmPassword: '',
        currentPassword: '',
        isLoading: false,
        isError: true,
        errorMessage: 'old',
        successMessage: null,
        shouldNavigateOnSuccess: false,
      ),
      act: (b) => b.add(const ResetPasswordEvent.newPasswordChanged('x')),
      expect: () => [
        isA<ResetPasswordState>()
            .having((s) => s.newPassword, 'newPassword', 'x')
            .having((s) => s.isError, 'isError', false)
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'submitPressed emits error when confirm password does not match',
      build: () {
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
      act: (b) => b.add(
        const ResetPasswordEvent.submitPressed(
          isChangePassword: false,
          isSetPassword: false,
          oobCode: 'code',
        ),
      ),
      expect: () => [
        isA<ResetPasswordState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Passwords do not match',
            ),
      ],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'submitPressed emits error when current password is missing',
      build: () {
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
          mockCredentialValidationService.validatePasswordRequired(any),
        ).thenReturn('Password is required');
        return bloc;
      },
      seed: () => const ResetPasswordState(
        newPassword: 'ValidPass1!',
        confirmPassword: 'ValidPass1!',
        currentPassword: '',
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: null,
        shouldNavigateOnSuccess: false,
      ),
      act: (b) => b.add(
        const ResetPasswordEvent.submitPressed(
          isChangePassword: true,
          isSetPassword: false,
          oobCode: null,
        ),
      ),
      expect: () => [
        isA<ResetPasswordState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Password is required',
            ),
      ],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'submitPressed emits success when password reset with oobCode succeeds',
      build: () {
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
          mockRepository.confirmPasswordReset(
            oobCode: anyNamed('oobCode'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      seed: () => const ResetPasswordState(
        newPassword: 'ValidPass1!',
        confirmPassword: 'ValidPass1!',
        currentPassword: '',
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: null,
        shouldNavigateOnSuccess: false,
      ),
      act: (b) => b.add(
        const ResetPasswordEvent.submitPressed(
          isChangePassword: false,
          isSetPassword: false,
          oobCode: 'oob-123',
        ),
      ),
      expect: () => [
        isA<ResetPasswordState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ResetPasswordState>()
            .having(
              (s) => s.successMessage,
              'successMessage',
              'Password reset successfully!',
            )
            .having(
              (s) => s.shouldNavigateOnSuccess,
              'shouldNavigateOnSuccess',
              true,
            ),
      ],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'successConsumed clears shouldNavigateOnSuccess',
      build: () => bloc,
      seed: () => const ResetPasswordState(
        newPassword: '',
        confirmPassword: '',
        currentPassword: '',
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: 'done',
        shouldNavigateOnSuccess: true,
      ),
      act: (b) => b.add(const ResetPasswordEvent.successConsumed()),
      expect: () => [
        isA<ResetPasswordState>()
            .having(
              (s) => s.shouldNavigateOnSuccess,
              'shouldNavigateOnSuccess',
              false,
            ),
      ],
    );

    blocTest<ResetPasswordBloc, ResetPasswordState>(
      'submitPressed emits error when reset link has no oobCode',
      build: () {
        when(
          mockCredentialValidationService.validatePassword(any),
        ).thenReturn(null);
        when(
          mockCredentialValidationService.validatePasswordConfirmation(
            password: anyNamed('password'),
            confirmation: anyNamed('confirmation'),
          ),
        ).thenReturn(null);
        return bloc;
      },
      seed: () => const ResetPasswordState(
        newPassword: 'ValidPass1!',
        confirmPassword: 'ValidPass1!',
        currentPassword: '',
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: null,
        shouldNavigateOnSuccess: false,
      ),
      act: (b) => b.add(
        const ResetPasswordEvent.submitPressed(
          isChangePassword: false,
          isSetPassword: false,
          oobCode: null,
        ),
      ),
      expect: () => [
        isA<ResetPasswordState>().having((s) => s.isLoading, 'isLoading', true),
        isA<ResetPasswordState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              contains('invalid or missing'),
            ),
      ],
    );
  });
}
