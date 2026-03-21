import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
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
      child: FilledButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        child: isLoading ? CircularLoader.tiny() : const Text('Sign In'),
      ),
    );
  }
}
