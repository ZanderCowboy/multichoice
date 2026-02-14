import 'package:flutter/material.dart';

/// Default placeholder for drop targets and empty lanes.
class DefaultDropPlaceholder extends StatelessWidget {
  const DefaultDropPlaceholder({
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
      height: height ?? 72,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.6),
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
                size: 24,
                color: color.withValues(alpha: 0.6),
              ),
      ),
    );
  }
}
