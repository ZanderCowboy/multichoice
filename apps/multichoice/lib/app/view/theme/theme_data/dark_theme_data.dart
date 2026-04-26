part of '../app_theme.dart';

ColorScheme _darkColorScheme() =>
    ColorScheme.fromSeed(
      seedColor: _darkColors.primary!,
      brightness: Brightness.dark,
    ).copyWith(
      primary: _darkColors.primary,
      onPrimary: _darkColors.filledButtonForeground,
      secondary: _darkColors.secondary,
      onSecondary: _darkColors.white ?? _AppPalette.white,
      surface: _darkColors.scaffoldBackground,
      onSurface: _darkColors.textPrimary,
      error: _darkColors.error,
      onError: _AppPalette.white,
      surfaceContainerHighest: _darkColors.cardBackground,
    );

final ThemeData _darkThemeData = () {
  final defaultTheme = ThemeData.dark();

  return defaultTheme.copyWith(
    colorScheme: _darkColorScheme(),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkColors.outlinedButtonForeground,
        textStyle: _AppTypography.body2,
        side: BorderSide(
          color: _darkColors.outlinedButtonBorder ?? Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        minimumSize: outlinedButtonMinimumSize,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: _darkColors.filledButtonForeground,
        backgroundColor: _darkColors.filledButtonBackground,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        textStyle: _AppTypography.body2,
        minimumSize: elevatedButtonMinimumSize,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _darkColors.filledButtonBackground,
        foregroundColor: _darkColors.filledButtonForeground,
        shape: RoundedRectangleBorder(borderRadius: borderCircular12),
        minimumSize: elevatedButtonMinimumSize,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(
          _darkColors.textButtonForeground,
        ),
        backgroundColor: WidgetStatePropertyAll(
          _darkColors.textButtonBackground,
        ),
        textStyle: WidgetStatePropertyAll(
          _AppTypography.body2.copyWith(
            color: _darkColors.textButtonForeground,
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
      titleTextStyle: _AppTypography.title3,
      contentTextStyle: _AppTypography.body3,
      actionsPadding: allPadding12,
      backgroundColor: _darkColors.modalBackground,
    ),
    scaffoldBackgroundColor: _darkColors.scaffoldBackground,
    appBarTheme: AppBarTheme(
      titleTextStyle: _AppTypography.title3.copyWith(
        color: _darkColors.textPrimary,
      ),
      centerTitle: true,
      backgroundColor: _darkColors.appBarBackground,
    ),
    cardTheme: CardThemeData(
      color: _darkColors.cardBackground,
      surfaceTintColor: Colors.transparent,
      margin: vertical12horizontal4,
      elevation: 7,
      shadowColor: _darkColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: borderCircular12,
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _darkColors.secondary,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _darkColors.appBarBackground,
      contentTextStyle: _AppTypography.body2.copyWith(
        color: _darkColors.textPrimary,
      ),
      actionTextColor: _darkColors.linkColor,
      behavior: SnackBarBehavior.fixed,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: _darkColors.primary?.withValues(alpha: 0.2),
        borderRadius: borderCircular8,
      ),
      textStyle: _AppTypography.body2.copyWith(
        color: _darkColors.ternary,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: _darkColors.modalBackground,
      textStyle: _AppTypography.body2.copyWith(
        color: _darkColors.textPrimary,
      ),
      shape: RoundedRectangleBorder(borderRadius: borderCircular12),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _darkColors.background,
      selectedColor: _darkColors.secondary,
      labelStyle: _AppTypography.body2.copyWith(
        color: _darkColors.textPrimary,
      ),
      shape: RoundedRectangleBorder(borderRadius: borderCircular12),
    ),
    dividerTheme: DividerThemeData(
      color: _darkColors.textTertiary?.withValues(alpha: 0.5),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: _darkColors.scaffoldBackground,
    ),
    textTheme: defaultTheme.textTheme.copyWith(
      titleMedium: _darkTextTheme.titleMedium,
      bodyMedium: _darkTextTheme.bodyMedium,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: _darkColors.background,
      textColor: _darkColors.white,
      leadingAndTrailingTextStyle: TextStyle(
        color: _darkColors.white,
      ),
      iconColor: _darkColors.white,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkColors.foreground;
        }

        return _darkColors.ternary?.withValues(alpha: 0.85);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkColors.foreground;
        }

        return _darkColors.primaryLight?.withValues(alpha: 0.9);
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(_darkColors.iconColor),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        side: const WidgetStatePropertyAll(BorderSide.none),
      ),
    ),
    iconTheme: IconThemeData(
      size: 18,
      color: _darkColors.iconColor,
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
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionHandleColor: Colors.grey,
    ),
    extensions: [
      _darkColors,
      _darkTextTheme,
    ],
  );
}();
