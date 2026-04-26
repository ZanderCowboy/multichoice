import 'package:flutter/material.dart';

import '../loaders/circular_loader.dart';

/// A full-width [OutlinedButton] that shows a loader in the icon slot while
/// [isLoading] is true, and can show [successLabel] (replacing the icon+label
/// layout) after an action completes. The button is disabled while loading or
/// when [successLabel] is set.
class AsyncOutlinedButton extends StatelessWidget {
  const AsyncOutlinedButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.enabled = true,
    this.isLoading = false,
    this.successLabel,
    this.icon,
    this.height = 52,
  });

  final VoidCallback? onPressed;
  final bool enabled;
  final bool isLoading;

  /// When non-null, replaces [label] / [icon] layout and disables the button.
  final String? successLabel;

  /// Leading icon when not loading and [successLabel] is null.
  final Widget? icon;

  /// Default label (e.g. "Continue with Google").
  final Widget label;

  final double? height;

  bool get _interactionDisabled =>
      !enabled || isLoading || successLabel != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: successLabel == null
          ? OutlinedButton.icon(
              onPressed: _interactionDisabled ? null : onPressed,
              icon: isLoading ? CircularLoader.tiny() : icon,
              label: label,
            )
          : OutlinedButton(onPressed: null, child: Text(successLabel!)),
    );
  }
}
