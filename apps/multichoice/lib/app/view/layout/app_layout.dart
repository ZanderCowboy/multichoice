import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLayout with ChangeNotifier {
  final _prefs = coreSl<SharedPreferences>();

  bool _appLayout = false;
  bool get appLayout => isLayoutVertical();

  set appLayout(bool isLayoutVertical) {
    _appLayout = isLayoutVertical;

    _prefs.setBool('isLayoutVertical', isLayoutVertical);

    notifyListeners();
  }

  bool isLayoutVertical() => _prefs.getBool('isLayoutVertical') ?? _appLayout;
}
