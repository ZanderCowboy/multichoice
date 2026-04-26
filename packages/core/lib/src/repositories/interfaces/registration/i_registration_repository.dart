import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:models/models.dart';

abstract class IRegistrationRepository {
  Future<Either<AuthException, AuthResultDTO>> signUp(SignupRequestDTO dto);

  Future<Either<AuthException, AuthResultDTO>> signIn(
    String email,
    String password,
  );

  Future<Either<AuthException, AuthResultDTO>> signInWithGoogle();

  Future<Either<AuthException, void>> updatePassword(String newPassword);

  Future<Either<AuthException, void>> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  });

  Future<Either<AuthException, void>> sendPasswordResetEmail(String email);
}
