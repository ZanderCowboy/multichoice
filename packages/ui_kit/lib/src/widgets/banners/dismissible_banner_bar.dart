import 'package:flutter/material.dart';

import '../../constants/border_constants.dart';
import '../../constants/spacing_constants.dart';

/// Visual variant for [DismissibleBannerBar].
enum BannerBarVariant {
  /// Rounded “pill” with horizontal inset padding (material banner card).
  pill,

  /// Full-width strip with an optional bottom border edge.
  flat,
}

/// Shared layout for home-style informational banners: icon, title, body,
/// optional trailing action, and dismiss control.
class DismissibleBannerBar extends StatelessWidget {
  const DismissibleBannerBar({
    required this.variant,
    required this.title,
    required this.body,
    required this.onDismiss,
    required this.backgroundColor,
    super.key,
    this.leading,
    this.trailing,
    this.bottomBorderColor,
    this.dismissIconColor,
    this.titleStyle,
  });

  final BannerBarVariant variant;
  final Widget? leading;
  final String title;
  final Widget body;
  final Widget? trailing;
  final VoidCallback onDismiss;
  final Color backgroundColor;
  final Color? bottomBorderColor;
  final Color? dismissIconColor;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        dismissIconColor ?? Theme.of(context).colorScheme.onSurfaceVariant;
    final effectiveTitleStyle =
        titleStyle ??
        Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, gap12],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: effectiveTitleStyle),
              gap4,
              body,
            ],
          ),
        ),
        if (trailing != null) ...[gap8, trailing!],
        gap8,
        IconButton(
          icon: Icon(
            Icons.close,
            color: iconColor.withValues(alpha: 0.85),
            size: 20,
          ),
          onPressed: onDismiss,
          tooltip: 'Dismiss',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );

    switch (variant) {
      case BannerBarVariant.pill:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderCircular24,
            ),
            child: row,
          ),
        );
      case BannerBarVariant.flat:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(
                color: bottomBorderColor ?? Colors.transparent,
              ),
            ),
          ),
          child: row,
        );
    }
  }
}
