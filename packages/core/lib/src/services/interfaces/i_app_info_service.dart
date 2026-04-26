abstract class IAppInfoService {
  Future<String> getAppVersion();

  /// Returns true when [latestVersion] is greater than the currently installed
  /// app version (ignoring build number).
  Future<bool> isUpdateAvailable(String latestVersion);
}
