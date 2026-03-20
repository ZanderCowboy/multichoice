import 'package:flutter/foundation.dart';

/// Triggers UI rebuilds when auth state changes (login/logout).
/// Widgets read actual auth state from [Session.isUserLoggedIn()].
class AuthNotifier extends ChangeNotifier {
  void notifyAuthChanged() {
    notifyListeners();
  }
}
