import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

@LazySingleton(as: IRegistrationRepository)
class RegistrationRepository implements IRegistrationRepository {
  RegistrationRepository(this._registrationService);

  final IRegistrationService _registrationService;

  @override
  Future<Either<AuthException, AuthResultDTO>> signUp(
    SignupRequestDTO dto,
  ) =>
      _registrationService.signUp(dto);

  @override
  Future<Either<AuthException, AuthResultDTO>> signIn(
    String email,
    String password,
  ) =>
      _registrationService.signIn(email, password);

  @override
  Future<Either<AuthException, AuthResultDTO>> signInWithGoogle() =>
      _registrationService.signInWithGoogle();
}
