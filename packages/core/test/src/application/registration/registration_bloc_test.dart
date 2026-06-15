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
      seed: () => seededState(),
      act: (b) => b.add(
        const RegistrationEvent.fieldsChanged(
          field: RegistrationField.email,
          value: 'new@example.com',
        ),
      ),
      expect: () => [
        seededState(email: 'new@example.com'),
      ],
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
  });
}
