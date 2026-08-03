import 'package:flutter/material.dart';

import '../models/board_drag_models.dart';
import '../models/board_view_style.dart';

/// Draggable wrapper for a single board item card.
class DraggableBoardItem<T> extends StatelessWidget {
  const DraggableBoardItem({
    required this.payload,
    required this.axis,
    required this.extent,
    required this.isVertical,
    required this.dragEnabled,
    required this.itemBuilder,
    required this.onDragStarted,
    required this.onDragEnd,
    required this.style,
    super.key,
  });

  final ItemDragPayload<T> payload;
  final Axis? axis;
  final double extent;
  final bool isVertical;
  final bool dragEnabled;
  final Widget Function(BuildContext context, T item, bool isDragging)
  itemBuilder;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnd;
  final BoardViewStyle style;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      width: isVertical ? double.infinity : extent,
      height: isVertical ? extent : double.infinity,
      child: itemBuilder(context, payload.item, false),
    );

    if (!dragEnabled) {
      return Padding(padding: style.itemDragPadding, child: child);
    }

    return Padding(
      padding: style.itemDragPadding,
      child: Draggable<ItemDragPayload<T>>(
        data: payload,
        axis: axis,
        onDragStarted: onDragStarted,
        onDragEnd: (_) => onDragEnd(),
        // Called even after this widget unmounts (preview removes the source).
        onDraggableCanceled: (velocity, offset) => onDragEnd(),
        feedback: Material(
          type: MaterialType.transparency,
          elevation: style.itemDragFeedbackElevation,
          child: SizedBox(
            width: isVertical ? style.itemDragFeedbackCrossExtent : extent,
            height: isVertical ? extent : style.itemDragFeedbackAlongExtent,
            child: itemBuilder(context, payload.item, true),
          ),
        ),
        childWhenDragging: const SizedBox.shrink(),
        child: child,
      ),
    );
  }
}
