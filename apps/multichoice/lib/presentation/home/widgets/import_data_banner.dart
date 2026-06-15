import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:ui_kit/ui_kit.dart';

/// Single carousel page: prompts users to import data when they have no collections.
class ImportDataBannerPage extends StatelessWidget {
  const ImportDataBannerPage({
    required this.usePillStyle,
    required this.onImportTap,
    required this.onDismiss,
    super.key,
  });

  final bool usePillStyle;
  final VoidCallback onImportTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final primaryLight = context.theme.appColors.primaryLight;
    final backgroundColor =
        primaryLight?.withValues(alpha: 0.15) ??
        Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35);
    final bottomBorder =
        primaryLight?.withValues(alpha: 0.3) ?? Colors.transparent;
    final titleColor = context.theme.appColors.textPrimary;

    return Align(
      child: DismissibleBannerBar(
        variant: usePillStyle ? BannerBarVariant.pill : BannerBarVariant.flat,
        leading: Icon(
          Icons.info_outline,
          color: context.theme.appColors.iconColor,
          size: 20,
        ),
        title: usePillStyle
            ? context.t.home.noCollectionsYetQuestion
            : context.t.home.noCollectionsYet,
        titleStyle: context.appTextTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
        body: GestureDetector(
          onTap: onImportTap,
          child: Text(
            context.t.home.importDataOrCreate,
            style: context.appTextTheme.denseSubtitle!.copyWith(
              color: context.theme.appColors.linkColor,
              decoration: TextDecoration.underline,
              fontWeight: usePillStyle ? FontWeight.w600 : null,
            ),
          ),
        ),
        dismissTooltip: context.t.common.dismiss,
        onDismiss: onDismiss,
        backgroundColor: backgroundColor,
        bottomBorderColor: bottomBorder,
        dismissIconColor: titleColor,
      ),
    );
  }
}
