part of '../app_theme.dart';

final _lightTextTheme = AppTextExtension(
  body1: AppTypography.body1.copyWith(color: _lightAppColors.background),
  body2: AppTypography.body2,
  h1: null,
  titleLarge: null,
  titleMedium: AppTypography.titleMedium.copyWith(
    color: AppPalette.grey.bigStone,
  ),
  titleSmall: AppTypography.titleSmall.copyWith(
    color: AppPalette.grey.geyser,
  ),
  subtitleLarge: null,
  subtitleMedium: AppTypography.subtitleMedium.copyWith(
    color: AppPalette.grey.bigStone,
  ),
  subtitleSmall: AppTypography.subtitleSmall.copyWith(
    color: AppPalette.grey.geyser,
  ),
  bodyLarge: AppTypography.bodyLarge,
  bodyMedium: AppTypography.bodyMedium.copyWith(
    color: AppPalette.grey.geyser,
  ),
  bodySmall: null,
);
