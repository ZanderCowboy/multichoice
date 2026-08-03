import 'package:flutter/material.dart';

import '../enums/board_scroll_indicator.dart';
import '../models/board_view_style.dart';
import 'board_scroll_arrows.dart';
import 'board_scroll_thumb.dart';

/// Wraps a scrollable child with either a thumb or bidirectional arrows.
class BoardScrollChrome extends StatelessWidget {
  const BoardScrollChrome({
    required this.controller,
    required this.scrollbarOrientation,
    required this.indicator,
    required this.style,
    required this.child,
    super.key,
    this.trackInset,
  });

  final ScrollController controller;
  final ScrollbarOrientation scrollbarOrientation;
  final BoardScrollIndicator indicator;
  final BoardViewStyle style;
  final Widget child;
  final double? trackInset;

  @override
  Widget build(BuildContext context) {
    final inset = trackInset ?? style.scrollThumbEdgePadding;
    return switch (indicator) {
      BoardScrollIndicator.thumb => BoardScrollThumb(
          controller: controller,
          scrollbarOrientation: scrollbarOrientation,
          style: style,
          trackInset: inset,
          child: child,
        ),
      BoardScrollIndicator.arrows => BoardScrollArrows(
          controller: controller,
          scrollbarOrientation: scrollbarOrientation,
          style: style,
          child: child,
        ),
    };
  }
}
