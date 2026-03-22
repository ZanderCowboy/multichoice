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
}
