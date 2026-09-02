import 'package:flutter/material.dart';

import '../models/board_drag_models.dart';
import '../models/board_view_style.dart';

/// Wraps [builder] so finger feedback is built only when the drag overlay mounts.
class _DeferredLaneDragFeedback extends StatelessWidget {
  const _DeferredLaneDragFeedback({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => builder(context);
}

/// Drag handle for reordering a collection lane via its header.
class BoardLaneDragHandle extends StatelessWidget {
  const BoardLaneDragHandle({
    required this.laneId,
    required this.fromIndex,
    required this.isVertical,
    required this.onDragStarted,
    required this.onDragEnded,
    required this.style,
    required this.feedbackBuilder,
    this.allowFreeDragAxis = false,
    super.key,
  });

  final String laneId;
  final int fromIndex;
  final bool isVertical;
  final void Function(LaneDragPayload payload) onDragStarted;
  final VoidCallback onDragEnded;
  final BoardViewStyle style;
  final bool allowFreeDragAxis;

  /// Compact chrome under the finger. Built lazily when the drag starts.
  final WidgetBuilder feedbackBuilder;

  @override
  Widget build(BuildContext context) {
    final payload = LaneDragPayload(laneId: laneId, fromIndex: fromIndex);
    final scheme = Theme.of(context).colorScheme;

    return Draggable<LaneDragPayload>(
      data: payload,
      axis: allowFreeDragAxis
          ? null
          : (isVertical ? Axis.horizontal : Axis.vertical),
      onDragStarted: () => onDragStarted(payload),
      onDragEnd: (_) => onDragEnded(),
      // Called even after this widget unmounts (e.g. if the lane is removed).
      onDraggableCanceled: (velocity, offset) => onDragEnded(),
      feedback: Material(
        elevation: style.dragHandleFeedbackElevation,
        borderRadius: BorderRadius.circular(style.dragHandleFeedbackRadius),
        child: Container(
          padding: style.dragHandleFeedbackPadding,
          color: style.dragHandleFeedbackColor ??
              scheme.surfaceContainerHighest,
          child: _DeferredLaneDragFeedback(builder: feedbackBuilder),
        ),
      ),
      childWhenDragging: const SizedBox.shrink(),
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Icon(
          Icons.drag_indicator,
          size: style.dragHandleIconSize,
          color: style.dragHandleIconColor ?? scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
