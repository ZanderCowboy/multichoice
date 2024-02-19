import 'package:flutter/material.dart';
import 'package:multichoice/app/view/theme/app_typography.dart';
import 'package:multichoice/utils/theme_extension/app_colors_extension.dart';
import 'package:multichoice/utils/theme_extension/app_text_extension.dart';

class AppTheme with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  static final light = () {
    final defaultTheme = ThemeData.light();

    return defaultTheme.copyWith(
      appBarTheme: AppBarTheme(
        color: _lightAppColors.secondary,
      ),
      textTheme: defaultTheme.textTheme.copyWith(
        bodyMedium: AppTypography.body1.copyWith(color: Colors.black),
      ),
      extensions: [
        _lightAppColors,
        _lightTextTheme,
      ],
    );
  }();

  static AppColorsExtension get lightAppColors => _lightAppColors;

  static final _lightAppColors = AppColorsExtension(
    primary: const Color(0xff6200ee),
    secondary: const Color(0xff03dac6),
    background: Colors.white,
  );

  static AppTextExtension get lightTextTheme => _lightTextTheme;

  static final _lightTextTheme = AppTextExtension(
    body1: AppTypography.body1.copyWith(color: _lightAppColors.background),
    h1: AppTypography.h1.copyWith(color: Colors.black),
  );

  static final dark = ThemeData.dark().copyWith(
    extensions: [
      _darkAppColors,
    ],
  );

  static AppColorsExtension get darkAppColors => _darkAppColors;

  static final _darkAppColors = AppColorsExtension(
    primary: const Color(0xffbb86fc),
    secondary: const Color(0xff03dac6),
    background: const Color(0xff121212),
  );
}
