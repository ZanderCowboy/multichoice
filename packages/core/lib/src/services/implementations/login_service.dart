import 'package:core/src/services/interfaces/i_login_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

const _accessTokenKey = 'access_token';
const _loginStatusKey = 'login_status';
const _profileEmailKey = 'profile_email';
const _profileUsernameKey = 'profile_username';

@LazySingleton(as: Session)
class SessionImpl extends Session {
  SessionImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> storeLoginInfo(String accessToken) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _loginStatusKey, value: 'true');
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey) ?? '';
  }

  @override
  Future<void> deleteLoginInfo() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _loginStatusKey);
    await _secureStorage.delete(key: _profileEmailKey);
    await _secureStorage.delete(key: _profileUsernameKey);
  }

  @override
  Future<void> storeUserProfile({String? email, String? username}) async {
    if (email != null && email.isNotEmpty) {
      await _secureStorage.write(key: _profileEmailKey, value: email);
    }
    if (username != null && username.isNotEmpty) {
      await _secureStorage.write(key: _profileUsernameKey, value: username);
    }
  }

  @override
  Future<String?> getProfileEmail() async {
    final v = await _secureStorage.read(key: _profileEmailKey);
    return v?.isEmpty ?? true ? null : v;
  }

  @override
  Future<String?> getProfileUsername() async {
    final v = await _secureStorage.read(key: _profileUsernameKey);
    return v?.isEmpty ?? true ? null : v;
  }
}
