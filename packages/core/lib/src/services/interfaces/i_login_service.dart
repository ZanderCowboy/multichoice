abstract class ILoginService {
  Future<void> storeLoginInfo(String accessToken);
  Future<bool> isUserLoggedIn();
  Future<String> getAccessToken();
  Future<void> deleteLoginInfo();

  /// Optional display fields for the profile screen (cleared with [deleteLoginInfo]).
  Future<void> storeUserProfile({String? email, String? username});

  Future<String?> getProfileEmail();

  Future<String?> getProfileUsername();
}
