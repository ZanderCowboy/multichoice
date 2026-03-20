import 'package:core/src/services/interfaces/i_login_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

const _accessTokenKey = 'access_token';
const _loginStatusKey = 'login_status';

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
  }
}
