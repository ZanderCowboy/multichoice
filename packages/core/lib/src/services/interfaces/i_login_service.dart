abstract class Session {
  Future<void> storeLoginInfo(String accessToken);
  Future<bool> isUserLoggedIn();
  Future<String> getAccessToken();
  Future<void> deleteLoginInfo();
}
