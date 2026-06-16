import 'package:flutter/material.dart';

import '../../constants/spacing_constants.dart';
import '../loaders/circular_loader.dart';

/// A full-width [FilledButton] that shows a loader while [isLoading] is true,
/// and can show [successLabel] (with optional [successIcon]) after an action
/// completes. The button is disabled while loading or when [successLabel] is set.
class AsyncFilledButton extends StatelessWidget {
  const AsyncFilledButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.enabled = true,
    this.isLoading = false,
    this.successLabel,
    this.successIcon,
    this.height,
    this.loadingWidget,
    this.flexSuccessLabel = false,
  });

  final VoidCallback? onPressed;
  final bool enabled;
  final bool isLoading;

  /// When non-null, replaces [label] and disables the button.
  final String? successLabel;
  final Widget? successIcon;

  final Widget? loadingWidget;

  /// Shown when not loading and [successLabel] is null.
  final Widget label;

  /// Optional fixed height.
  final double? height;

  /// When true and [successIcon] is set, the success [Text] is wrapped in
  /// [Flexible] with ellipsis for long messages.
  final bool flexSuccessLabel;

  bool get _interactionDisabled =>
      !enabled || isLoading || successLabel != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        onPressed: _interactionDisabled ? null : onPressed,
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return loadingWidget ?? CircularLoader.tiny();
    }
    if (successLabel != null) {
      if (successIcon != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              flexSuccessLabel ? MainAxisSize.max : MainAxisSize.min,
          children: [
            successIcon!,
            gap8,
            if (flexSuccessLabel)
              Flexible(
                child: Text(
                  successLabel!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              )
            else
              Text(successLabel!),
          ],
        );
      }
      return Text(successLabel!);
    }
    return label;
  }
}
