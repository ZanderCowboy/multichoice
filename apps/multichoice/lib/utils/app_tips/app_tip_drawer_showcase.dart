import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/utils/app_tips/app_tip_keys.dart';
import 'package:multichoice/utils/app_tips/app_tip_showcase.dart';

/// Drawer-only showcase target shown after the user opens the menu.
class AppTipDrawerShowcase extends StatelessWidget {
  const AppTipDrawerShowcase({
    required this.isDrawerOpen,
    required this.child,
    super.key,
  });

  final bool isDrawerOpen;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isDrawerOpen) {
      return child;
    }

    return AppTipShowcase(
      tip: AppTip.drawer,
      showcaseKey: appTipKeys.drawerAppearance,
      child: child,
    );
  }
}
