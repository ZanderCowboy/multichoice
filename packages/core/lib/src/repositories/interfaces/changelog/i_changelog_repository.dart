import 'package:dartz/dartz.dart';
import 'package:models/models.dart';

class ChangelogException implements Exception {
  final String message;
  ChangelogException(this.message);

  @override
  String toString() => message;
}

abstract class IChangelogRepository {
  Future<Either<ChangelogException, Changelog>> getChangelog();
}
