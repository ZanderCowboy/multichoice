import 'package:flutter/material.dart';
import 'package:multichoice/app/view/theme/app_palette.dart';
import 'package:multichoice/app/view/theme/app_typography.dart';
import 'package:multichoice/constants/export_constants.dart';
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
      scaffoldBackgroundColor: AppPalette.grey.slateGray,
      appBarTheme: AppBarTheme(
        titleTextStyle: const TextStyle(
          color: AppPalette.imperialRed,
        ),
        centerTitle: true,
        color: AppPalette.grey.bigStone,
      ),
      cardTheme: CardTheme(
        elevation: 5,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: circularBorder12),
        color: const Color.fromARGB(255, 101, 160, 189),
      ),
      textTheme: defaultTheme.textTheme.copyWith(
        titleMedium: AppTypography.titleMedium.copyWith(
          color: AppPalette.grey.bigStone,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppPalette.bodyText.medium,
        ),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStatePropertyAll(
            EdgeInsets.zero,
          ),
          side: MaterialStatePropertyAll(BorderSide.none),
        ),
      ),
      iconTheme: IconThemeData(
        size: 16,
        color: AppPalette.grey.bigStone,
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
    body2: AppTypography.body2,
    // body1: null,
    // h1: AppTypography.h1.copyWith(color: Colors.black),
    h1: null,
    titleLarge: null,
    titleMedium: AppTypography.titleMedium.copyWith(
      color: AppPalette.grey.bigStone,
    ),
    titleSmall: null,
    subtitleLarge: null,
    subtitleMedium: null,
    subtitleSmall: null,
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
