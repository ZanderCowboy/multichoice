import 'package:core/core.dart';
import 'package:core/src/services/implementations/registration_service.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../mocks.mocks.dart';

void main() {
  late RegistrationService service;
  late MockFirebaseAuth mockAuth;
  late MockLoginService mockLogin;
  late MockAppStorageService mockAppStorage;
  late MockUserCredential mockCredential;
  late MockFirebaseUser mockUser;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockLogin = MockLoginService();
    mockAppStorage = MockAppStorageService();
    mockCredential = MockUserCredential();
    mockUser = MockFirebaseUser();
    service = RegistrationService(mockAuth, mockLogin, mockAppStorage);
  });

  group('RegistrationService signUp', () {
    test('returns Right and persists session when creation succeeds', () async {
      final dto = SignupRequestDTO(
        email: 'a@b.com',
        username: 'alice',
        password: 'Secure1!',
      );
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('uid-1');
      when(mockUser.getIdToken()).thenAnswer((_) async => 'id-token');
      when(mockUser.updateDisplayName(any)).thenAnswer((_) async {});

      final result = await service.signUp(dto);

      expect(result, Right<AuthException, AuthResultDTO>(
        AuthResultDTO(accessToken: 'id-token', userId: 'uid-1'),
      ));
      verify(mockLogin.storeLoginInfo('id-token')).called(1);
      verify(
        mockLogin.storeUserProfile(email: 'a@b.com', username: 'alice'),
      ).called(1);
      verify(mockAppStorage.setLastUsedEmail('a@b.com')).called(1);
    });

    test('does not update display name when username is empty', () async {
      final dto = SignupRequestDTO(
        email: 'a@b.com',
        username: '',
        password: 'Secure1!',
      );
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('uid-1');
      when(mockUser.getIdToken()).thenAnswer((_) async => 'id-token');

      await service.signUp(dto);

      verifyNever(mockUser.updateDisplayName(any));
      verify(
        mockLogin.storeUserProfile(email: 'a@b.com', username: null),
      ).called(1);
    });

    test('returns Left when credential has no user', () async {
      final dto = SignupRequestDTO(
        email: 'a@b.com',
        username: 'u',
        password: 'Secure1!',
      );
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(null);

      final result = await service.signUp(dto);

      expect(result, const Left<AuthException, AuthResultDTO>(
        AuthException('User creation failed'),
      ));
      verifyNever(mockLogin.storeLoginInfo(any));
    });

    test('returns Left when id token is null', () async {
      final dto = SignupRequestDTO(
        email: 'a@b.com',
        username: 'u',
        password: 'Secure1!',
      );
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => null);

      final result = await service.signUp(dto);

      expect(result, const Left<AuthException, AuthResultDTO>(
        AuthException('Failed to get authentication token'),
      ));
    });

    test('maps FirebaseAuthException to friendly message', () async {
      final dto = SignupRequestDTO(
        email: 'a@b.com',
        username: 'u',
        password: 'Secure1!',
      );
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(
        FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'raw',
        ),
      );

      final result = await service.signUp(dto);

      result.fold(
        (e) => expect(
          e.message,
          'An account already exists for this email.',
        ),
        (_) => fail('expected Left'),
      );
    });

    test('wraps unexpected errors', () async {
      final dto = SignupRequestDTO(
        email: 'a@b.com',
        username: 'u',
        password: 'Secure1!',
      );
      when(
        mockAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(Exception('boom'));

      final result = await service.signUp(dto);

      result.fold(
        (e) => expect(e.message, contains('Sign up failed:')),
        (_) => fail('expected Left'),
      );
    });
  });

  group('RegistrationService signIn', () {
    test('returns Right and stores profile using resolved Firebase email',
        () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('uid-2');
      when(mockUser.getIdToken()).thenAnswer((_) async => 'token-in');
      when(mockUser.email).thenReturn('resolved@firebase.com');
      when(mockUser.displayName).thenReturn('Display');

      final result = await service.signIn('ignored@input.com', 'pw');

      expect(result.isRight(), true);
      verify(mockAppStorage.setLastUsedEmail('resolved@firebase.com')).called(1);
      verify(
        mockLogin.storeUserProfile(
          email: 'resolved@firebase.com',
          username: 'Display',
        ),
      ).called(1);
    });

    test('uses trimmed email when Firebase user email is null but input has @',
        () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('uid');
      when(mockUser.getIdToken()).thenAnswer((_) async => 't');
      when(mockUser.email).thenReturn(null);
      when(mockUser.displayName).thenReturn(null);

      await service.signIn('  trim@me.com  ', 'pw');

      verify(mockLogin.storeUserProfile(
        email: 'trim@me.com',
        username: null,
      )).called(1);
      verify(mockAppStorage.setLastUsedEmail('trim@me.com')).called(1);
    });

    test('uses trimmed local part as username when no @ in input', () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('uid');
      when(mockUser.getIdToken()).thenAnswer((_) async => 't');
      when(mockUser.email).thenReturn(null);
      when(mockUser.displayName).thenReturn(null);

      await service.signIn('localuser', 'pw');

      verify(mockLogin.storeUserProfile(
        email: null,
        username: 'localuser',
      )).called(1);
      verifyNever(mockAppStorage.setLastUsedEmail(any));
    });

    test('returns Left when user is null', () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(null);

      final result = await service.signIn('a@b.com', 'pw');

      expect(
        result,
        const Left<AuthException, AuthResultDTO>(
          AuthException('Sign in failed'),
        ),
      );
    });

    test('returns Left when id token is null', () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => null);

      final result = await service.signIn('a@b.com', 'pw');

      expect(
        result,
        const Left<AuthException, AuthResultDTO>(
          AuthException('Failed to get authentication token'),
        ),
      );
    });

    test('maps FirebaseAuthException on sign in', () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(
        FirebaseAuthException(code: 'wrong-password', message: 'x'),
      );

      final result = await service.signIn('a@b.com', 'pw');

      result.fold(
        (e) => expect(e.message, 'Incorrect password.'),
        (_) => fail('expected Left'),
      );
    });
  });

}
