part of '../app_theme.dart';

final _lightTextTheme = AppTextExtension(
  body1: AppTypography.body1.copyWith(color: _lightAppColors.background),
  body2: AppTypography.body2,
  h1: null,
  titleLarge: null,
  titleMedium: AppTypography.titleMedium.copyWith(
    color: _lightAppColors.textPrimary,
  ),
  titleSmall: AppTypography.titleSmall.copyWith(
    color: _lightAppColors.textSecondary,
  ),
  subtitleLarge: null,
  subtitleMedium: AppTypography.subtitleMedium.copyWith(
    color: _lightAppColors.textPrimary,
  ),
  subtitleSmall: AppTypography.subtitleSmall.copyWith(
    color: _lightAppColors.textSecondary,
  ),
  bodyLarge: AppTypography.bodyLarge,
  bodyMedium: AppTypography.bodyMedium.copyWith(
    color: _lightAppColors.textSecondary,
  ),
  bodySmall: null,
  denseTitle: AppTypography.titleSmall.copyWith(
    color: _lightAppColors.textSecondary,
    fontSize: 16,
    letterSpacing: 0.3,
    height: 1,
  ),
  denseSubtitle: AppTypography.bodySmall.copyWith(
    color: _lightAppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.25,
  ),
);
