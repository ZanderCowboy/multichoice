abstract class ILoginService {
  Future<void> storeLoginInfo(String accessToken);
  Future<bool> isUserLoggedIn();
  Future<String> getAccessToken();
  Future<void> deleteLoginInfo();

  /// Optional display fields for the profile screen (cleared with [deleteLoginInfo]).
  Future<void> storeUserProfile({String? email, String? username});

  Future<String?> getProfileEmail();

  Future<String?> getProfileUsername();

  /// Maps username (lowercase) to email for local username login.
  Future<void> storeUsernameEmailMapping(String username, String email);

  /// Resolves [identifier] to an email when it is a stored username.
  Future<String?> resolveEmailForLogin(String identifier);

  /// Records that [userId] completed the post-Google username setup flow.
  Future<void> markUsernameConfirmed(String userId);

  /// Whether [userId] already completed username setup on this device.
  Future<bool> isUsernameConfirmed(String userId);
}
