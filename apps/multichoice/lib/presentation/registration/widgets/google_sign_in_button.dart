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
    final isDisabled = !enabled || isLoading || overrideLabel != null;
    final showIconLayout = overrideLabel == null;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: showIconLayout
          ? OutlinedButton.icon(
              onPressed: isDisabled ? null : onPressed,
              icon: isLoading
                  ? CircularLoader.tiny()
                  : const Icon(Icons.g_mobiledata, size: 24),
              label: const Text('Continue with Google'),
            )
          : OutlinedButton(
              onPressed: null,
              child: Text(_label),
            ),
    );
  }

  String get _label => overrideLabel ?? 'Continue with Google';
}
