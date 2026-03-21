import 'package:flutter/foundation.dart';

/// Triggers UI rebuilds when auth state changes (login/logout).
/// Pair with a keyed async session check so the UI refreshes after login/logout.
class AuthNotifier extends ChangeNotifier {
  /// Bumps when auth changes so keyed `FutureBuilder` session checks re-run.
  int authEpoch = 0;

  void notifyAuthChanged() {
    authEpoch++;
    notifyListeners();
  }
}
