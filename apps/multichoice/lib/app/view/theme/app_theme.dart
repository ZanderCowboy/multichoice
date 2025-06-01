import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:multichoice/app/view/theme/app_palette.dart';
import 'package:multichoice/app/view/theme/app_typography.dart';
import 'package:multichoice/constants/export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme/theme.dart';

part 'theme_extension/_dark_app_colors.dart';
part 'theme_extension/_dark_text_theme.dart';
part 'theme_extension/_light_app_colors.dart';
part 'theme_extension/_light_text_theme.dart';

class AppTheme with ChangeNotifier {
  final _prefs = coreSl<SharedPreferences>();

  ThemeMode _themeMode = ThemeMode.system;

  bool isDarkTheme() =>
      _prefs.getBool('isDarkMode') ?? _themeMode == ThemeMode.dark;

  ThemeMode get themeMode => isDarkTheme() ? ThemeMode.dark : ThemeMode.light;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;

    final isDarkMode = themeMode == ThemeMode.dark;
    _prefs.setBool('isDarkMode', isDarkMode);

    notifyListeners();
  }

  static final light = () {
    final defaultTheme = ThemeData.light();

    return defaultTheme.copyWith(
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightAppColors.primary,
          textStyle: TextStyle(color: _lightAppColors.background),
          side: BorderSide(color: _lightAppColors.primary ?? Colors.white),
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
          minimumSize: outlinedButtonMinimumSize,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionHandleColor: Colors.grey,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: _lightAppColors.background,
        textColor: _lightAppColors.primary,
        leadingAndTrailingTextStyle: TextStyle(
          color: _lightAppColors.primary,
        ),
        iconColor: _lightAppColors.primary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(
            _lightAppColors.black,
          ),
          backgroundColor: WidgetStatePropertyAll(
            AppPalette.grey.geyserLight,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: _lightAppColors.secondary,
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
          minimumSize: elevatedButtonMinimumSize,
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: borderCircular16),
        alignment: Alignment.center,
        titleTextStyle: AppTypography.titleMedium,
        contentTextStyle: AppTypography.bodyMedium,
        actionsPadding: allPadding12,
        backgroundColor: _lightAppColors.secondary,
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
        titleSmall: _lightTextTheme.titleSmall,
        bodyMedium: _lightTextTheme.bodyMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: AppPalette.white),
        hintStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        floatingLabelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderCircular8,
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderCircular8,
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(AppPalette.grey.geyser),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          side: const WidgetStatePropertyAll(BorderSide.none),
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

  static final dark = () {
    final defaultTheme = ThemeData.dark();

    return defaultTheme.copyWith(
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkAppColors.white,
          textStyle: AppTypography.bodyLarge,
          side: BorderSide(
            color: _darkAppColors.white ?? Colors.white,
          ),
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
          minimumSize: outlinedButtonMinimumSize,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppPalette.paletteTwo.primary0,
          backgroundColor: AppPalette.white,
          shape: RoundedRectangleBorder(borderRadius: borderCircular12),
          textStyle: AppTypography.bodyLarge,
          minimumSize: elevatedButtonMinimumSize,
        ),
      ),
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
        shape: RoundedRectangleBorder(
          borderRadius: borderCircular12,
        ),
      ),
      textTheme: defaultTheme.textTheme.copyWith(
        titleMedium: _darkTextTheme.titleMedium,
        bodyMedium: _darkTextTheme.bodyMedium,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: _darkAppColors.background,
        textColor: _darkAppColors.white,
        leadingAndTrailingTextStyle: TextStyle(
          color: _darkAppColors.white,
        ),
        iconColor: _darkAppColors.white,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor:
              WidgetStatePropertyAll(AppPalette.paletteTwo.sanJuan),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          side: const WidgetStatePropertyAll(BorderSide.none),
        ),
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: AppPalette.paletteTwo.sanJuan,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: AppPalette.white),
        hintStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        floatingLabelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderCircular8,
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderCircular8,
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionHandleColor: Colors.grey,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            AppPalette.grey.geyserLight,
          ),
        ),
      ),
      extensions: [
        _darkAppColors,
        _darkTextTheme,
      ],
    );
  }();

  static AppColorsExtension get lightAppColors => _lightAppColors;

  static AppTextExtension get lightTextTheme => _lightTextTheme;

  static AppColorsExtension get darkAppColors => _darkAppColors;

  static AppTextExtension get darkTextTheme => _darkTextTheme;
}
