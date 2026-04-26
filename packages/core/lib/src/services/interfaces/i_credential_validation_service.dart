abstract class ICredentialValidationService {
  String? validateEmail(String? value);

  String? validateUsername(String? value);

  String? validatePassword(String? value);

  String? validatePasswordRequired(String? value);

  String? validatePasswordConfirmation({
    required String? password,
    required String? confirmation,
  });
}
