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
      // drawerTheme: DrawerThemeData(

      // ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightAppColors.primary,
          side: BorderSide(color: _lightAppColors.primary ?? Colors.white),
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: _lightAppColors.secondary,
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        ),
      ),
      dialogBackgroundColor: _lightAppColors.background,
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: borderCircular16),
        alignment: Alignment.center,
        titleTextStyle: AppTypography.titleMedium,
        contentTextStyle: AppTypography.bodyMedium,
        actionsPadding: allPadding12,
      ),
      scaffoldBackgroundColor: _lightAppColors.background,
      appBarTheme: AppBarTheme(
        titleTextStyle: AppTypography.titleMedium.copyWith(
          color: AppPalette.grey.geyser,
        ),
        centerTitle: true,
        color: _lightAppColors.foreground,
      ),
      cardTheme: CardTheme(
        margin: vertical12horizontal4,
        elevation: 7,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
      ),
      textTheme: defaultTheme.textTheme.copyWith(
        titleMedium: _lightTextTheme.titleMedium,
        bodyMedium: _lightTextTheme.bodyMedium,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(AppPalette.grey.geyser),
          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
          side: const MaterialStatePropertyAll(BorderSide.none),
        ),
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: _lightAppColors.primary,
      ),
      extensions: [
        _lightAppColors,
        _lightTextTheme,
      ],
    );
  }();

  static final _lightAppColors = AppColorsExtension(
    primary: AppPalette.grey.geyser,
    primaryLight: AppPalette.grey.geyserLight,
    secondary: AppPalette.grey.sanJuan,
    secondaryLight: AppPalette.grey.sanJuanLight,
    ternary: null,
    foreground: AppPalette.grey.bigStone,
    background: AppPalette.grey.slateGray,
    white: null,
    black: null,
  );

  static final _lightTextTheme = AppTextExtension(
    body1: AppTypography.body1.copyWith(color: _lightAppColors.background),
    body2: AppTypography.body2,
    h1: null,
    titleLarge: null,
    titleMedium: AppTypography.titleMedium.copyWith(
      color: AppPalette.grey.bigStone,
    ),
    titleSmall: AppTypography.titleSmall.copyWith(
      color: AppPalette.grey.bigStone,
    ),
    subtitleLarge: null,
    subtitleMedium: null,
    subtitleSmall: null,
    bodyLarge: null,
    bodyMedium: AppTypography.bodyMedium.copyWith(
      color: AppPalette.grey.geyser,
    ),
    bodySmall: null,
  );

  static final dark = () {
    final defaultTheme = ThemeData.dark();

    return defaultTheme.copyWith(
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkAppColors.foreground,
          // backgroundColor: AppPalette.paletteTwo.slateGray,
          textStyle: AppTypography.bodyLarge,
          side: BorderSide(color: _darkAppColors.primary ?? Colors.white),
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppPalette.paletteTwo.slateGray,
          backgroundColor: AppPalette.paletteTwo.geyser,
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
          textStyle: AppTypography.bodyLarge,
        ),
      ),
      dialogBackgroundColor: _darkAppColors.background,
      dialogTheme: DialogTheme(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderCircular16),
        alignment: Alignment.center,
        titleTextStyle: AppTypography.titleMedium,
        contentTextStyle: AppTypography.bodyMedium,
        actionsPadding: allPadding12,
      ),
      scaffoldBackgroundColor: _darkAppColors.background,
      appBarTheme: AppBarTheme(
        titleTextStyle: AppTypography.titleMedium.copyWith(
          color: AppPalette.paletteTwo.sanJuan,
        ),
        centerTitle: true,
        color: _darkAppColors.foreground,
      ),
      cardTheme: CardTheme(
        margin: vertical12horizontal4,
        elevation: 7,
        shadowColor: _darkAppColors.black,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
      ),
      textTheme: defaultTheme.textTheme.copyWith(
        titleMedium: _darkTextTheme.titleMedium,
        bodyMedium: _darkTextTheme.bodyMedium,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor:
              MaterialStatePropertyAll(AppPalette.paletteTwo.sanJuan),
          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
          side: const MaterialStatePropertyAll(BorderSide.none),
        ),
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: AppPalette.paletteTwo.sanJuan,
      ),
      extensions: [
        _darkAppColors,
        _darkTextTheme,
      ],
    );
  }();

  static final _darkAppColors = AppColorsExtension(
    primary: AppPalette.paletteTwo.geyser,
    primaryLight: AppPalette.paletteTwo.geyserLight,
    secondary: AppPalette.paletteTwo.slateGray,
    secondaryLight: AppPalette.paletteTwo.slateGrayLight,
    ternary: null,
    foreground: AppPalette.paletteTwo.bigStone,
    background: AppPalette.paletteTwo.slateGray,
    white: null,
    black: AppPalette.black,
  );

  static final _darkTextTheme = AppTextExtension(
    body1: AppTypography.body1.copyWith(color: _darkAppColors.background),
    body2: AppTypography.body2,
    h1: null,
    titleLarge: null,
    titleMedium: AppTypography.titleMedium.copyWith(
      color: AppPalette.paletteTwo.sanJuan,
    ),
    titleSmall: AppTypography.titleSmall.copyWith(
      color: AppPalette.paletteTwo.sanJuan,
    ),
    subtitleLarge: null,
    subtitleMedium: null,
    subtitleSmall: null,
    bodyLarge: AppTypography.bodyLarge.copyWith(
      color: AppPalette.paletteTwo.sanJuan,
    ),
    bodyMedium: AppTypography.bodyMedium.copyWith(
      color: AppPalette.paletteTwo.sanJuan,
    ),
    bodySmall: null,
  );

  static AppColorsExtension get lightAppColors => _lightAppColors;

  static AppTextExtension get lightTextTheme => _lightTextTheme;

  static AppColorsExtension get darkAppColors => _darkAppColors;

  static AppTextExtension get darkTextTheme => _darkTextTheme;
}
