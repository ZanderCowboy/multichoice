import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/view/theme/app_palette.dart';
import 'package:multichoice/app/view/theme/app_typography.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';

part 'theme_extension/_dark_app_colors.dart';
part 'theme_extension/_dark_text_theme.dart';
part 'theme_extension/_light_app_colors.dart';
part 'theme_extension/_light_text_theme.dart';
part 'dark_app_theme.dart';
part 'light_app_theme.dart';

class AppTheme with ChangeNotifier {
  final SharedPreferences _prefs = coreSl<SharedPreferences>();

  ThemeMode _themeMode = ThemeMode.system;

  bool isDarkTheme() =>
      _prefs.getBool('isDarkMode') ?? _themeMode == ThemeMode.dark;

  ThemeMode get themeMode => isDarkTheme() ? ThemeMode.dark : ThemeMode.light;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;

    final isDarkMode = themeMode == ThemeMode.dark;
    unawaited(_prefs.setBool('isDarkMode', isDarkMode));

    notifyListeners();
  }

  static final ThemeData light = _light;

  static final ThemeData dark = _dark;

  static AppColorsExtension get lightAppColors => _lightAppColors;

  static AppTextExtension get lightTextTheme => _lightTextTheme;

  static AppColorsExtension get darkAppColors => _darkAppColors;

  static AppTextExtension get darkTextTheme => _darkTextTheme;
}
