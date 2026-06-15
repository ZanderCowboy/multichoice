import 'package:core/core.dart';
import 'package:core/src/config/auth_environment.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

@LazySingleton(as: IRegistrationService)
class RegistrationService implements IRegistrationService {
  RegistrationService(
    this._auth,
    this._loginService,
    this._appStorageService,
    this._googleSignIn,
  );

  final FirebaseAuth _auth;
  final ILoginService _loginService;
  final IAppStorageService _appStorageService;
  final GoogleSignIn _googleSignIn;

  @override
  Future<Either<AuthException, AuthResultDTO>> signUp(
    SignupRequestDTO dto,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: dto.email,
        password: dto.password,
      );

      final user = credential.user;
      if (user == null) {
        return const Left(AuthException.userCreationFailed());
      }

      if (dto.username.isNotEmpty) {
        await user.updateDisplayName(dto.username);
      }

      try {
        await user.sendEmailVerification();
      } catch (_) {
        // Verification email failure must not block registration.
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        return const Left(AuthException.tokenUnavailable());
      }

      await _loginService.storeLoginInfo(idToken);
      await _loginService.storeUserProfile(
        email: dto.email,
        username: dto.username.isNotEmpty ? dto.username : null,
      );
      if (dto.username.isNotEmpty) {
        await _loginService.storeUsernameEmailMapping(dto.username, dto.email);
      }
      await _appStorageService.setIsExistingUser(true);
      await _appStorageService.setHasPreviouslySignedIn(true);
      await _appStorageService.setLastUsedEmail(dto.email);

