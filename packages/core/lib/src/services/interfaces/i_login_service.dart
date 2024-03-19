abstract class Session {
  void storeLoginInfo(String accessToken);
  bool isUserLoggedIn();
  String getAccessToken();
  void deleteLoginInfo();
}
