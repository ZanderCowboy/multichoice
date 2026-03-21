import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

/// Triggers UI rebuilds when auth state changes (login/logout).
/// Supports an optional debug override for manual UI testing.
class AuthNotifier extends ChangeNotifier {
  bool? _debugLoggedInOverride;

  bool get hasDebugOverride => _debugLoggedInOverride != null;

  bool get isUserLoggedIn {
    final override = _debugLoggedInOverride;
    if (override != null) return override;
    return coreSl.isRegistered<Session>() && coreSl<Session>().isUserLoggedIn();
  }

  bool? get debugLoggedInOverride => _debugLoggedInOverride;

  void setDebugLoggedInOverride(bool value) {
    _debugLoggedInOverride = value;
    notifyListeners();
  }

  void clearDebugLoggedInOverride() {
    _debugLoggedInOverride = null;
    notifyListeners();
  }

  void notifyAuthChanged() {
    notifyListeners();
  }
}
