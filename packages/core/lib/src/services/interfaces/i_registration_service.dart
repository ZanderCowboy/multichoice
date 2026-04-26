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

  /// Updates password for the current Firebase session (e.g. profile "change password").
  Future<Either<AuthException, void>> updatePassword(String newPassword);

  /// Completes password reset using the OOB code from the email link.
  Future<Either<AuthException, void>> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  });

  /// Sends a password reset email (forgot-password flow).
  Future<Either<AuthException, void>> sendPasswordResetEmail(String email);
}
