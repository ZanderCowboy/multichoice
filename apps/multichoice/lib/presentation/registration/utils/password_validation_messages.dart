import 'package:multichoice/i18n/strings.g.dart';

/// Localized copy for password validation in auth forms.
class PasswordValidationMessages {
  const PasswordValidationMessages({
    required this.passwordRequired,
    required this.passwordMustInclude,
    required this.atLeast8Characters,
    required this.oneUppercaseLetter,
    required this.oneLowercaseLetter,
    required this.oneNumber,
    required this.oneSpecialCharacter,
  });

  factory PasswordValidationMessages.fromTranslations(Translations t) {
    final validation = t.validation;
    return PasswordValidationMessages(
      passwordRequired: validation.passwordRequired,
      passwordMustInclude: validation.passwordMustInclude,
      atLeast8Characters: validation.atLeast8Characters,
      oneUppercaseLetter: validation.oneUppercaseLetter,
      oneLowercaseLetter: validation.oneLowercaseLetter,
      oneNumber: validation.oneNumber,
      oneSpecialCharacter: validation.oneSpecialCharacter,
    );
  }

  final String passwordRequired;
  final String Function({required String requirements}) passwordMustInclude;
  final String atLeast8Characters;
  final String oneUppercaseLetter;
  final String oneLowercaseLetter;
  final String oneNumber;
  final String oneSpecialCharacter;

  List<String> get allRequirements => [
    atLeast8Characters,
    oneUppercaseLetter,
    oneLowercaseLetter,
    oneNumber,
    oneSpecialCharacter,
  ];
}
