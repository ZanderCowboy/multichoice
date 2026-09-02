import 'package:flutter/material.dart';

import '../models/board_drag_models.dart';
import '../models/board_view_style.dart';

/// Builds item drag feedback only when the overlay mounts it (on drag start).
class _DeferredItemDragFeedback<T> extends StatelessWidget {
  const _DeferredItemDragFeedback({
    required this.payload,
    required this.itemBuilder,
    required this.extent,
    required this.feedbackCross,
    required this.isVertical,
    required this.style,
  });

  final ItemDragPayload<T> payload;
  final Widget Function(BuildContext context, T item, bool isDragging)
      itemBuilder;
  final double extent;
  final double feedbackCross;
  final bool isVertical;
  final BoardViewStyle style;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      elevation: style.itemDragFeedbackElevation,
      child: SizedBox(
        width: isVertical ? feedbackCross : extent,
        height: isVertical ? extent : feedbackCross,
        child: itemBuilder(context, payload.item, true),
      ),
    );
  }
}

/// Draggable wrapper for a single board item card.
class DraggableBoardItem<T> extends StatelessWidget {
  const DraggableBoardItem({
    required this.payload,
    required this.axis,
    required this.extent,
    required this.crossExtent,
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
  final double crossExtent;
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

    final feedbackCross =
        (crossExtent -
                (isVertical
                    ? style.itemDragPadding.horizontal
                    : style.itemDragPadding.vertical))
            .clamp(0.0, double.infinity);

    return Padding(
      padding: style.itemDragPadding,
      child: Draggable<ItemDragPayload<T>>(
        data: payload,
        axis: axis,
        onDragStarted: onDragStarted,
        onDragEnd: (_) => onDragEnd(),
        // Called even after this widget unmounts (preview removes the source).
        onDraggableCanceled: (velocity, offset) => onDragEnd(),
        feedback: _DeferredItemDragFeedback<T>(
          payload: payload,
          itemBuilder: itemBuilder,
          extent: extent,
          feedbackCross: feedbackCross,
          isVertical: isVertical,
          style: style,
        ),
        childWhenDragging: const SizedBox.shrink(),
        child: child,
      ),
    );
  }
}
