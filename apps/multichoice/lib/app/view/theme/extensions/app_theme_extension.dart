import 'package:flutter/material.dart';
import 'package:multichoice/app/view/theme/app_theme.dart';
import 'package:theme/theme.dart';

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppTheme.lightAppColors;

  AppTextExtension get appTextTheme =>
      extension<AppTextExtension>() ?? AppTheme.lightTextTheme;
}
