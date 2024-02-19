import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_text_extension.tailor.dart';

@TailorMixin()
class AppTextExtension extends ThemeExtension<AppTextExtension>
    with _$AppTextExtensionTailorMixin {
  AppTextExtension({
    required this.body1,
    required this.h1,
  });

  @override
  final TextStyle h1;
  @override
  final TextStyle body1;
}
