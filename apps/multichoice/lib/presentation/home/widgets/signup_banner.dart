import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

/// Single carousel page: sign up CTA for guests on the home screen.
class SignupBannerPage extends StatelessWidget {
  const SignupBannerPage({
    required this.usePillStyle,
    required this.onSignUpTap,
    required this.onDismiss,
    super.key,
  });

  final bool usePillStyle;
  final VoidCallback onSignUpTap;
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
          Icons.person_add_outlined,
          color: context.theme.appColors.iconColor,
          size: 20,
        ),
        title: 'Sign up for Multichoice',
        titleStyle: context.appTextTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
        body: Text(
          'Create a free account to sync and keep your collections safe.',
          style: context.appTextTheme.bodySmall?.copyWith(
            color: (titleColor ?? Theme.of(context).colorScheme.onSurface)
                .withValues(alpha: 0.9),
          ),
        ),
        trailing: OutlinedButton(
          onPressed: onSignUpTap,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Sign up'),
        ),
        onDismiss: onDismiss,
        backgroundColor: backgroundColor,
        bottomBorderColor: bottomBorder,
        dismissIconColor: titleColor,
      ),
    );
  }
}
