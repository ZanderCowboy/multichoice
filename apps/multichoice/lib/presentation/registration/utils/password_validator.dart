/// Password validation for auth forms.
/// Requirements: 1 lower case, 1 upper case, 1 number, 1 special character,
/// 8 minimum characters.
class PasswordValidator {
  static const int minLength = 8;

  static final RegExp _lowerCase = RegExp('[a-z]');
  static final RegExp _upperCase = RegExp('[A-Z]');
  static final RegExp _digit = RegExp('[0-9]');
  static final RegExp _specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;/`~]');

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
  static List<String> getUnmetRequirements(String password) {
    final list = <String>[];
    if (password.length < minLength) {
      list.add('At least 8 characters');
    }
    if (!_lowerCase.hasMatch(password)) {
      list.add('1 lowercase letter');
    }
    if (!_upperCase.hasMatch(password)) {
      list.add('1 uppercase letter');
    }
    if (!_digit.hasMatch(password)) {
      list.add('1 number');
    }
    if (!_specialChar.hasMatch(password)) {
      list.add('1 special character');
    }
    return list;
  }

  /// Returns the validation error message for FormFieldValidator.
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    final unmet = getUnmetRequirements(value);
    if (unmet.isEmpty) return null;
    return 'Password must include: ${unmet.join(', ')}';
  }
}
