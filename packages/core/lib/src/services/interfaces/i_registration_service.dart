import 'package:dartz/dartz.dart';
import 'package:models/models.dart';

/// Exception for auth-related failures (signup, signin).
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class IRegistrationService {
  Future<Either<AuthException, AuthResultDTO>> signUp(SignupRequestDTO dto);

  Future<Either<AuthException, AuthResultDTO>> signIn(
    String email,
    String password,
  );
}
