part of '../app_theme.dart';

final _lightTextTheme = AppTextExtension(
  body1: AppTypography.body1.copyWith(color: _lightAppColors.background),
  body2: AppTypography.body2,
  h1: null,
  titleLarge: null,
  titleMedium: AppTypography.titleMedium.copyWith(
    color: AppPalette.bigStoneTone1,
  ),
  titleSmall: AppTypography.titleSmall.copyWith(
    color: AppPalette.geyserTone1,
  ),
  subtitleLarge: null,
  subtitleMedium: AppTypography.subtitleMedium.copyWith(
    color: AppPalette.bigStoneTone1,
  ),
  subtitleSmall: AppTypography.subtitleSmall.copyWith(
    color: AppPalette.geyserTone1,
  ),
  bodyLarge: AppTypography.bodyLarge,
  bodyMedium: AppTypography.bodyMedium.copyWith(
    color: AppPalette.geyserTone1,
  ),
  bodySmall: null,
);
