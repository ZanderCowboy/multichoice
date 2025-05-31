part of '../app_theme.dart';

final _darkTextTheme = AppTextExtension(
  body1: AppTypography.body1.copyWith(color: _darkAppColors.background),
  body2: AppTypography.body2,
  h1: null,
  titleLarge: null,
  titleMedium: AppTypography.titleMedium.copyWith(
    color: AppPalette.paletteTwo.geyser,
  ),
  titleSmall: AppTypography.titleSmall.copyWith(
    color: AppPalette.paletteTwo.primary5,
  ),
  subtitleLarge: null,
  subtitleMedium: AppTypography.subtitleMedium.copyWith(
    color: AppPalette.paletteTwo.geyser,
  ),
  subtitleSmall: AppTypography.subtitleMedium.copyWith(
    color: AppPalette.paletteTwo.primary5,
  ),
  bodyLarge: AppTypography.bodyLarge.copyWith(
    color: AppPalette.paletteTwo.primary5,
  ),
  bodyMedium: AppTypography.bodyMedium.copyWith(
    color: AppPalette.paletteTwo.geyser,
  ),
  bodySmall: null,
);
