import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parsePasswordResetOobCode', () {
    test('reads oobCode from top-level query', () {
      final uri = Uri.parse(
        'https://example.firebaseapp.com/__/auth/action'
        '?mode=resetPassword&oobCode=abc123',
      );

      expect(parsePasswordResetOobCode(uri), 'abc123');
    });

    test('reads oobCode from nested link parameter', () {
      final nested =
          'https://example.firebaseapp.com/__/auth/action'
          '?mode=resetPassword&oobCode=nested-code';
      final uri = Uri.parse(
        'https://example.page.link/?link=${Uri.encodeComponent(nested)}',
      );

      expect(parsePasswordResetOobCode(uri), 'nested-code');
    });

    test('reads oobCode from continueUrl parameter', () {
      final continueUrl =
          'https://example.firebaseapp.com/__/auth/action'
          '?mode=resetPassword&oobCode=continue-code';
      final uri = Uri.parse(
        'https://example.page.link/?continueUrl=${Uri.encodeComponent(continueUrl)}',
      );

      expect(parsePasswordResetOobCode(uri), 'continue-code');
    });

    test('returns null when mode is not resetPassword', () {
      final uri = Uri.parse(
        'https://example.firebaseapp.com/__/auth/action'
        '?mode=verifyEmail&oobCode=abc123',
      );

      expect(parsePasswordResetOobCode(uri), null);
    });

    test('returns null when oobCode is empty', () {
      final uri = Uri.parse(
        'https://example.firebaseapp.com/__/auth/action'
        '?mode=resetPassword&oobCode=',
      );

      expect(parsePasswordResetOobCode(uri), null);
    });
  });

  group('isPasswordResetLink', () {
    test('returns true for resetPassword mode', () {
      final uri = Uri.parse(
        'https://example.firebaseapp.com/__/auth/action?mode=resetPassword',
      );

      expect(isPasswordResetLink(uri), true);
    });

    test('returns true when nested link is a reset link', () {
      final nested =
          'https://example.firebaseapp.com/__/auth/action?mode=resetPassword';
      final uri = Uri.parse(
        'https://example.page.link/?link=${Uri.encodeComponent(nested)}',
      );

      expect(isPasswordResetLink(uri), true);
    });

    test('returns true when oobCode can be parsed', () {
      final uri = Uri.parse(
        'https://example.firebaseapp.com/__/auth/action'
        '?mode=resetPassword&oobCode=abc',
      );

      expect(isPasswordResetLink(uri), true);
    });

    test('returns false for unrelated links', () {
      expect(isPasswordResetLink(Uri.parse('https://example.com/')), false);
    });
  });
}
