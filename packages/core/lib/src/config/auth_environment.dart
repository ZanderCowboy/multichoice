/// Firebase Auth action-link settings sourced from app dart-defines.
abstract final class AuthEnvironment {
  static const authDomain = String.fromEnvironment('AUTH_DOMAIN');

  static const androidPackageName = String.fromEnvironment(
    'ANDROID_PACKAGE_NAME',
    defaultValue: 'co.za.zanderkotze.multichoice',
  );

  static const iosBundleId = String.fromEnvironment(
    'IOS_BUNDLE_ID',
    defaultValue: 'co.za.zanderkotze.multichoice',
  );

  /// Continue URL host for password-reset emails. Must be an authorized domain
  /// in Firebase Console.
  static String get passwordResetContinueUrl {
    if (authDomain.isEmpty) {
      return '';
    }
    return 'https://$authDomain';
  }
}
