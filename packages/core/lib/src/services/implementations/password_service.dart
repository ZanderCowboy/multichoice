import 'package:core/src/services/interfaces/i_password_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPasswordService)
class PasswordService implements IPasswordService {
  static const int _minLength = 8;
  static final RegExp _lowerCase = RegExp('[a-z]');
  static final RegExp _upperCase = RegExp('[A-Z]');
  static final RegExp _digit = RegExp('[0-9]');
  static final RegExp _specialChar =
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;/`~]');

  @override
  bool isValid(String password) {
    if (password.length < _minLength) return false;
    if (!_lowerCase.hasMatch(password)) return false;
    if (!_upperCase.hasMatch(password)) return false;
    if (!_digit.hasMatch(password)) return false;
    if (!_specialChar.hasMatch(password)) return false;
    return true;
  }

  @override
  List<String> getUnmetRequirements(String password) {
    final list = <String>[];
    if (password.length < _minLength) {
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

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    final unmet = getUnmetRequirements(value);
    if (unmet.isEmpty) return null;
    return 'Password must include: ${unmet.join(', ')}';
  }
}
