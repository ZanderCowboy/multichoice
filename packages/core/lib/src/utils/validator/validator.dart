class Validator {
  final inputRegex = RegExp(r'^[a-zA-Z0-9\s-?!,.]+$');

  static bool isValidInput(String input) {
    return input.trim().isNotEmpty && validate(input);
  }

  static bool isValidSubtitle(String subtitle) {
    if (subtitle.trim().isEmpty) return false;

    return subtitle.trim().isNotEmpty && validate(subtitle);
  }

  static String trimWhitespace(String value) {
    return value.trim();
  }

  static bool validate(String value) {
    final result = value.isNotEmpty && Validator().inputRegex.hasMatch(value);

    return result;
  }
}
