abstract class IAppInfoService {
  Future<String> getAppVersion();

  /// Semver only (X.Y.Z), without build number. Used for user-facing version display.
  Future<String> getDisplayAppVersion();

  /// Returns true when [latestVersion] is greater than the currently installed
  /// app version (ignoring build number).
  Future<bool> isUpdateAvailable(String latestVersion);
}
