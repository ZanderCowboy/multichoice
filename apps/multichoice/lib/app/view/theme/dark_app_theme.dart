part of 'app_theme.dart';

final ThemeData _dark = () {
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
        foregroundColor: AppPalette.primary0,
        backgroundColor: AppPalette.white,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        textStyle: AppTypography.bodyLarge,
        minimumSize: elevatedButtonMinimumSize,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _darkAppColors.primary,
        foregroundColor: _darkAppColors.secondary,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        minimumSize: elevatedButtonMinimumSize,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(
          AppPalette.sanJuanTone2,
        ),
        backgroundColor: const WidgetStatePropertyAll(
          AppPalette.geyserLightTone1,
        ),
        textStyle: WidgetStatePropertyAll(
          AppTypography.bodyLarge.copyWith(
            color: AppPalette.sanJuanTone2,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: borderCircular12),
        ),
        minimumSize: const WidgetStatePropertyAll(
          elevatedButtonMinimumSize,
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
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
        color: AppPalette.sanJuanTone2,
      ),
      centerTitle: true,
      backgroundColor: _darkAppColors.foreground,
    ),
    cardTheme: CardThemeData(
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
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkAppColors.secondary;
        }

        return _darkAppColors.ternary?.withValues(alpha: 0.85);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkAppColors.primary;
        }

        return _darkAppColors.primaryLight?.withValues(alpha: 0.9);
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          AppPalette.sanJuanTone2,
        ),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        side: WidgetStatePropertyAll(BorderSide.none),
      ),
    ),
    iconTheme: const IconThemeData(
      size: 18,
      color: AppPalette.sanJuanTone2,
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
    extensions: [
      _darkAppColors,
      _darkTextTheme,
    ],
  );
}();
