# 244 - Firebase Crashlytics Setup

- Add `firebase_crashlytics` and `firebase_analytics` package dependency
- Create `crashlytics_setup.dart` file with `setupCrashlytics()` function
- Configure `FlutterError.onError` to record Flutter framework fatal errors
- Configure `PlatformDispatcher.instance.onError` to record asynchronous errors
- Import and call `setupCrashlytics()` in `main.dart` after Firebase initialization
- Add test FloatingActionButton to home page for Crashlytics testing

