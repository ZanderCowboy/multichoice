import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_text_extension.tailor.dart';

@TailorMixin()
class AppTextExtension extends ThemeExtension<AppTextExtension>
    with _$AppTextExtensionTailorMixin {
  AppTextExtension({
    required this.headingLarge,
    required this.headingMedium,
    required this.headingSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.subtitleLarge,
    required this.subtitleMedium,
    required this.subtitleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.denseTitle,
    required this.denseSubtitle,
    required this.hyperlink,
  });

  @override
  final TextStyle? headingLarge;
  @override
  final TextStyle? headingMedium;
  @override
  final TextStyle? headingSmall;
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
  @override
  final TextStyle? denseTitle;
  @override
  final TextStyle? denseSubtitle;
  @override
  final TextStyle? hyperlink;
}
