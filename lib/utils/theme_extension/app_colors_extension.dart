import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_colors_extension.tailor.dart';

@TailorMixin()
class AppColorsExtension extends ThemeExtension<AppColorsExtension>
    with _$AppColorsExtensionTailorMixin {
  AppColorsExtension({
    required this.background,
    required this.primary,
    required this.secondary,
  });
  @override
  final Color background;
  @override
  final Color primary;
  @override
  final Color secondary;
}
