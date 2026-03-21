import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.onPressed,
    super.key,
    this.enabled = true,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: enabled && !isLoading ? onPressed : null,
        icon: isLoading
            ? CircularLoader.tiny()
            : const Icon(Icons.g_mobiledata, size: 24),
        label: const Text('Continue with Google'),
      ),
    );
  }
}
