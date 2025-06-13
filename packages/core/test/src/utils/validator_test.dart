import 'package:core/src/utils/validator/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validator', () {
    test('isValidInput returns true for valid input', () {
      // Arrange
      final input = 'Valid input 123';

      // Act
      final result = Validator.isValidInput(input);

      // Assert
      expect(result, isTrue);
    });

    test('isValidInput returns false for empty input', () {
      // Arrange
      final input = '';

      // Act
      final result = Validator.isValidInput(input);

      // Assert
      expect(result, isFalse);
    });

    test('isValidInput returns false for invalid input', () {
      // Arrange
      final input = 'Invalid input @#\$';

      // Act
      final result = Validator.isValidInput(input);

      // Assert
      expect(result, isFalse);
    });

    test('isValidSubtitle returns true for valid subtitle', () {
      // Arrange
      final subtitle = 'Valid subtitle 123';

      // Act
      final result = Validator.isValidSubtitle(subtitle);

      // Assert
      expect(result, isTrue);
    });

    test('isValidSubtitle returns false for empty subtitle', () {
      // Arrange
      final subtitle = '';

      // Act
      final result = Validator.isValidSubtitle(subtitle);

      // Assert
      expect(result, isFalse);
    });

    test('isValidSubtitle returns false for invalid subtitle', () {
      // Arrange
      final subtitle = 'Invalid subtitle @#\$';

      // Act
      final result = Validator.isValidSubtitle(subtitle);

      // Assert
      expect(result, isFalse);
    });

    test('trimWhitespace removes leading and trailing whitespace', () {
      // Arrange
      final input = '  Trim me  ';

      // Act
      final result = Validator.trimWhitespace(input);

      // Assert
      expect(result, equals('Trim me'));
    });

    test('validate returns true for valid input', () {
      // Arrange
      final input = 'Valid input 123';

      // Act
      final result = Validator.validate(input);

      // Assert
      expect(result, isTrue);
    });

    test('validate returns false for invalid input', () {
      // Arrange
      final input = 'Invalid input @#\$';

      // Act
      final result = Validator.validate(input);

      // Assert
      expect(result, isFalse);
    });
  });
}
