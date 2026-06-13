abstract final class AppConfig {
  static const flavor = String.fromEnvironment('APP_FLAVOR');
  static const webApiKey = String.fromEnvironment('WEB_API_KEY');
  static const webAppId = String.fromEnvironment('WEB_APP_ID');
  static const androidApiKey = String.fromEnvironment('ANDROID_API_KEY');
  static const androidAppId = String.fromEnvironment('ANDROID_APP_ID');
  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static const messagingSenderId = String.fromEnvironment(
    'MESSAGING_SENDER_ID',
  );
  static const authDomain = String.fromEnvironment('AUTH_DOMAIN');
  static const storageBucket = String.fromEnvironment('STORAGE_BUCKET');
  static const webMeasurementId = String.fromEnvironment('WEB_MEASUREMENT_ID');
  static const revenueCatAndroidApiKey = String.fromEnvironment(
    'REVENUE_CAT_ANDROID_API_KEY',
  );
}
