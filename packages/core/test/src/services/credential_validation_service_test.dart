import 'package:core/src/services/implementations/credential_validation_service.dart';
import 'package:core/src/services/implementations/password_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CredentialValidationService service;

  setUp(() {
    service = CredentialValidationService(PasswordService());
  });

  group('CredentialValidationService', () {
    test('validateEmail returns required message when empty', () {
      expect(service.validateEmail(''), 'Email is required');
    });

    test('validateEmail returns format message when invalid', () {
      expect(
        service.validateEmail('invalid-email'),
        'Enter a valid email address',
      );
    });

    test('validateUsername returns length message when too short', () {
      expect(
        service.validateUsername('a'),
        'Username must be at least 2 characters',
      );
    });

    test('validatePassword delegates to password policy service', () {
      expect(service.validatePassword('short'), isNotNull);
      expect(service.validatePassword('ValidPass1!'), isNull);
    });

    test('validatePasswordConfirmation enforces equality', () {
      expect(
        service.validatePasswordConfirmation(password: 'A', confirmation: 'B'),
        'Passwords do not match',
      );
    });
  });
}
