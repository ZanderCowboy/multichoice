part of '../app_theme.dart';

final _darkTextTheme = AppTextExtension(
  body1: AppTypography.body1.copyWith(color: _darkAppColors.background),
  body2: AppTypography.body2,
  h1: null,
  titleLarge: null,
  titleMedium: AppTypography.titleMedium.copyWith(
    color: AppPalette.geyserTone2,
  ),
  titleSmall: AppTypography.titleSmall.copyWith(
    color: AppPalette.primary5,
  ),
  subtitleLarge: null,
  subtitleMedium: AppTypography.subtitleMedium.copyWith(
    color: AppPalette.geyserTone2,
  ),
  subtitleSmall: AppTypography.subtitleMedium.copyWith(
    color: AppPalette.primary5,
  ),
  bodyLarge: AppTypography.bodyLarge.copyWith(
    color: AppPalette.primary5,
  ),
  bodyMedium: AppTypography.bodyMedium.copyWith(
    color: AppPalette.geyserTone2,
  ),
  bodySmall: null,
  denseTitle: AppTypography.titleSmall.copyWith(
    color: AppPalette.primary5,
    fontSize: 16,
    letterSpacing: 0.3,
    height: 1,
  ),
  denseSubtitle: AppTypography.bodySmall.copyWith(
    color: AppPalette.primary5,
    letterSpacing: 0.5,
    height: 1.25,
  ),
);
