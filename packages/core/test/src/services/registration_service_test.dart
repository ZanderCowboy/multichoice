import 'package:core/core.dart';
import 'package:core/src/services/implementations/registration_service.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../mocks.mocks.dart';

class _FakeUserInfo implements UserInfo {
  _FakeUserInfo(this.providerId);

  @override
  final String providerId;

  @override
  String? get displayName => null;

  @override
  String? get email => null;

  @override
  String? get phoneNumber => null;

  @override
  String? get photoURL => null;

  @override
  String get uid => 'uid';
}

void main() {
  late RegistrationService service;
  late MockFirebaseAuth mockAuth;
  late MockLoginService mockLogin;
  late MockAppStorageService mockAppStorage;
  late MockUserCredential mockCredential;
  late MockFirebaseUser mockUser;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockGoogleAccount;
  late MockGoogleSignInAuthentication mockGoogleAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockLogin = MockLoginService();
    mockAppStorage = MockAppStorageService();
    mockCredential = MockUserCredential();
    mockUser = MockFirebaseUser();
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleAccount = MockGoogleSignInAccount();
    mockGoogleAuth = MockGoogleSignInAuthentication();
    service = RegistrationService(
      mockAuth,
      mockLogin,
      mockAppStorage,
      mockGoogleSignIn,
    );

    // Ensure any "new user" flag writes don't break async tests.
    when(mockAppStorage.setIsExistingUser(any)).thenAnswer((_) async {});
    when(
      mockAppStorage.setHasPreviouslySignedIn(true),
    ).thenAnswer((_) async {});
    when(
      mockAppStorage.setHasPreviouslySignedIn(false),
    ).thenAnswer((_) async {});
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

      expect(
        result,
        Right<AuthException, AuthResultDTO>(
          AuthResultDTO(accessToken: 'id-token', userId: 'uid-1'),
        ),
      );
      verify(mockLogin.storeLoginInfo('id-token')).called(1);
      verify(
        mockLogin.storeUserProfile(email: 'a@b.com', username: 'alice'),
      ).called(1);
      verify(mockLogin.storeUsernameEmailMapping('alice', 'a@b.com')).called(1);
      verify(mockAppStorage.setIsExistingUser(true)).called(1);
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
      verify(mockAppStorage.setIsExistingUser(true)).called(1);
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

      expect(
        result,
        const Left<AuthException, AuthResultDTO>(
          AuthException.userCreationFailed(),
        ),
      );
      verifyNever(mockLogin.storeLoginInfo(any));
      verifyNever(mockAppStorage.setIsExistingUser(any));
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

      expect(
        result,
        const Left<AuthException, AuthResultDTO>(
          AuthException.tokenUnavailable(),
        ),
      );
      verifyNever(mockAppStorage.setIsExistingUser(any));
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

    test('maps unknown Firebase code using message when present', () async {
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
          code: 'custom-code',
          message: 'Server said no',
        ),
      );

      final result = await service.signUp(dto);

      result.fold(
        (e) => expect(e.message, 'Server said no'),
        (_) => fail('expected Left'),
      );
    });

    test(
      'maps unknown Firebase code using code when message is null',
      () async {
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
            code: 'custom-code',
            message: null,
          ),
        );

        final result = await service.signUp(dto);

        result.fold(
          (e) => expect(e.message, 'custom-code'),
          (_) => fail('expected Left'),
        );
      },
    );
  });

  group('RegistrationService signIn', () {
    test(
      'returns Right and stores profile using resolved Firebase email',
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
        verify(
          mockAppStorage.setLastUsedEmail('resolved@firebase.com'),
        ).called(1);
        verify(
          mockLogin.storeUserProfile(
            email: 'resolved@firebase.com',
            username: 'Display',
          ),
        ).called(1);
        verify(
          mockLogin.storeUsernameEmailMapping('Display', 'resolved@firebase.com'),
        ).called(1);
        verify(mockAppStorage.setIsExistingUser(true)).called(1);
      },
    );

    test(
      'uses trimmed email when Firebase user email is null but input has @',
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

        verify(
          mockLogin.storeUserProfile(
            email: 'trim@me.com',
            username: null,
          ),
        ).called(1);
        verify(mockAppStorage.setLastUsedEmail('trim@me.com')).called(1);
        verify(mockAppStorage.setIsExistingUser(true)).called(1);
      },
    );

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

      verify(
        mockLogin.storeUserProfile(
          email: null,
          username: 'localuser',
        ),
      ).called(1);
      verifyNever(mockAppStorage.setLastUsedEmail(any));
      verify(mockAppStorage.setIsExistingUser(true)).called(1);
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
          AuthException.signInFailed(),
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
          AuthException.tokenUnavailable(),
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

    test('wraps unexpected errors on sign in', () async {
      when(
        mockAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(Exception('network'));

      final result = await service.signIn('a@b.com', 'pw');

      result.fold(
        (e) => expect(e.message, contains('Sign in failed:')),
        (_) => fail('expected Left'),
      );
    });
  });

  group('RegistrationService signInWithGoogle', () {
    test('returns cancelled when user aborts account picker', () async {
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final result = await service.signInWithGoogle();

      expect(
        result,
        const Left<AuthException, AuthResultDTO>(
          AuthException.signInCancelled(),
        ),
      );
      verifyNever(mockLogin.storeLoginInfo(any));
    });

    test('returns googleSignInFailed when signIn throws', () async {
      when(mockGoogleSignIn.signIn()).thenThrow(Exception('plugin'));

      final result = await service.signInWithGoogle();

      result.fold(
        (e) => expect(e.message, contains('Google sign-in failed:')),
        (_) => fail('expected Left'),
      );
    });

    test('completes local session when Google tokens are missing', () async {
      when(
        mockGoogleSignIn.signIn(),
      ).thenAnswer((_) async => mockGoogleAccount);
      when(
        mockGoogleAccount.authentication,
      ).thenAnswer((_) async => mockGoogleAuth);
      when(mockGoogleAuth.idToken).thenReturn(null);
      when(mockGoogleAuth.accessToken).thenReturn(null);
      when(mockGoogleAccount.id).thenReturn('acc-id');
      when(mockGoogleAccount.email).thenReturn('g@mail.com');
      when(mockGoogleAccount.displayName).thenReturn('G User');
      when(mockLogin.isUsernameConfirmed(any)).thenAnswer((_) async => false);
      when(mockLogin.storeLoginInfo(any)).thenAnswer((_) async {});
      when(
        mockLogin.storeUserProfile(
          email: anyNamed('email'),
          username: anyNamed('username'),
        ),
      ).thenAnswer((_) async {});
      when(mockAppStorage.setLastUsedEmail(any)).thenAnswer((_) async {});

      final result = await service.signInWithGoogle();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('expected Right'),
        (r) {
          expect(r.accessToken, 'google_local_acc-id');
          expect(r.userId, 'acc-id');
          expect(r.needsUsernameSetup, true);
        },
      );
      verify(mockLogin.storeLoginInfo('google_local_acc-id')).called(1);
      verify(
        mockLogin.storeUserProfile(
          email: 'g@mail.com',
        ),
      ).called(1);
      verify(mockAppStorage.setLastUsedEmail('g@mail.com')).called(1);
      verify(mockAppStorage.setIsExistingUser(true)).called(1);
    });

    test(
      'local session derives username from email local part when display empty',
      () async {
        when(
          mockGoogleSignIn.signIn(),
        ).thenAnswer((_) async => mockGoogleAccount);
        when(
          mockGoogleAccount.authentication,
        ).thenAnswer((_) async => mockGoogleAuth);
        when(mockGoogleAuth.idToken).thenReturn(null);
        when(mockGoogleAuth.accessToken).thenReturn(null);
        when(mockGoogleAccount.id).thenReturn('id');
        when(mockGoogleAccount.email).thenReturn('person@example.com');
        when(mockGoogleAccount.displayName).thenReturn('');
        when(mockLogin.isUsernameConfirmed(any)).thenAnswer((_) async => false);
        when(mockLogin.storeLoginInfo(any)).thenAnswer((_) async {});
        when(
          mockLogin.storeUserProfile(
            email: anyNamed('email'),
            username: anyNamed('username'),
          ),
        ).thenAnswer((_) async {});

        await service.signInWithGoogle();

        verify(
          mockLogin.storeUserProfile(
            email: 'person@example.com',
          ),
        ).called(1);
      },
    );

    test('signs in via Firebase when Google tokens are present', () async {
      when(
        mockGoogleSignIn.signIn(),
      ).thenAnswer((_) async => mockGoogleAccount);
      when(
        mockGoogleAccount.authentication,
      ).thenAnswer((_) async => mockGoogleAuth);
      when(mockGoogleAuth.idToken).thenReturn('gid');
      when(mockGoogleAuth.accessToken).thenReturn('gaccess');
      when(mockGoogleAccount.email).thenReturn('picker@mail.com');
      when(mockGoogleAccount.displayName).thenReturn('Picker');
      when(
        mockAuth.signInWithCredential(any),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('fb-uid');
      when(mockUser.getIdToken()).thenAnswer((_) async => 'firebase-token');
      when(mockUser.email).thenReturn('firebase@mail.com');
      when(mockUser.displayName).thenReturn('Firebase Name');
      when(mockLogin.isUsernameConfirmed('fb-uid')).thenAnswer((_) async => false);
      when(mockLogin.storeLoginInfo(any)).thenAnswer((_) async {});
      when(
        mockLogin.storeUserProfile(
          email: anyNamed('email'),
          username: anyNamed('username'),
        ),
      ).thenAnswer((_) async {});
      when(mockAppStorage.setLastUsedEmail(any)).thenAnswer((_) async {});

      final result = await service.signInWithGoogle();

      expect(result.isRight(), true);
      verify(mockLogin.storeLoginInfo('firebase-token')).called(1);
      verify(
        mockLogin.storeUserProfile(
          email: 'firebase@mail.com',
        ),
      ).called(1);
      verify(mockAppStorage.setLastUsedEmail('firebase@mail.com')).called(1);
      verify(mockAppStorage.setIsExistingUser(true)).called(1);
    });

    test(
      'uses account display name when Firebase user display name is empty',
      () async {
        when(
          mockGoogleSignIn.signIn(),
        ).thenAnswer((_) async => mockGoogleAccount);
        when(
          mockGoogleAccount.authentication,
        ).thenAnswer((_) async => mockGoogleAuth);
        when(mockGoogleAuth.idToken).thenReturn('gid');
        when(mockGoogleAuth.accessToken).thenReturn('gaccess');
        when(mockGoogleAccount.email).thenReturn('acc@mail.com');
        when(mockGoogleAccount.displayName).thenReturn('From Google');
        when(
          mockAuth.signInWithCredential(any),
        ).thenAnswer((_) async => mockCredential);
        when(mockCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('fb-uid');
        when(mockUser.getIdToken()).thenAnswer((_) async => 't');
        when(mockUser.email).thenReturn('user@mail.com');
        when(mockUser.displayName).thenReturn('Saved Username');
        when(mockLogin.isUsernameConfirmed('fb-uid')).thenAnswer((_) async => true);
        when(mockLogin.storeLoginInfo(any)).thenAnswer((_) async {});
        when(
          mockLogin.storeUserProfile(
            email: anyNamed('email'),
            username: anyNamed('username'),
          ),
        ).thenAnswer((_) async {});
        when(mockAppStorage.setLastUsedEmail(any)).thenAnswer((_) async {});

        await service.signInWithGoogle();

        verify(
          mockLogin.storeUserProfile(
            email: 'user@mail.com',
            username: 'Saved Username',
          ),
        ).called(1);
      },
    );

    test(
      'returns signInFailed when Firebase user is null after credential',
      () async {
        when(
          mockGoogleSignIn.signIn(),
        ).thenAnswer((_) async => mockGoogleAccount);
        when(
          mockGoogleAccount.authentication,
        ).thenAnswer((_) async => mockGoogleAuth);
        when(mockGoogleAuth.idToken).thenReturn('a');
        when(mockGoogleAuth.accessToken).thenReturn('b');
        when(
          mockAuth.signInWithCredential(any),
        ).thenAnswer((_) async => mockCredential);
        when(mockCredential.user).thenReturn(null);

        final result = await service.signInWithGoogle();

        expect(
          result,
          const Left<AuthException, AuthResultDTO>(
            AuthException.signInFailed(),
          ),
        );
      },
    );

    test('returns tokenUnavailable when Firebase id token is null', () async {
      when(
        mockGoogleSignIn.signIn(),
      ).thenAnswer((_) async => mockGoogleAccount);
      when(
        mockGoogleAccount.authentication,
      ).thenAnswer((_) async => mockGoogleAuth);
      when(mockGoogleAuth.idToken).thenReturn('a');
      when(mockGoogleAuth.accessToken).thenReturn('b');
      when(
        mockAuth.signInWithCredential(any),
      ).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.getIdToken()).thenAnswer((_) async => null);

      final result = await service.signInWithGoogle();

      expect(
        result,
        const Left<AuthException, AuthResultDTO>(
          AuthException.tokenUnavailable(),
        ),
      );
    });

    test(
      'falls back to local session when signInWithCredential fails',
      () async {
        when(
          mockGoogleSignIn.signIn(),
        ).thenAnswer((_) async => mockGoogleAccount);
        when(
          mockGoogleAccount.authentication,
        ).thenAnswer((_) async => mockGoogleAuth);
        when(mockGoogleAuth.idToken).thenReturn('a');
        when(mockGoogleAuth.accessToken).thenReturn('b');
        when(
          mockAuth.signInWithCredential(any),
        ).thenThrow(Exception('firebase'));
        when(mockGoogleAccount.id).thenReturn('fallback-id');
        when(mockGoogleAccount.email).thenReturn('fb@mail.com');
        when(mockGoogleAccount.displayName).thenReturn('Fb');
        when(mockLogin.isUsernameConfirmed(any)).thenAnswer((_) async => false);
        when(mockLogin.storeLoginInfo(any)).thenAnswer((_) async {});
        when(
          mockLogin.storeUserProfile(
            email: anyNamed('email'),
            username: anyNamed('username'),
          ),
        ).thenAnswer((_) async {});
        when(mockAppStorage.setLastUsedEmail(any)).thenAnswer((_) async {});

        final result = await service.signInWithGoogle();

        expect(result.isRight(), true);
        verify(mockLogin.storeLoginInfo('google_local_fallback-id')).called(1);
      },
    );
  });

  group('RegistrationService setUsername', () {
    test('returns Left when username is empty', () async {
      final result = await service.setUsername('   ');

      expect(
        result,
        const Left<AuthException, void>(
          AuthException('Username is required'),
        ),
      );
    });

    test('updates display name and persists profile for signed-in user', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('uid-1');
      when(mockUser.email).thenReturn('user@example.com');
      when(mockUser.updateDisplayName('alice')).thenAnswer((_) async {});
      when(mockLogin.markUsernameConfirmed('uid-1')).thenAnswer((_) async {});
      when(
        mockLogin.storeUserProfile(
          email: anyNamed('email'),
          username: anyNamed('username'),
        ),
      ).thenAnswer((_) async {});
      when(
        mockLogin.storeUsernameEmailMapping('alice', 'user@example.com'),
      ).thenAnswer((_) async {});

      final result = await service.setUsername('alice');

      expect(result, const Right<AuthException, void>(null));
      verify(mockUser.updateDisplayName('alice')).called(1);
      verify(mockLogin.markUsernameConfirmed('uid-1')).called(1);
    });

    test('uses google local token when firebase user is absent', () async {
      when(mockAuth.currentUser).thenReturn(null);
      when(mockLogin.getAccessToken())
          .thenAnswer((_) async => 'google_local_acc-id');
      when(mockLogin.getProfileEmail())
          .thenAnswer((_) async => 'g@mail.com');
      when(mockLogin.markUsernameConfirmed('acc-id')).thenAnswer((_) async {});
      when(
        mockLogin.storeUserProfile(
          email: anyNamed('email'),
          username: anyNamed('username'),
        ),
      ).thenAnswer((_) async {});
      when(
        mockLogin.storeUsernameEmailMapping('bob', 'g@mail.com'),
      ).thenAnswer((_) async {});

      final result = await service.setUsername('bob');

      expect(result, const Right<AuthException, void>(null));
      verify(mockLogin.markUsernameConfirmed('acc-id')).called(1);
      verifyNever(mockUser.updateDisplayName(any));
    });
  });

  group('RegistrationService hasPasswordProvider', () {
    test('returns false when no signed-in user', () async {
      when(mockAuth.currentUser).thenReturn(null);

      expect(await service.hasPasswordProvider(), false);
    });

    test('returns true when password provider is linked', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.providerData).thenReturn([
        _FakeUserInfo('password'),
      ]);

      expect(await service.hasPasswordProvider(), true);
    });

    test('returns false when only social providers are linked', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.providerData).thenReturn([
        _FakeUserInfo('google.com'),
      ]);

      expect(await service.hasPasswordProvider(), false);
    });
  });

  group('RegistrationService linkPassword', () {
    test('links email/password credential for signed-in user', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.email).thenReturn('user@example.com');
      when(mockUser.linkWithCredential(any)).thenAnswer((_) async => mockCredential);

      final result = await service.linkPassword('ValidPass1!');

      expect(result, const Right<AuthException, void>(null));
      verify(mockUser.linkWithCredential(any)).called(1);
    });

    test('returns Left when no signed-in user', () async {
      when(mockAuth.currentUser).thenReturn(null);

      final result = await service.linkPassword('ValidPass1!');

      expect(
        result,
        const Left<AuthException, void>(AuthException.noSignedInUser()),
      );
    });

    test('returns Left when user has no email', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.email).thenReturn(null);

      final result = await service.linkPassword('ValidPass1!');

      result.fold(
        (e) => expect(
          e.message,
          'No email on this account. Cannot set a password.',
        ),
        (_) => fail('expected Left'),
      );
    });
  });

  group('RegistrationService reauthenticateWithPassword', () {
    test('reauthenticates signed-in user', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.email).thenReturn('user@example.com');
      when(
        mockUser.reauthenticateWithCredential(any),
      ).thenAnswer((_) async => mockCredential);

      final result = await service.reauthenticateWithPassword('OldPass1!');

      expect(result, const Right<AuthException, void>(null));
      verify(mockUser.reauthenticateWithCredential(any)).called(1);
    });

    test('returns Left when no signed-in user', () async {
      when(mockAuth.currentUser).thenReturn(null);

      final result = await service.reauthenticateWithPassword('OldPass1!');

      expect(
        result,
        const Left<AuthException, void>(AuthException.noSignedInUser()),
      );
    });
  });

  group('RegistrationService updatePassword', () {
    test('updates password for signed-in user', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.updatePassword('NewPass1!')).thenAnswer((_) async {});

      final result = await service.updatePassword('NewPass1!');

      expect(result, const Right<AuthException, void>(null));
    });

    test('returns Left when no signed-in user', () async {
      when(mockAuth.currentUser).thenReturn(null);

      final result = await service.updatePassword('NewPass1!');

      expect(
        result,
        const Left<AuthException, void>(AuthException.noSignedInUser()),
      );
    });
  });

  group('RegistrationService confirmPasswordReset', () {
    test('confirms password reset with oob code', () async {
      when(
        mockAuth.confirmPasswordReset(
          code: anyNamed('code'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer((_) async {});

      final result = await service.confirmPasswordReset(
        oobCode: 'code-123',
        newPassword: 'NewPass1!',
      );

      expect(result, const Right<AuthException, void>(null));
    });
  });

  group('RegistrationService sendPasswordResetEmail', () {
    test('sends password reset email', () async {
      when(
        mockAuth.sendPasswordResetEmail(email: anyNamed('email')),
      ).thenAnswer((_) async {});

      final result = await service.sendPasswordResetEmail('user@example.com');

      expect(result, const Right<AuthException, void>(null));
      verify(
        mockAuth.sendPasswordResetEmail(email: 'user@example.com'),
      ).called(1);
    });
  });

  group('RegistrationService signOut', () {
    test('signs out remotely and clears local session', () async {
      when(mockAuth.signOut()).thenAnswer((_) async {});
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      when(mockLogin.deleteLoginInfo()).thenAnswer((_) async {});

      final result = await service.signOut();

      expect(result, const Right<AuthException, void>(null));
      verify(mockAuth.signOut()).called(1);
      verify(mockGoogleSignIn.signOut()).called(1);
      verify(mockLogin.deleteLoginInfo()).called(1);
    });

    test('clears local session when remote sign-out fails', () async {
      when(mockAuth.signOut()).thenThrow(Exception('network'));
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      when(mockLogin.deleteLoginInfo()).thenAnswer((_) async {});

      final result = await service.signOut();

      expect(result, const Right<AuthException, void>(null));
      verify(mockLogin.deleteLoginInfo()).called(1);
    });
  });
}
