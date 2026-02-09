import 'dart:convert';
import 'dart:developer';

import 'package:core/src/services/interfaces/i_firebase_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

@LazySingleton(as: IFirebaseService)
class FirebaseService implements IFirebaseService {
  FirebaseService({FirebaseRemoteConfig? remoteConfig}) {
    _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;
  }

  late final FirebaseRemoteConfig _remoteConfig;
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // Set default values if needed
      await _remoteConfig.setDefaults({});

      _isInitialized = true;
    } catch (e) {
      log('Error initializing Firebase Remote Config: $e');
      rethrow;
    }
  }

  @override
  Future<void> fetchAndActivate() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      log('Error fetching and activating Remote Config: $e');
      rethrow;
    }
  }

  @override
  Future<void> forceFetchAndActivate() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Temporarily set minimumFetchInterval to 0 to force immediate fetch
      final originalSettings = _remoteConfig.settings;
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: originalSettings.fetchTimeout,
          minimumFetchInterval: Duration.zero,
        ),
      );

      await _remoteConfig.fetchAndActivate();

      // Restore original settings
      await _remoteConfig.setConfigSettings(originalSettings);
    } catch (e) {
      log('Error force fetching and activating Remote Config: $e');
      rethrow;
    }
  }

  @override
  Future<T?> getConfig<T>(
    FirebaseConfigKeys key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final jsonString = _remoteConfig.getString(key.key);

      if (jsonString.isEmpty) {
        log('Config key "${key.key}" not found or empty');
        return null;
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      log('Error parsing config for key "${key.key}": $e');
      return null;
    }
  }

  @override
  bool isEnabled(FirebaseConfigKeys key) {
    if (!_isInitialized) {
      log('FirebaseService not initialized. Call initialize() first.');
      return false;
    }

    try {
      return _remoteConfig.getBool(key.key);
    } catch (e) {
      log('Error getting feature flag for key "${key.key}": $e');
      return false;
    }
  }

  @override
  Future<String?> getString(FirebaseConfigKeys key) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final value = _remoteConfig.getString(key.key);

      return value;
    } catch (e) {
      log('Error getting string for key "${key.key}": $e');
      return null;
    }
  }
}
