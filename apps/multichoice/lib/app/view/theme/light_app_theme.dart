part of 'app_theme.dart';

final ThemeData _light = () {
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
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightAppColors.secondary;
        }

        return _lightAppColors.ternary?.withValues(alpha: 0.7);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightAppColors.primary;
        }

        return _lightAppColors.primaryLight?.withValues(alpha: 0.8);
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          _lightAppColors.black,
        ),
        backgroundColor: const WidgetStatePropertyAll(
          AppPalette.geyserLightTone1,
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
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _lightAppColors.primary,
        foregroundColor: _lightAppColors.secondary,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        minimumSize: elevatedButtonMinimumSize,
      ),
    ),
    dialogTheme: DialogThemeData(
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
        color: AppPalette.geyserTone1,
      ),
      centerTitle: true,
      backgroundColor: _lightAppColors.foreground,
    ),
    cardTheme: CardThemeData(
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
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppPalette.geyserTone1),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        side: WidgetStatePropertyAll(BorderSide.none),
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
