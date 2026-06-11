// Repository test template (delegation to service)
// Path: packages/core/test/src/repositories/<feature>/<feature>_repository_test.dart

import 'package:core/core.dart';
import 'package:core/src/repositories/implementation/<feature>/<feature>_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late <Feature>Repository repository;
  late Mock<Feature>Service mockService;

  setUp(() {
    mockService = Mock<Feature>Service();
    repository = <Feature>Repository(mockService);
  });

  group('<Feature>Repository', () {
    test('exampleMethod delegates to service', () async {
      final dto = <Request>DTO(/* ... */);
      final expected = <Result>DTO(/* ... */);

      when(mockService.exampleMethod(dto)).thenAnswer(
        (_) async => Right(expected),
      );

      final result = await repository.exampleMethod(dto);

      expect(result, Right<AuthException, <Result>DTO>(expected));
      verify(mockService.exampleMethod(dto)).called(1);
    });
  });
}
