import 'package:flutter/material.dart';
import 'package:multichoice/app/view/theme/extensions/app_theme_extension.dart';
import 'package:theme/theme.dart';

extension ThemeGetter on BuildContext {
  /// Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);

  AppTextExtension get appTextTheme => theme.appTextTheme;

  AppColorsExtension get appColorsTheme => theme.appColors;
}
