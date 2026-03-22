import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.onPressed,
    super.key,
    this.enabled = true,
    this.isLoading = false,
    this.overrideLabel,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final String? overrideLabel;

  @override
  Widget build(BuildContext context) {
    return AsyncOutlinedButton(
      onPressed: onPressed,
      enabled: enabled,
      isLoading: isLoading,
      successLabel: overrideLabel,
      icon: const Icon(Icons.g_mobiledata, size: 24),
      label: const Text('Continue with Google'),
    );
  }
}
