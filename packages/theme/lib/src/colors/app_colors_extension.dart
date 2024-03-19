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
}
