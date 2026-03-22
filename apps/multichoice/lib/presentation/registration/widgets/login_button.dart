import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    required this.onPressed,
    super.key,
    this.enabled = true,
    this.isLoading = false,
    this.overrideLabel,
    this.overrideIcon,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final String? overrideLabel;
  final Widget? overrideIcon;

  @override
  Widget build(BuildContext context) {
    return AsyncFilledButton(
      onPressed: onPressed,
      enabled: enabled,
      isLoading: isLoading,
      successLabel: overrideLabel,
      successIcon: overrideIcon,
      height: 52,
      label: const Text('Sign In'),
    );
  }
}
