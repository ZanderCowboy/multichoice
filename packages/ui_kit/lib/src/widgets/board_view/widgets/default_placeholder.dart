import 'package:flutter/material.dart';

/// Default gap / empty-lane placeholder shown during drag preview.
class DefaultBoardPlaceholder extends StatelessWidget {
  const DefaultBoardPlaceholder({
    super.key,
    this.width,
    this.height,
    this.message,
  });

  final double? width;
  final double? height;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.outline;

    return Container(
      width: width,
      height: height ?? 64,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.55),
          width: 2,
        ),
      ),
      child: Center(
        child: message != null
            ? Text(
                message!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.withValues(alpha: 0.8),
                ),
              )
            : Icon(
                Icons.add_circle_outline,
                size: 22,
                color: color.withValues(alpha: 0.55),
              ),
      ),
    );
  }
}
