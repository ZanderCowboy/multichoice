part of '../app_theme.dart';

final _darkTextTheme = AppTextExtension(
  /// Heading
  headingLarge: _AppTypography.heading2.copyWith(
    color: _darkColors.textPrimary,
  ),
  headingMedium: _AppTypography.heading4.copyWith(
    color: _darkColors.textPrimary,
  ),
  headingSmall: _AppTypography.heading6.copyWith(
    color: _darkColors.textPrimary,
  ),

  /// Title
  titleLarge: _AppTypography.title2.copyWith(
    color: _darkColors.textPrimary,
  ),
  titleMedium: _AppTypography.title3.copyWith(
    color: _darkColors.textPrimary,
  ),
  titleSmall: _AppTypography.title4.copyWith(
    color: _darkColors.textPrimary,
  ),

  /// Subtitle
  subtitleLarge: _AppTypography.subtitle1.copyWith(
    color: _darkColors.textPrimary,
  ),
  subtitleMedium: _AppTypography.subtitle3.copyWith(
    color: _darkColors.textPrimary,
  ),
  subtitleSmall: _AppTypography.subtitle4.copyWith(
    color: _darkColors.textPrimary,
  ),

  /// Body
  bodyLarge: _AppTypography.body2.copyWith(
    color: _darkColors.textPrimary,
  ),
  bodyMedium: _AppTypography.body3.copyWith(
    color: _darkColors.textPrimary,
  ),
  bodySmall: _AppTypography.body4.copyWith(
    color: _darkColors.textPrimary,
  ),

  /// Dense Title
  denseTitle: _AppTypography.title4.copyWith(
    color: _darkColors.textPrimary,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1,
  ),
  denseSubtitle: _AppTypography.subtitle4.copyWith(
    color: _darkColors.textPrimary,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.25,
  ),
  denseBody: _AppTypography.body4.copyWith(
    color: _darkColors.textPrimary,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.25,
  ),
  denseHeading: _AppTypography.heading4.copyWith(
    color: _darkColors.textPrimary,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.25,
  ),

  /// Contrast
  contrastTitle: _AppTypography.title3.copyWith(
    color: _darkColors.primary,
    letterSpacing: 0.3,
    height: 1,
  ),
  contrastSubtitle: _AppTypography.subtitle3.copyWith(
    color: _darkColors.primary,
    letterSpacing: 0.5,
    height: 1.25,
  ),
  contrastBody: _AppTypography.body2.copyWith(
    color: _darkColors.primary,
  ),
  contrastHeading: _AppTypography.heading1.copyWith(
    color: _darkColors.primary,
  ),

  /// Assorted
  hyperlink: _AppTypography.body2.copyWith(
    color: _darkColors.textSecondary,
    decoration: TextDecoration.underline,
    decorationColor: _darkColors.primary,
    decorationThickness: 1.25,
  ),
);
