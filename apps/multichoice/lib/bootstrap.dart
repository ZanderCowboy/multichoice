// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleBlocObserver extends BlocObserver {
  const SimpleBlocObserver();

  @override
  void onEvent(
    Bloc<dynamic, dynamic> bloc,
    Object? event,
  ) {
    super.onEvent(bloc, event);
    log('${bloc.runtimeType} $event');
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    log('${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    log('$transition');
  }
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureCoreDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initializeNonCriticalServices() async {
  // Run Remote Config setup after first frame to avoid blocking startup.
  try {
    final firebaseService = coreSl<IFirebaseService>();
    await firebaseService.initialize();
    await firebaseService.fetchAndActivate();
  } catch (e) {
    log('Error initializing Firebase Remote Config: $e');
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
