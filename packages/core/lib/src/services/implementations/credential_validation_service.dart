import 'package:core/src/services/interfaces/i_credential_validation_service.dart';
import 'package:core/src/services/interfaces/i_password_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ICredentialValidationService)
class CredentialValidationService implements ICredentialValidationService {
  CredentialValidationService(this._passwordService);

  final IPasswordService _passwordService;

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static const int _minUsernameLength = 2;

  @override
  String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  String? validateUsername(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Username is required';
    }
    if (trimmed.length < _minUsernameLength) {
      return 'Username must be at least 2 characters';
    }
    return null;
  }

  @override
  String? validatePassword(String? value) {
    return _passwordService.validate(value);
  }

  @override
  String? validatePasswordRequired(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  @override
  String? validatePasswordConfirmation({
    required String? password,
    required String? confirmation,
  }) {
    final confirmationValue = confirmation?.trim() ?? '';
    if (confirmationValue.isEmpty) {
      return 'Please confirm your password';
    }

    final passwordValue = password?.trim() ?? '';
    if (passwordValue != confirmationValue) {
      return 'Passwords do not match';
    }

    return null;
  }
}
