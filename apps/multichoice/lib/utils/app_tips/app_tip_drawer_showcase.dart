import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/utils/app_tips/app_tip_keys.dart';
import 'package:multichoice/utils/app_tips/app_tip_showcase.dart';

/// Drawer appearance section showcase target (started when the menu opens).
class AppTipDrawerShowcase extends StatelessWidget {
  const AppTipDrawerShowcase({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppTipShowcase(
      tip: AppTip.drawer,
      showcaseKey: appTipKeys.drawerAppearance,
      child: child,
    );
  }
}
