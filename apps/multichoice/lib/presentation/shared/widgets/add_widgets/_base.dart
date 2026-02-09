import 'package:flutter/material.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

part 'entry.dart';
part 'tab.dart';

class _BaseCard extends StatelessWidget {
  const _BaseCard({
    required this.semanticLabel,
    this.elevation,
    this.color,
    this.shape,
    this.child,
    this.icon,
    this.padding,
    this.margin,
    this.iconSize,
    this.onPressed,
  }) : assert(
          (child != null) || (icon != null),
          'Either child or icon must be non-null',
        );

  final String semanticLabel;
  final double? elevation;
  final Color? color;
  final ShapeBorder? shape;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? iconSize;
  final VoidCallback? onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Card(
        elevation: elevation,
        surfaceTintColor: Colors.transparent,
        margin: margin,
        color: color,
        shape: shape,
        child: child ??
            Padding(
              padding: padding ?? allPadding6,
              child: IconButton(
                icon: icon ?? const Icon(Icons.not_interested_rounded),
                iconSize: iconSize ?? 10,
                onPressed: onPressed,
              ),
            ),
      ),
    );
  }
}
