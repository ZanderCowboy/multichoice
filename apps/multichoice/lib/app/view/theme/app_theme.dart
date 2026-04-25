import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme/theme.dart';
import 'package:ui_kit/ui_kit.dart';

part 'theme_data/dark_colors.dart';
part 'theme_data/dark_text_theme.dart';
part 'theme_data/dark_theme_data.dart';
part 'theme_data/light_colors.dart';
part 'theme_data/light_text_theme.dart';
part 'theme_data/light_theme_data.dart';
part 'app_palette.dart';
part 'app_typography.dart';

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

  static AppColorsExtension get darkAppColors => _darkColors;
  static AppTextExtension get darkTextTheme => _darkTextTheme;
  static ThemeData get darkThemeData => _darkThemeData;

  static AppColorsExtension get lightAppColors => _lightColors;
  static AppTextExtension get lightTextTheme => _lightTextTheme;
  static ThemeData get lightThemeData => _light;
}
