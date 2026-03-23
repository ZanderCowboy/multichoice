import 'package:core/core.dart';
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

      final idToken = await user.getIdToken();
      if (idToken == null) {
        return const Left(AuthException.tokenUnavailable());
      }

      await _loginService.storeLoginInfo(idToken);
      await _loginService.storeUserProfile(
        email: dto.email,
        username: dto.username.isNotEmpty ? dto.username : null,
      );
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
      await _loginService.storeUserProfile(
        email: resolvedEmail ?? (trimmed.contains('@') ? trimmed : null),
        username: user.displayName ?? (!trimmed.contains('@') ? trimmed : null),
      );
      if (resolvedEmail != null && resolvedEmail.isNotEmpty) {
        await _appStorageService.setLastUsedEmail(resolvedEmail);
      } else if (trimmed.contains('@')) {
        await _appStorageService.setLastUsedEmail(trimmed);
      }

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
      final resolvedName = _firstNonEmptyDisplayName(
        user.displayName,
        account.displayName,
      );
      await _loginService.storeUserProfile(
        email: email.isNotEmpty ? email : null,
        username: resolvedName,
      );
      if (email.isNotEmpty) {
        await _appStorageService.setLastUsedEmail(email);
      }

      return Right(
        AuthResultDTO(accessToken: token, userId: user.uid),
      );
    } catch (_) {
      return _completeGoogleLocalSession(account);
    }
  }

  /// Prefers [primary] when non-empty, otherwise [secondary] if non-empty.
  static String? _firstNonEmptyDisplayName(String? primary, String? secondary) {
    if (primary != null && primary.isNotEmpty) {
      return primary;
    }
    if (secondary != null && secondary.isNotEmpty) {
      return secondary;
    }
    return null;
  }

  Future<Either<AuthException, AuthResultDTO>> _completeGoogleLocalSession(
    GoogleSignInAccount account,
  ) async {
    final syntheticToken = 'google_local_${account.id}';
    await _loginService.storeLoginInfo(syntheticToken);

    final email = account.email;
    final display = account.displayName ?? '';
    String? username;
    if (display.isNotEmpty) {
      username = display;
    } else if (email.contains('@')) {
      username = email.split('@').first;
    } else if (email.isNotEmpty) {
      username = email;
    }

    await _loginService.storeUserProfile(
      email: email.isNotEmpty ? email : null,
      username: username,
    );
    if (email.isNotEmpty) {
      await _appStorageService.setLastUsedEmail(email);
    }

    return Right(
      AuthResultDTO(
        accessToken: syntheticToken,
        userId: account.id,
      ),
    );
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
      _ => e.message ?? e.code,
    };
  }
}
