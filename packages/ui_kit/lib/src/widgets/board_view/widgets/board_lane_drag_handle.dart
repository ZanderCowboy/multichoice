import 'package:flutter/material.dart';

import '../models/board_drag_models.dart';
import '../models/board_view_style.dart';

/// Drag handle for reordering a collection lane via its header.
class BoardLaneDragHandle extends StatelessWidget {
  const BoardLaneDragHandle({
    required this.laneId,
    required this.fromIndex,
    required this.isVertical,
    required this.onDragStarted,
    required this.onDragEnded,
    required this.style,
    super.key,
  });

  final String laneId;
  final int fromIndex;
  final bool isVertical;
  final void Function(LaneDragPayload payload) onDragStarted;
  final VoidCallback onDragEnded;
  final BoardViewStyle style;

  @override
  Widget build(BuildContext context) {
    final payload = LaneDragPayload(laneId: laneId, fromIndex: fromIndex);
    final scheme = Theme.of(context).colorScheme;

    return Draggable<LaneDragPayload>(
      data: payload,
      axis: isVertical ? Axis.horizontal : Axis.vertical,
      onDragStarted: () => onDragStarted(payload),
      onDragEnd: (_) => onDragEnded(),
      // Called even after this widget unmounts (preview removes the source lane).
      onDraggableCanceled: (velocity, offset) => onDragEnded(),
      feedback: Material(
        elevation: style.dragHandleFeedbackElevation,
        borderRadius: BorderRadius.circular(style.dragHandleFeedbackRadius),
        child: Container(
          padding: style.dragHandleFeedbackPadding,
          color: style.dragHandleFeedbackColor ??
              scheme.surfaceContainerHighest,
          child: Text(laneId, style: Theme.of(context).textTheme.labelLarge),
        ),
      ),
      childWhenDragging: SizedBox(
        width: style.dragHandleIconSize,
        height: style.dragHandleIconSize,
      ),
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