      return Right(
        AuthResultDTO(accessToken: idToken, userId: user.uid),
      );
    } on FirebaseAuthException catch (e) {
      return Left(AuthException.firebaseMessage(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException.signUpFailed(e));
    }
  }

  @override
  Future<Either<AuthException, AuthResultDTO>> signIn(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        return const Left(AuthException.signInFailed());
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        return const Left(AuthException.tokenUnavailable());
      }

      await _loginService.storeLoginInfo(idToken);

      final trimmed = email.trim();
      final resolvedEmail = user.email;
      final username = user.displayName;
      await _loginService.storeUserProfile(
        email: resolvedEmail ?? (trimmed.contains('@') ? trimmed : null),
        username: username ?? (!trimmed.contains('@') ? trimmed : null),
      );
      if (resolvedEmail != null &&
          resolvedEmail.isNotEmpty &&
          username != null &&
          username.isNotEmpty) {
        await _loginService.storeUsernameEmailMapping(username, resolvedEmail);
      }
      if (resolvedEmail != null && resolvedEmail.isNotEmpty) {
        await _appStorageService.setLastUsedEmail(resolvedEmail);
      } else if (trimmed.contains('@')) {
        await _appStorageService.setLastUsedEmail(trimmed);
      }
      await _appStorageService.setIsExistingUser(true);
      await _appStorageService.setHasPreviouslySignedIn(true);

      return Right(
        AuthResultDTO(accessToken: idToken, userId: user.uid),
      );
    } on FirebaseAuthException catch (e) {
      return Left(AuthException.firebaseMessage(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException.emailSignInFailed(e));
    }
  }

  @override
  Future<Either<AuthException, AuthResultDTO>> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return const Left(AuthException.signInCancelled());
      }

      final googleAuth = await account.authentication;
      if (_hasUsableGoogleTokens(googleAuth)) {
        return _signInWithGoogleViaFirebase(account, googleAuth);
      }

      return _completeGoogleLocalSession(account);
    } catch (e) {
      return Left(AuthException.googleSignInFailed(e));
    }
  }

  @override
  Future<Either<AuthException, void>> setUsername(String username) async {
    try {
      final trimmed = username.trim();
      if (trimmed.isEmpty) {
        return const Left(AuthException('Username is required'));
      }

      final user = _auth.currentUser;
      String? userId = user?.uid;
      if (user != null) {
        await user.updateDisplayName(trimmed);
      } else {
        final token = await _loginService.getAccessToken();
        if (token.startsWith('google_local_')) {
          userId = token.substring('google_local_'.length);
        }
      }

      if (userId != null && userId.isNotEmpty) {
        await _loginService.markUsernameConfirmed(userId);
      }

      final email = user?.email ?? await _loginService.getProfileEmail();
      await _loginService.storeUserProfile(
        email: email,
        username: trimmed,
      );
      if (email != null && email.isNotEmpty) {
        await _loginService.storeUsernameEmailMapping(trimmed, email);
      }

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthException.firebaseMessage(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException.emailSignInFailed(e));
    }
  }

  @override
  Future<bool> hasPasswordProvider() async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    return _userHasPasswordProvider(user);
  }

  @override
  Future<Either<AuthException, void>> linkPassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Left(AuthException.noSignedInUser());
      }

      final email = user.email;
      if (email == null || email.isEmpty) {
        return const Left(
          AuthException('No email on this account. Cannot set a password.'),
        );
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: newPassword,
      );
      await user.linkWithCredential(credential);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthException.firebaseMessage(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException.emailSignInFailed(e));
    }
  }

  @override
  Future<Either<AuthException, void>> reauthenticateWithPassword(
    String currentPassword,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Left(AuthException.noSignedInUser());
      }

      final email = user.email;
      if (email == null || email.isEmpty) {
        return const Left(AuthException.noSignedInUser());
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthException.firebaseMessage(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException.emailSignInFailed(e));
    }
  }

  static bool _hasUsableGoogleTokens(GoogleSignInAuthentication auth) {
    final idToken = auth.idToken;
    final accessToken = auth.accessToken;
    return idToken != null &&
        accessToken != null &&
        idToken.isNotEmpty &&
        accessToken.isNotEmpty;
  }

  Future<Either<AuthException, AuthResultDTO>> _signInWithGoogleViaFirebase(
    GoogleSignInAccount account,
    GoogleSignInAuthentication googleAuth,
  ) async {
    try {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        return const Left(AuthException.signInFailed());
      }

      final token = await user.getIdToken();
      if (token == null) {
        return const Left(AuthException.tokenUnavailable());
      }

      await _loginService.storeLoginInfo(token);
      final email = user.email ?? account.email;
      final usernameConfirmed = await _loginService.isUsernameConfirmed(
        user.uid,
      );
      final resolvedUsername = usernameConfirmed ? user.displayName : null;
      await _loginService.storeUserProfile(
        email: email.isNotEmpty ? email : null,
        username: resolvedUsername,
      );
      if (resolvedUsername != null &&
          resolvedUsername.isNotEmpty &&
          email.isNotEmpty) {
        await _loginService.storeUsernameEmailMapping(resolvedUsername, email);
      }
      await _appStorageService.setIsExistingUser(true);
      await _appStorageService.setHasPreviouslySignedIn(true);
      if (email.isNotEmpty) {
        await _appStorageService.setLastUsedEmail(email);
      }

      return Right(
        AuthResultDTO(
          accessToken: token,
          userId: user.uid,
          needsUsernameSetup: !usernameConfirmed,
        ),
      );
    } catch (_) {
      return _completeGoogleLocalSession(account);
    }
  }

  Future<Either<AuthException, AuthResultDTO>> _completeGoogleLocalSession(
    GoogleSignInAccount account,
  ) async {
    final syntheticToken = 'google_local_${account.id}';
    await _loginService.storeLoginInfo(syntheticToken);

    final email = account.email;
    final usernameConfirmed = await _loginService.isUsernameConfirmed(
      account.id,
    );
    final resolvedUsername = usernameConfirmed ? account.displayName : null;
    await _loginService.storeUserProfile(
      email: email.isNotEmpty ? email : null,
      username: resolvedUsername,
    );
    await _appStorageService.setIsExistingUser(true);
    await _appStorageService.setHasPreviouslySignedIn(true);
    if (email.isNotEmpty) {
      await _appStorageService.setLastUsedEmail(email);
    }

    await _loginService.getProfileUsername();
    final needsUsernameSetup = !usernameConfirmed;

    return Right(
      AuthResultDTO(
        accessToken: syntheticToken,
        userId: account.id,
        needsUsernameSetup: needsUsernameSetup,
      ),
    );
  }

  @override
  Future<Either<AuthException, void>> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Left(AuthException.noSignedInUser());
      }
      await user.updatePassword(newPassword);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthException.firebaseMessage(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException.emailSignInFailed(e));
    }
  }

  @override
  Future<Either<AuthException, void>> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(
        code: oobCode,
        newPassword: newPassword,
      );
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthException.firebaseMessage(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException.emailSignInFailed(e));
    }
  }

  @override
  Future<Either<AuthException, void>> sendPasswordResetEmail(
    String email,
  ) async {
    try {
      final continueUrl = AuthEnvironment.passwordResetContinueUrl;
      if (continueUrl.isNotEmpty) {
        await _auth.sendPasswordResetEmail(
          email: email.trim(),
          actionCodeSettings: ActionCodeSettings(
            url: continueUrl,
            handleCodeInApp: true,
            androidPackageName: AuthEnvironment.androidPackageName,
            iOSBundleId: AuthEnvironment.iosBundleId,
          ),
        );
      } else {
        await _auth.sendPasswordResetEmail(email: email.trim());
      }
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthException.firebaseMessage(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException.emailSignInFailed(e));
    }
  }

  @override
  Future<Either<AuthException, void>> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      // Always clear local session even if remote sign-out fails.
    }
    await _loginService.deleteLoginInfo();
    return const Right(null);
  }

  static bool _userHasPasswordProvider(User user) {
    return user.providerData.any((info) => info.providerId == 'password');
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    return switch (e.code) {
      'email-already-in-use' => 'An account already exists for this email.',
      'invalid-email' => 'Invalid email address.',
      'operation-not-allowed' => 'Email/password accounts are not enabled.',
      'weak-password' => 'Password is too weak.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' => 'No account found for this email.',
      'wrong-password' => 'Incorrect password.',
      'invalid-credential' => 'Invalid email or password.',
      'invalid-login-credentials' => 'Invalid email or password.',
      'requires-recent-login' =>
        'Please sign in again before changing your password.',
      'credential-already-in-use' =>
        'This email is already linked to another sign-in method.',
      'provider-already-linked' =>
        'A password is already set for this account.',
      'expired-action-code' =>
        'This reset link has expired. Request a new one.',
      'invalid-action-code' =>
        'This reset link is invalid or was already used.',
      _ => e.message ?? e.code,
    };
  }
}
