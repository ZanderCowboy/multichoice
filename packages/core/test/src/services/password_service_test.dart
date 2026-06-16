import 'package:core/src/services/implementations/password_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PasswordService passwordService;

  setUp(() {
    passwordService = PasswordService();
  });

  group('PasswordService', () {
    group('isValid', () {
      test('returns true for a password that meets all rules', () {
        expect(passwordService.isValid('Secure1!x'), true);
      });

      test('returns false when shorter than 8 characters', () {
        expect(passwordService.isValid('Ab1!aa'), false);
      });

      test('returns false without lowercase letter', () {
        expect(passwordService.isValid('SECURE1!A'), false);
      });

      test('returns false without uppercase letter', () {
        expect(passwordService.isValid('secure1!a'), false);
      });

      test('returns false without digit', () {
        expect(passwordService.isValid('Secure!ab'), false);
      });

      test('returns false without special character', () {
        expect(passwordService.isValid('Secure12a'), false);
      });
    });

    group('getUnmetRequirements', () {
      test('returns empty list when password is valid', () {
        expect(passwordService.getUnmetRequirements('GoodPass1!'), isEmpty);
      });

      test('lists all unmet rules for empty password', () {
        final unmet = passwordService.getUnmetRequirements('');
        expect(unmet, [
          'At least 8 characters',
          '1 lowercase letter',
          '1 uppercase letter',
          '1 number',
          '1 special character',
        ]);
      });
    });

    group('validate', () {
      test('returns message when value is null', () {
        expect(passwordService.validate(null), 'Password is required');
      });

      test('returns message when value is empty', () {
        expect(passwordService.validate(''), 'Password is required');
      });

      test('returns null when password is valid', () {
        expect(passwordService.validate('ValidPass1!'), isNull);
      });

      test('returns combined requirement message when invalid', () {
        final msg = passwordService.validate('short');
        expect(msg, startsWith('Password must include: '));
        expect(msg, contains('At least 8 characters'));
      });
    });
  });
}
