part of '../app_theme.dart';

final ThemeData _dark = () {
  final defaultTheme = ThemeData.dark();

  return defaultTheme.copyWith(
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkAppColors.outlinedButtonForeground,
        textStyle: AppTypography.bodyLarge,
        side: BorderSide(
          color: _darkAppColors.outlinedButtonBorder ?? Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        minimumSize: outlinedButtonMinimumSize,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: _darkAppColors.filledButtonForeground,
        backgroundColor: _darkAppColors.filledButtonBackground,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        textStyle: AppTypography.bodyLarge,
        minimumSize: elevatedButtonMinimumSize,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _darkAppColors.filledButtonBackground,
        foregroundColor: _darkAppColors.filledButtonForeground,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        minimumSize: elevatedButtonMinimumSize,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          _darkAppColors.textButtonForeground,
        ),
        backgroundColor: WidgetStatePropertyAll(
          _darkAppColors.textButtonBackground,
        ),
        textStyle: WidgetStatePropertyAll(
          AppTypography.bodyLarge.copyWith(
            color: _darkAppColors.textButtonForeground,
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
      backgroundColor: _darkAppColors.modalBackground,
    ),
    scaffoldBackgroundColor: _darkAppColors.scaffoldBackground,
    appBarTheme: AppBarTheme(
      titleTextStyle: AppTypography.titleMedium.copyWith(
        color: _darkAppColors.textPrimary,
      ),
      centerTitle: true,
      backgroundColor: _darkAppColors.appBarBackground,
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
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(_darkAppColors.iconColor),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        side: const WidgetStatePropertyAll(BorderSide.none),
      ),
    ),
    iconTheme: IconThemeData(
      size: 18,
      color: _darkAppColors.iconColor,
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
