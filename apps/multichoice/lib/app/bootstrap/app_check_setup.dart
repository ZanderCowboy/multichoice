import 'dart:developer';
import 'dart:io' show Platform;

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

Future<void> setupAppCheck() async {
  if (kIsWeb || !Platform.isAndroid) {
    return;
  }

  // Debug builds only: debug provider + console debug token.
  // Profile and release (DEV and PROD): Play Integrity + SHA-256 in App Check.
  const useDebugProvider = kDebugMode;

  await FirebaseAppCheck.instance.activate(
    providerAndroid: useDebugProvider
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
  );

  if (useDebugProvider) {
    log(
      'App Check debug provider active. Register the debug token from logcat '
      '(search "App Check debug token") in Firebase Console → App Check → '
      'Apps → Manage debug tokens.',
    );
  } else {
    log(
      'App Check Play Integrity active. Ensure release SHA-256 is registered '
      'in Firebase App Check and Play Integrity API is linked for this app.',
    );
  }
}
