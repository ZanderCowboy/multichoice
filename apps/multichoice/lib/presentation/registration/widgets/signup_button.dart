import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({
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
    final isDisabled = !enabled || isLoading || overrideLabel != null;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isDisabled ? null : onPressed,
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return CircularLoader.tiny();
    }
    if (overrideLabel != null) {
      if (overrideIcon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            overrideIcon!,
            const SizedBox(width: 8),
            Text(overrideLabel!),
          ],
        );
      }
      return Text(overrideLabel!);
    }
    return const Text('Sign Up');
  }
}
