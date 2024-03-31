import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_text_extension.tailor.dart';

@TailorMixin()
class AppTextExtension extends ThemeExtension<AppTextExtension>
    with _$AppTextExtensionTailorMixin {
  AppTextExtension({
    required this.body1,
    required this.body2,
    required this.h1,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.subtitleLarge,
    required this.subtitleMedium,
    required this.subtitleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
  });

  @override
  final TextStyle? h1;
  @override
  final TextStyle? body1;
  @override
  final TextStyle? body2;
  @override
  final TextStyle? titleLarge;
  @override
  final TextStyle? titleMedium;
  @override
  final TextStyle? titleSmall;
  @override
  final TextStyle? subtitleLarge;
  @override
  final TextStyle? subtitleMedium;
  @override
  final TextStyle? subtitleSmall;
  @override
  final TextStyle? bodyLarge;
  @override
  final TextStyle? bodyMedium;
  @override
  final TextStyle? bodySmall;
}
