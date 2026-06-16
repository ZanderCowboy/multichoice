import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:models/models.dart';

abstract class IRegistrationService {
  Future<Either<AuthException, AuthResultDTO>> signUp(SignupRequestDTO dto);

  Future<Either<AuthException, AuthResultDTO>> signIn(
    String email,
    String password,
  );

  /// Google Sign-In; uses Firebase when available, otherwise stores a local session.
  Future<Either<AuthException, AuthResultDTO>> signInWithGoogle();

  /// Persists a user-chosen username after Google sign-in.
  Future<Either<AuthException, void>> setUsername(String username);

  /// Whether the signed-in Firebase user has an email/password provider linked.
  Future<bool> hasPasswordProvider();

  /// Links email/password credentials for Google-only accounts.
  Future<Either<AuthException, void>> linkPassword(String newPassword);

  /// Re-authenticates the current user before a sensitive action.
  Future<Either<AuthException, void>> reauthenticateWithPassword(
    String currentPassword,
  );

  /// Updates password for the current Firebase session (e.g. profile update).
  Future<Either<AuthException, void>> updatePassword(String newPassword);

  /// Completes password reset using the OOB code from the email link.
  Future<Either<AuthException, void>> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  });

  /// Sends a password reset email (forgot-password flow).
  Future<Either<AuthException, void>> sendPasswordResetEmail(String email);

  /// Signs out of Firebase/Google and clears the local session.
  Future<Either<AuthException, void>> signOut();
}
