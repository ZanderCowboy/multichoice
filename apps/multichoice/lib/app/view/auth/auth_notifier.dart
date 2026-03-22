import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

/// Triggers UI rebuilds when auth state changes (login/logout).
/// Supports an optional debug override for manual UI testing.
class AuthNotifier extends ChangeNotifier {
  bool? _debugLoggedInOverride;

  /// Bumps when auth changes so keyed `FutureBuilder` session checks re-run.
  int authEpoch = 0;

  bool get hasDebugOverride => _debugLoggedInOverride != null;

  Future<bool> get isUserLoggedIn async {
    final override = _debugLoggedInOverride;
    if (override != null) return override;
    return coreSl.isRegistered<ILoginService>() &&
        await coreSl<ILoginService>().isUserLoggedIn();
  }

  bool? get debugLoggedInOverride => _debugLoggedInOverride;

  void setDebugLoggedInOverride({required bool value}) {
    _debugLoggedInOverride = value;
    notifyListeners();
  }

  void clearDebugLoggedInOverride() {
    _debugLoggedInOverride = null;
    notifyListeners();
  }

  void notifyAuthChanged() {
    authEpoch++;
    notifyListeners();
  }
}
