// Repository implementation template (thin delegate to service)
// Path: packages/core/lib/src/repositories/implementation/<feature>/<feature>_repository.dart

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

@LazySingleton(as: I<Feature>Repository)
class <Feature>Repository implements I<Feature>Repository {
  <Feature>Repository(this._service);

  final I<Feature>Service _service;

  @override
  Future<Either<AuthException, <Result>DTO>> exampleMethod(
    <Request>DTO dto,
  ) =>
      _service.exampleMethod(dto);
}
