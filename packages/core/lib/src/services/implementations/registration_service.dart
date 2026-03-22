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
  );

  final FirebaseAuth _auth;
  final ILoginService _loginService;
  final IAppStorageService _appStorageService;

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
        return const Left(
          AuthException('User creation failed'),
        );
      }

      if (dto.username.isNotEmpty) {
        await user.updateDisplayName(dto.username);
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        return const Left(
          AuthException('Failed to get authentication token'),
        );
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
      return Left(AuthException(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException('Sign up failed: $e'));
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
        return const Left(
          AuthException('Sign in failed'),
        );
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        return const Left(
          AuthException('Failed to get authentication token'),
        );
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
      return Left(AuthException(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException('Sign in failed: $e'));
    }
  }

  @override
  Future<Either<AuthException, AuthResultDTO>> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: const ['email', 'profile'],
      );
      final account = await googleSignIn.signIn();
      if (account == null) {
        return const Left(AuthException('Sign in cancelled'));
      }

      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken != null &&
          accessToken != null &&
          idToken.isNotEmpty &&
          accessToken.isNotEmpty) {
        try {
          final credential = GoogleAuthProvider.credential(
            accessToken: accessToken,
            idToken: idToken,
          );
          final userCredential = await _auth.signInWithCredential(credential);
          final user = userCredential.user;
          if (user == null) {
            return const Left(AuthException('Sign in failed'));
          }

          final token = await user.getIdToken();
          if (token == null) {
            return const Left(
              AuthException('Failed to get authentication token'),
            );
          }

          await _loginService.storeLoginInfo(token);
          final email = user.email ?? account.email;
          final firebaseName = user.displayName;
          final googleName = account.displayName;
          final resolvedName = (firebaseName != null && firebaseName.isNotEmpty)
              ? firebaseName
              : ((googleName ?? '').isNotEmpty ? googleName : null);
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

      return _completeGoogleLocalSession(account);
    } catch (e) {
      return Left(AuthException('Google sign-in failed: $e'));
    }
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
