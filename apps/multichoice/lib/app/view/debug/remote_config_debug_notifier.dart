import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';

/// Triggers UI rebuilds when debug Remote Config feature-flag overrides change.
class RemoteConfigDebugNotifier extends ChangeNotifier {
  bool get hasAnyOverride {
    return FirebaseConfigKeys.featureFlags.any(hasOverride);
  }

  bool effectiveValue(FirebaseConfigKeys key) {
    return coreSl<IFirebaseService>().isEnabled(key);
  }

  bool remoteValue(FirebaseConfigKeys key) {
    return coreSl<IFirebaseService>().getRemoteBool(key);
  }

  bool hasOverride(FirebaseConfigKeys key) {
    return coreSl<IFirebaseService>().hasDebugOverride(key);
  }

  void setOverride({required FirebaseConfigKeys key, required bool value}) {
    coreSl<IFirebaseService>().setDebugOverride(key, value);
    notifyListeners();
  }

  void clearOverride(FirebaseConfigKeys key) {
    coreSl<IFirebaseService>().setDebugOverride(key, null);
    notifyListeners();
  }

  void clearAllOverrides() {
    coreSl<IFirebaseService>().clearAllDebugOverrides();
    notifyListeners();
  }

  /// Rebuild consumers after a Remote Config fetch updates Firebase values.
  void notifyRemoteConfigRefreshed() {
    notifyListeners();
  }
}
