import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_colors_extension.tailor.dart';

@TailorMixin()
class AppColorsExtension extends ThemeExtension<AppColorsExtension>
    with _$AppColorsExtensionTailorMixin {
  AppColorsExtension({
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryLight,
    required this.ternary,
    required this.foreground,
    required this.background,
    required this.white,
    required this.black,
    required this.error,
    required this.success,
    required this.enabled,
    required this.disabled,
    required this.filledButtonBackground,
    required this.filledButtonForeground,
    required this.outlinedButtonForeground,
    required this.outlinedButtonBorder,
    required this.textButtonForeground,
    required this.textButtonBackground,
    required this.scaffoldBackground,
    required this.cardBackground,
    required this.modalBackground,
    required this.appBarBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconColor,
    required this.linkColor,
    required this.accent,
  });

  @override
  final Color? primary;
  @override
  final Color? primaryLight;
  @override
  final Color? secondary;
  @override
  final Color? secondaryLight;
  @override
  final Color? ternary;
  @override
  final Color? foreground;
  @override
  final Color? background;
  @override
  final Color? white;
  @override
  final Color? black;
  @override
  final Color? error;
  @override
  final Color? success;
  @override
  final Color? enabled;
  @override
  final Color? disabled;

  /// Semantic: filled button background
  @override
  final Color? filledButtonBackground;

  /// Semantic: filled button foreground (text/icon)
  @override
  final Color? filledButtonForeground;

  /// Semantic: outlined button foreground
  @override
  final Color? outlinedButtonForeground;

  /// Semantic: outlined button border
  @override
  final Color? outlinedButtonBorder;

  /// Semantic: text button foreground
  @override
  final Color? textButtonForeground;

  /// Semantic: text button background
  @override
  final Color? textButtonBackground;

  /// Semantic: scaffold background
  @override
  final Color? scaffoldBackground;

  /// Semantic: card background
  @override
  final Color? cardBackground;

  /// Semantic: modal/dialog background
  @override
  final Color? modalBackground;

  /// Semantic: app bar background
  @override
  final Color? appBarBackground;

  /// Semantic: high-emphasis text
  @override
  final Color? textPrimary;

  /// Semantic: body text
  @override
  final Color? textSecondary;

  /// Semantic: muted/hint text
  @override
  final Color? textTertiary;

  /// Semantic: icon color
  @override
  final Color? iconColor;

  /// Semantic: link text (e.g. "Sign Up", "Forgot Password")
  @override
  final Color? linkColor;

  /// Semantic: accent/brand highlight
  @override
  final Color? accent;
}
