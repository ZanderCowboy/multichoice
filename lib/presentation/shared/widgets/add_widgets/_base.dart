import 'package:flutter/material.dart';
import 'package:multichoice/constants/export_constants.dart';

part 'entry.dart';
part 'tab.dart';

class _BaseCard extends StatelessWidget {
  const _BaseCard({
    required this.semanticLabel,
    this.elevation,
    this.color,
    this.shape,
    this.child,
    this.padding,
    this.iconSize,
    this.icon,
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
  final double? iconSize;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Card(
        elevation: elevation,
        color: color,
        shape: shape,
        child: child ??
            Padding(
              padding: padding ?? allPadding6,
              child: IconButton(
                iconSize: iconSize ?? 10,
                onPressed: null,
                icon: icon ?? const Icon(Icons.not_interested_rounded),
              ),
            ),
      ),
    );
  }
}
