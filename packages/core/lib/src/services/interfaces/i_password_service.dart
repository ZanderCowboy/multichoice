abstract class IPasswordService {
  /// Returns true if password meets all policy requirements.
  bool isValid(String password);

  /// Returns a list of unmet requirement messages.
  List<String> getUnmetRequirements(String password);

  /// Returns the validation error message for FormFieldValidator, or null if valid.
  String? validate(String? value);
}
