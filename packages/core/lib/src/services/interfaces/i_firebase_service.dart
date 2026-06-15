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
  /// Honors debug overrides when set via [setDebugOverride].
  bool isEnabled(FirebaseConfigKeys key);

  /// Read the activated Remote Config boolean without debug overrides.
  bool getRemoteBool(FirebaseConfigKeys key);

  /// Set a debug override for a boolean flag. Pass null to clear.
  void setDebugOverride(FirebaseConfigKeys key, bool? value);

  /// Whether a debug override is active for [key].
  bool hasDebugOverride(FirebaseConfigKeys key);

  /// Clear all debug overrides for boolean flags.
  void clearAllDebugOverrides();

  /// Get a string config value
  /// Returns null if the config doesn't exist or is not a string
  Future<String?> getString(FirebaseConfigKeys key);
}
