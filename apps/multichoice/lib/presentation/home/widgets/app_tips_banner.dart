import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:ui_kit/ui_kit.dart';

class AppTipsBanner extends StatelessWidget {
  const AppTipsBanner({
    required this.tip,
    required this.onDismiss,
    super.key,
  });

  final AppTip tip;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final strings = _stringsForTip(context, tip);

    return DismissibleBannerBar(
      variant: BannerBarVariant.pill,
      title: strings.title,
      body: Text(
        strings.body,
        style: context.theme.appTextTheme.bodyMedium,
      ),
      onDismiss: onDismiss,
      backgroundColor: colors.primary!.withValues(alpha: 0.12),
      dismissTooltip: context.t.common.dismiss,
      leading: Icon(
        Icons.lightbulb_outline,
        color: colors.primary,
      ),
    );
  }

  ({String title, String body}) _stringsForTip(
    BuildContext context,
    AppTip tip,
  ) {
    final tips = context.t.tips;
    return switch (tip) {
      AppTip.collections => (title: tips.collectionsTitle, body: tips.collectionsBody),
      AppTip.addCollection => (title: tips.addCollectionTitle, body: tips.addCollectionBody),
      AppTip.addEntry => (title: tips.addEntryTitle, body: tips.addEntryBody),
      AppTip.entryActions => (title: tips.entryActionsTitle, body: tips.entryActionsBody),
      AppTip.editAndSearch => (title: tips.editAndSearchTitle, body: tips.editAndSearchBody),
      AppTip.drawer => (title: tips.drawerTitle, body: tips.drawerBody),
    };
  }
}
