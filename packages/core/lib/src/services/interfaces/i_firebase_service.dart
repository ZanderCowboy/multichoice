import 'package:models/models.dart';

abstract class IFirebaseService {
  /// Initialize Firebase Remote Config with default settings
  Future<void> initialize();

  /// Fetch and activate the latest config from Firebase
  Future<void> fetchAndActivate();

  /// Force fetch and activate immediately, bypassing minimumFetchInterval
  /// This is useful for development/testing purposes
  Future<void> forceFetchAndActivate();

  /// Get a JSON config value and parse it as a model object
  /// Returns null if the config doesn't exist or parsing fails
  ///
  /// Example:
  /// ```dart
  /// final config = await service.getConfig<AppConfig>(
  ///   FirebaseConfigKeys.appConfig,
  ///   (json) => AppConfig.fromJson(json),
  /// );
  /// ```
  Future<T?> getConfig<T>(
    FirebaseConfigKeys key,
    T Function(Map<String, dynamic>) fromJson,
  );

  /// Check if a feature flag is enabled
  /// Returns false if the config doesn't exist or is not a boolean
  bool isEnabled(FirebaseConfigKeys key);

  /// Get a string config value
  /// Returns null if the config doesn't exist or is not a string
  Future<String?> getString(FirebaseConfigKeys key);
}
