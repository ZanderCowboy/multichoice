part of '../app_theme.dart';

ColorScheme _lightColorScheme() =>
    ColorScheme.fromSeed(seedColor: _lightColors.primary!).copyWith(
      primary: _lightColors.primary,
      onPrimary: _lightColors.filledButtonForeground,
      secondary: _lightColors.secondary,
      onSecondary: _lightColors.white ?? _AppPalette.white,
      surface: _lightColors.scaffoldBackground,
      onSurface: _lightColors.textPrimary,
      error: _lightColors.error,
      onError: _AppPalette.white,
      surfaceContainerHighest: _lightColors.cardBackground,
    );

final ThemeData _light = () {
  final defaultTheme = ThemeData.light();

  return defaultTheme.copyWith(
    colorScheme: _lightColorScheme(),
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
        backgroundColor: _lightColors.filledButtonBackground,
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
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(_lightColors.iconColor),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        side: const WidgetStatePropertyAll(BorderSide.none),
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

        return _lightColors.primary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightColors.foreground;
        }

        return _lightColors.primary;
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    dialogTheme: DialogThemeData(
      surfaceTintColor: Colors.transparent,
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
      color: _lightColors.cardBackground,
      surfaceTintColor: Colors.transparent,
      margin: vertical12horizontal4,
      elevation: 7,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: borderCircular12),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _lightColors.primary,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _lightColors.appBarBackground,
      contentTextStyle: _AppTypography.body2.copyWith(
        color: _lightColors.iconColor,
      ),
      actionTextColor: _lightColors.linkColor,
      behavior: SnackBarBehavior.fixed,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: _lightColors.primaryLight,
        borderRadius: borderCircular8,
      ),
      textStyle: _AppTypography.body2.copyWith(
        color: _lightColors.ternary,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: _lightColors.modalBackground,
      textStyle: _AppTypography.body2.copyWith(
        color: _lightColors.textPrimary,
      ),
      shape: RoundedRectangleBorder(borderRadius: borderCircular12),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _lightColors.background,
      selectedColor: _lightColors.secondary,
      labelStyle: _AppTypography.body2.copyWith(
        color: _lightColors.textPrimary,
      ),
      shape: RoundedRectangleBorder(borderRadius: borderCircular12),
    ),
    dividerTheme: DividerThemeData(
      color: _lightColors.textTertiary?.withValues(alpha: 0.5),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: _lightColors.scaffoldBackground,
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
