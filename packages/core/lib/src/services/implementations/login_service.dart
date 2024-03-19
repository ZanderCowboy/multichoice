import 'package:core/src/services/interfaces/i_login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionImpl extends Session {
  SessionImpl(this.sharedPref);

  SharedPreferences sharedPref;

  @override
  void storeLoginInfo(String accessToken) {
    sharedPref
      ..setBool('login_status', true)
      ..setString('access_token', accessToken);
  }

  @override
  bool isUserLoggedIn() {
    final isLoggedIn = sharedPref.getBool('login_status') ?? false;
    return isLoggedIn;
  }

  @override
  String getAccessToken() {
    return sharedPref.getString('access_token') ?? '';
  }

  @override
  void deleteLoginInfo() {
    if (sharedPref.containsKey('login_status')) {
      sharedPref.remove('login_status');
    }
    if (sharedPref.containsKey('access_token')) {
      sharedPref.remove('access_token');
    }
  }
}
