import 'package:multichoice/presentation/registration/utils/password_validation_messages.dart';

/// Password validation for auth forms.
/// Requirements: 1 lower case, 1 upper case, 1 number, 1 special character,
/// 8 minimum characters.
class PasswordValidator {
  static const int minLength = 8;

  static final RegExp _lowerCase = RegExp('[a-z]');
  static final RegExp _upperCase = RegExp('[A-Z]');
  static final RegExp _digit = RegExp('[0-9]');
  static final RegExp _specialChar = RegExp(
    r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;/`~]',
  );

  /// Returns true if password meets all requirements.
  static bool isValid(String password) {
    if (password.length < minLength) return false;
    if (!_lowerCase.hasMatch(password)) return false;
    if (!_upperCase.hasMatch(password)) return false;
    if (!_digit.hasMatch(password)) return false;
    if (!_specialChar.hasMatch(password)) return false;
    return true;
  }

  /// Returns a list of unmet requirement messages.
  static List<String> getUnmetRequirements(
    String password, {
    required PasswordValidationMessages messages,
  }) {
    final list = <String>[];
    if (password.length < minLength) {
      list.add(messages.atLeast8Characters);
    }
    if (!_lowerCase.hasMatch(password)) {
      list.add(messages.oneLowercaseLetter);
    }
    if (!_upperCase.hasMatch(password)) {
      list.add(messages.oneUppercaseLetter);
    }
    if (!_digit.hasMatch(password)) {
      list.add(messages.oneNumber);
    }
    if (!_specialChar.hasMatch(password)) {
      list.add(messages.oneSpecialCharacter);
    }
    return list;
  }

  /// Returns the validation error message for FormFieldValidator.
  static String? validate(
    String? value, {
    required PasswordValidationMessages messages,
  }) {
    if (value == null || value.isEmpty) {
      return messages.passwordRequired;
    }
    final unmet = getUnmetRequirements(value, messages: messages);
    if (unmet.isEmpty) return null;
    return messages.passwordMustInclude(requirements: unmet.join(', '));
  }
}
