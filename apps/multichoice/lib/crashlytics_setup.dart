// ignore_for_file: discarded_futures, document_ignores

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Sets up Firebase Crashlytics error handlers to catch and report
/// all uncaught errors in the Flutter app.
///
/// This function should be called after Firebase is initialized
/// and before runApp is called.
void setupCrashlytics() {
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the
  // Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
