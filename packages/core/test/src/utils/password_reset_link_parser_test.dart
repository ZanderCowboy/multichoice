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
  });
}
