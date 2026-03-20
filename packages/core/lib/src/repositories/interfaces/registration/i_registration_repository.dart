import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:models/models.dart';

abstract class IRegistrationRepository {
  Future<Either<AuthException, AuthResultDTO>> signUp(SignupRequestDTO dto);

  Future<Either<AuthException, AuthResultDTO>> signIn(
    String email,
    String password,
  );
}
