import 'package:core/core.dart';

class FakeLoginService implements ILoginService {
  FakeLoginService({this.loggedIn = false});

  bool loggedIn;

  @override
  Future<void> deleteLoginInfo() async {
    loggedIn = false;
  }

  @override
  Future<String> getAccessToken() async => 'token';

  @override
  Future<String?> getProfileEmail() async => 'user@example.com';

  @override
  Future<String?> getProfileUsername() async => 'alice';

  @override
  Future<bool> isUserLoggedIn() async => loggedIn;

  @override
  Future<void> storeLoginInfo(String accessToken) async {
    loggedIn = true;
  }

  @override
  Future<void> storeUserProfile({String? email, String? username}) async {}
}
