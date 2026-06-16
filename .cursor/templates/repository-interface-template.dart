// Repository interface template
// Path: packages/core/lib/src/repositories/interfaces/<feature>/i_<feature>_repository.dart
// Export: packages/core/lib/src/repositories/export.dart

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:models/models.dart';

abstract class I<Feature>Repository {
  Future<Either<AuthException, <Result>DTO>> exampleMethod(<Request>DTO dto);
}
