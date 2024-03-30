import 'package:flutter/material.dart';
import 'package:multichoice/utils/app_theme.dart';
import 'package:multichoice/utils/theme_extension/app_colors_extension.dart';
import 'package:multichoice/utils/theme_extension/app_text_extension.dart';

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppTheme.lightAppColors;

  AppTextExtension get appTextTheme =>
      extension<AppTextExtension>() ?? AppTheme.lightTextTheme;
}
