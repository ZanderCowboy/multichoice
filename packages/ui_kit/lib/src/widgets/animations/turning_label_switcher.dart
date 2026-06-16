import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Switches between two [Widget]s with a "turning" animation.
///
/// Intended for small inline labels like auth CTA buttons.
class TurningLabelSwitcher extends StatelessWidget {
  const TurningLabelSwitcher({
    super.key,
    required this.value,
    required this.primaryChild,
    required this.secondaryChild,
    this.duration = const Duration(milliseconds: 420),
  });

  final bool value;
  final Widget primaryChild;
  final Widget secondaryChild;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final child = value
        ? KeyedSubtree(
            key: const ValueKey<String>('primary'),
            child: primaryChild,
          )
        : KeyedSubtree(
            key: const ValueKey<String>('secondary'),
            child: secondaryChild,
          );

    return AnimatedSwitcher(
      duration: duration,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.center,
        children: [...previousChildren, ?currentChild],
      ),
      transitionBuilder: (switchedChild, animation) {
        // When `animation` goes 0 -> 1, we rotate from 90deg -> 0deg.
        // For the outgoing child (animation 1 -> 0), this reverses the motion,
        // producing a turning effect.
        // Keep some opacity during the transition to avoid the "blank" moment.
        final angle = (math.pi / 3) * (1 - animation.value);
        final scaleFactor = 0.88 + (1.0 - 0.88) * animation.value;
        final opacity = 0.4 + 0.6 * animation.value;

        return Opacity(
          opacity: opacity,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Adds perspective for a 3D "turn".
              ..rotateY(angle)
              ..multiply(
                Matrix4.diagonal3Values(
                  scaleFactor,
                  scaleFactor,
                  scaleFactor,
                ),
              ),
            child: switchedChild,
          ),
        );
      },
      child: child,
    );
  }
}
