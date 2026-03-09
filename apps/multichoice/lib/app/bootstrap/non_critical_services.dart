// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';
import 'dart:developer';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeNonCriticalServices() async {
  // Run Remote Config fetch after first frame to avoid blocking startup.
  try {
    final firebaseService = coreSl<IFirebaseService>();
    await firebaseService.fetchAndActivate();
  } catch (e) {
    log('Error fetching and activating Firebase Remote Config: $e');
    // Continue app startup even if Remote Config fails
  }

  try {
    final analyticsService = coreSl<IAnalyticsService>();
    final sharedPreferences = coreSl<SharedPreferences>();
    final appStorageService = coreSl<IAppStorageService>();
    final appInfoService = coreSl<IAppInfoService>();

    final existingUserId = sharedPreferences.getString(
      StorageKeys.analyticsUserId.key,
    );
    final userId =
        existingUserId ?? DateTime.now().microsecondsSinceEpoch.toString();

    if (existingUserId == null) {
      await sharedPreferences.setString(
        StorageKeys.analyticsUserId.key,
        userId,
      );
    }

    await analyticsService.setUserId(userId);

    final appVersion = await appInfoService.getAppVersion();
    final isExistingUser = await appStorageService.isExistingUser;
    await analyticsService.setUserProperties({
      AnalyticsUserProperty.appVersion: appVersion,
      AnalyticsUserProperty.platform: defaultTargetPlatform.name,
      AnalyticsUserProperty.isExistingUser: isExistingUser.toString(),
    });
  } catch (e) {
    log('Error initializing Firebase Analytics properties: $e');
  }
}

Future<void> initializeCriticalServices() async {
  // Ensure Remote Config is initialized before sync feature flag checks.
  final firebaseService = coreSl<IFirebaseService>();
  await firebaseService.initialize();
}
