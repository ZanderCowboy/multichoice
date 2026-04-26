import 'package:core/core.dart';
import 'package:core/src/repositories/implementation/registration/registration_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late RegistrationRepository repository;
  late MockRegistrationService mockService;

  final successResult = AuthResultDTO(accessToken: 'token', userId: 'uid');

  setUp(() {
    mockService = MockRegistrationService();
    repository = RegistrationRepository(mockService);
  });

  group('RegistrationRepository', () {
    final dto = SignupRequestDTO(
      email: 'a@b.com',
      username: 'user',
      password: 'Secure1!',
    );

    test('signUp delegates to registration service', () async {
      when(
        mockService.signUp(dto),
      ).thenAnswer((_) async => Right(successResult));

      final result = await repository.signUp(dto);

      expect(result, Right<AuthException, AuthResultDTO>(successResult));
      verify(mockService.signUp(dto)).called(1);
    });

    test('signIn delegates to registration service', () async {
      when(
        mockService.signIn('a@b.com', 'secret'),
      ).thenAnswer((_) async => Right(successResult));

      final result = await repository.signIn('a@b.com', 'secret');

      expect(result, Right<AuthException, AuthResultDTO>(successResult));
      verify(mockService.signIn('a@b.com', 'secret')).called(1);
    });

    test('signInWithGoogle delegates to registration service', () async {
      when(
        mockService.signInWithGoogle(),
      ).thenAnswer((_) async => Right(successResult));

      final result = await repository.signInWithGoogle();

      expect(result, Right<AuthException, AuthResultDTO>(successResult));
      verify(mockService.signInWithGoogle()).called(1);
    });

    test('updatePassword delegates to registration service', () async {
      when(
        mockService.updatePassword('newPass1!'),
      ).thenAnswer((_) async => const Right(null));

      final result = await repository.updatePassword('newPass1!');

      expect(result, const Right<AuthException, void>(null));
      verify(mockService.updatePassword('newPass1!')).called(1);
    });

    test('confirmPasswordReset delegates to registration service', () async {
      when(
        mockService.confirmPasswordReset(oobCode: 'code', newPassword: 'p'),
      ).thenAnswer((_) async => const Right(null));

      final result = await repository.confirmPasswordReset(
        oobCode: 'code',
        newPassword: 'p',
      );

      expect(result, const Right<AuthException, void>(null));
      verify(
        mockService.confirmPasswordReset(oobCode: 'code', newPassword: 'p'),
      ).called(1);
    });

    test('sendPasswordResetEmail delegates to registration service', () async {
      when(
        mockService.sendPasswordResetEmail('a@b.com'),
      ).thenAnswer((_) async => const Right(null));

      final result = await repository.sendPasswordResetEmail('a@b.com');

      expect(result, const Right<AuthException, void>(null));
      verify(mockService.sendPasswordResetEmail('a@b.com')).called(1);
    });
  });
}
