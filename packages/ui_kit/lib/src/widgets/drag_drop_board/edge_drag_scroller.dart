import 'package:flutter/material.dart';

/// Triggers auto-scroll when a drag position is near the edges of [scrollable].
class EdgeDragScroller {
  EdgeDragScroller({
    required this.scrollable,
    this.velocityScalar = 0.5,
  });

  final ScrollableState scrollable;
  final double velocityScalar;

  EdgeDraggingAutoScroller? _autoScroller;
  bool _isDragging = false;

  void onDragStart() {
    _isDragging = true;
    _autoScroller ??= EdgeDraggingAutoScroller(
      scrollable,
      velocityScalar: velocityScalar,
    );
  }

  void onDragUpdate(Offset globalPosition) {
    if (!_isDragging) return;

    final rect = Rect.fromLTWH(
      globalPosition.dx - 1,
      globalPosition.dy - 1,
      2,
      2,
    );
    _autoScroller?.startAutoScrollIfNecessary(rect);
  }

  void onDragEnd() {
    _isDragging = false;
    _autoScroller?.stopAutoScroll();
  }
}
