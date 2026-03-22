part of '../app_theme.dart';

final _lightTextTheme = AppTextExtension(
  /// Heading
  headingLarge: _AppTypography.heading2.copyWith(
    color: _lightColors.textSecondary,
  ),
  headingMedium: _AppTypography.heading4.copyWith(
    color: _lightColors.textSecondary,
  ),
  headingSmall: _AppTypography.heading6.copyWith(
    color: _lightColors.textSecondary,
  ),

  /// Title
  titleLarge: _AppTypography.title2.copyWith(
    color: _lightColors.textSecondary,
  ),
  titleMedium: _AppTypography.title3.copyWith(
    color: _lightColors.textSecondary,
  ),
  titleSmall: _AppTypography.title4.copyWith(
    color: _lightColors.textSecondary,
  ),

  /// Subtitle
  subtitleLarge: _AppTypography.subtitle2.copyWith(
    color: _lightColors.textSecondary,
  ),
  subtitleMedium: _AppTypography.subtitle3.copyWith(
    color: _lightColors.textSecondary,
  ),
  subtitleSmall: _AppTypography.subtitle4.copyWith(
    color: _lightColors.textSecondary,
  ),

  /// Body
  bodyLarge: _AppTypography.body2.copyWith(
    color: _lightColors.textSecondary,
  ),
  bodyMedium: _AppTypography.body3.copyWith(
    color: _lightColors.textSecondary,
  ),
  bodySmall: _AppTypography.body4.copyWith(
    color: _lightColors.textSecondary,
  ),

  /// Dense Title
  denseTitle: _AppTypography.title4.copyWith(
    color: _lightColors.textSecondary,
    fontSize: 16,
    letterSpacing: 0.3,
    height: 1,
  ),

  /// Dense Subtitle
  denseSubtitle: _AppTypography.body4.copyWith(
    color: _lightColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.25,
  ),

  /// Assorted
  hyperlink: _AppTypography.body2.copyWith(
    color: _lightColors.textTertiary,
  ),
);
