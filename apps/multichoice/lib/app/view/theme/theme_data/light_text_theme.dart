part of '../app_theme.dart';

final _lightTextTheme = AppTextExtension(
  /// Heading
  headingLarge: _AppTypography.heading2.copyWith(
    color: _lightColors.textPrimary,
  ),
  headingMedium: _AppTypography.heading4.copyWith(
    color: _lightColors.textPrimary,
  ),
  headingSmall: _AppTypography.heading6.copyWith(
    color: _lightColors.textPrimary,
  ),

  /// Title
  titleLarge: _AppTypography.title2.copyWith(
    color: _lightColors.textPrimary,
  ),
  titleMedium: _AppTypography.title3.copyWith(
    color: _lightColors.textPrimary,
  ),
  titleSmall: _AppTypography.title4.copyWith(
    color: _lightColors.textPrimary,
  ),

  /// Subtitle
  subtitleLarge: _AppTypography.subtitle2.copyWith(
    color: _lightColors.textPrimary,
  ),
  subtitleMedium: _AppTypography.subtitle3.copyWith(
    color: _lightColors.textPrimary,
  ),
  subtitleSmall: _AppTypography.subtitle4.copyWith(
    color: _lightColors.textPrimary,
  ),

  /// Body
  bodyLarge: _AppTypography.body2.copyWith(
    color: _lightColors.textPrimary,
  ),
  bodyMedium: _AppTypography.body3.copyWith(
    color: _lightColors.textPrimary,
  ),
  bodySmall: _AppTypography.body4.copyWith(
    color: _lightColors.textPrimary,
  ),

  /// Dense
  denseTitle: _AppTypography.title4.copyWith(
    color: _lightColors.textPrimary,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1,
  ),
  denseSubtitle: _AppTypography.subtitle4.copyWith(
    color: _lightColors.textPrimary,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.25,
  ),
  denseBody: _AppTypography.body4.copyWith(
    color: _lightColors.textPrimary,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.25,
  ),
  denseHeading: _AppTypography.heading4.copyWith(
    color: _lightColors.textPrimary,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.25,
  ),

  /// Contrast
  contrastTitle: _AppTypography.title3.copyWith(
    color: _lightColors.textSecondary,
    letterSpacing: 0.3,
    height: 1,
  ),
  contrastSubtitle: _AppTypography.subtitle3.copyWith(
    color: _lightColors.textSecondary,
    letterSpacing: 0.3,
    height: 1,
  ),
  contrastBody: _AppTypography.body2.copyWith(
    color: _lightColors.textSecondary,
  ),
  contrastHeading: _AppTypography.heading1.copyWith(
    color: _lightColors.textSecondary,
  ),

  /// Assorted
  hyperlink: _AppTypography.body2.copyWith(
    color: _lightColors.textSecondary,
    decoration: TextDecoration.underline,
    decorationColor: _lightColors.primary,
    decorationThickness: 1.25,
  ),
);
