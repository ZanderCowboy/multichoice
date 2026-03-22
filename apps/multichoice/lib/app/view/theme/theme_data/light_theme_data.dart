part of '../app_theme.dart';

final ThemeData _light = () {
  final defaultTheme = ThemeData.light();

  return defaultTheme.copyWith(
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _lightColors.outlinedButtonForeground,
        textStyle: TextStyle(color: _lightColors.background),
        side: BorderSide(
          color: _lightColors.outlinedButtonBorder ?? Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        minimumSize: outlinedButtonMinimumSize,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionHandleColor: Colors.grey,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: _lightColors.background,
      textColor: _lightColors.textPrimary,
      leadingAndTrailingTextStyle: TextStyle(
        color: _lightColors.textPrimary,
      ),
      iconColor: _lightColors.iconColor,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightColors.secondary;
        }

        return _lightColors.ternary?.withValues(alpha: 0.7);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightColors.primary;
        }

        return _lightColors.primaryLight?.withValues(alpha: 0.8);
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          _lightColors.textButtonForeground,
        ),
        backgroundColor: WidgetStatePropertyAll(
          _lightColors.textButtonBackground,
        ),
        textStyle: WidgetStatePropertyAll(
          _AppTypography.body2.copyWith(
            color: _lightColors.textButtonForeground,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: _lightColors.filledButtonForeground,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        minimumSize: elevatedButtonMinimumSize,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _lightColors.filledButtonBackground,
        foregroundColor: _lightColors.filledButtonForeground,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        minimumSize: elevatedButtonMinimumSize,
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: borderCircular16),
      alignment: Alignment.center,
      titleTextStyle: _AppTypography.title3,
      contentTextStyle: _AppTypography.body3,
      actionsPadding: allPadding12,
      backgroundColor: _lightColors.modalBackground,
    ),
    scaffoldBackgroundColor: _lightColors.scaffoldBackground,
    appBarTheme: AppBarTheme(
      titleTextStyle: _AppTypography.title3.copyWith(
        color: _lightColors.iconColor,
      ),
      centerTitle: true,
      backgroundColor: _lightColors.appBarBackground,
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
      labelStyle: const TextStyle(color: _AppPalette.white),
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
        foregroundColor: WidgetStatePropertyAll(_lightColors.iconColor),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        side: const WidgetStatePropertyAll(BorderSide.none),
      ),
    ),
    iconTheme: IconThemeData(
      size: 18,
      color: _lightColors.iconColor,
    ),
    extensions: [
      _lightColors,
      _lightTextTheme,
    ],
  );
}();
