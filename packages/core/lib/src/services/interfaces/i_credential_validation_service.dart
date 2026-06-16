abstract class ICredentialValidationService {
  String? validateEmail(String? value);

  /// Validates email format when a value is present; empty input is valid.
  String? validateOptionalEmail(String? value);

  String? validateUsername(String? value);

  String? validatePassword(String? value);

  String? validatePasswordRequired(String? value);

  String? validatePasswordConfirmation({
    required String? password,
    required String? confirmation,
  });

  /// Validates login identifier as email or username.
  String? validateLoginIdentifier(String? value);
}
