import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

@LazySingleton(as: IRegistrationService)
class RegistrationService implements IRegistrationService {
  RegistrationService(
    this._auth,
    this._session,
    this._appStorageService,
  );

  final FirebaseAuth _auth;
  final Session _session;
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

      await _session.storeLoginInfo(idToken);
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

      await _session.storeLoginInfo(idToken);
      await _appStorageService.setLastUsedEmail(email);

      return Right(
        AuthResultDTO(accessToken: idToken, userId: user.uid),
      );
    } on FirebaseAuthException catch (e) {
      return Left(AuthException(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Left(AuthException('Sign in failed: $e'));
    }
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
