import 'package:flutter/material.dart';

import '../enums/board_header_pin.dart';
import '../models/board_builders.dart';
import '../models/board_drag_models.dart';
import '../models/board_lane.dart';
import '../models/board_metrics.dart';
import 'board_collection_lane_body.dart';
import 'board_lane_drag_handle.dart';
import 'board_view_scope.dart';

/// A single collection column/row: header, optional drag handle, and items.
class BoardCollectionLane<T> extends StatelessWidget {
  const BoardCollectionLane({
    required this.lane,
    required this.originalLane,
    required this.originalIndex,
    required this.crossExtent,
    this.ghostPreview = false,
    super.key,
  });

  final BoardLane<T> lane;
  final BoardLane<T> originalLane;
  final int originalIndex;
  final double crossExtent;

  /// Non-interactive insert preview shown at the lane reorder gap.
  final bool ghostPreview;

  Widget _dragHandle(
    BuildContext context,
    BoardViewScope<T> scope, {
    required WidgetBuilder feedbackBuilder,
  }) {
    return BoardLaneDragHandle(
      laneId: lane.id,
      fromIndex: originalIndex,
      isVertical: scope.isVertical,
      allowFreeDragAxis: scope.deleteBinEnabled,
      style: scope.style,
      onDragStarted: scope.session.onLaneDragStarted,
      onDragEnded: scope.session.onLaneDragEnded,
      feedbackBuilder: feedbackBuilder,
    );
  }

  Widget _header(
    BuildContext context,
    BoardViewScope<T> scope, {
    required Widget dragHandle,
  }) {
    final content = scope.collectionHeaderBuilder(
      context,
      originalLane,
      originalIndex,
      dragHandle,
    );

    if (ghostPreview || !scope.canReorder) return content;

    return DragTarget<ItemDragPayload<T>>(
      onMove: (details) => scope.session.onItemHoverAtIndex(
        laneId: lane.id,
        index: 0,
        globalPosition: details.offset,
      ),
      onAcceptWithDetails: (details) {
        scope.session.onItemHoverAtIndex(
          laneId: lane.id,
          index: 0,
          globalPosition: details.offset,
        );
        scope.session.acceptItemDrop(
          details.data,
          onItemMoved: scope.onItemMoved,
        );
      },
      builder: (context, candidate, rejected) => content,
    );
  }

  WidgetBuilder _fingerFeedbackBuilder(BoardViewScope<T> scope) {
    return (context) {
      final custom = scope.collectionDragFeedbackBuilder?.call(
        context,
        originalLane,
        originalIndex,
      );
      if (custom != null) return custom;

      return Text(
        originalLane.id,
        style: Theme.of(context).textTheme.labelLarge,
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final scope = BoardViewScope.of<T>(context);
    final extent = scope.laneExtent;
    final decoration =
        scope.laneDecorationBuilder?.call(context, originalLane) ??
        defaultBoardLaneDecoration(
          context,
          laneShellRadius: scope.style.laneShellRadius,
        );

    final canReorderLane = !ghostPreview &&
        scope.canReorder &&
        scope.onCollectionsReorder != null;
    final dragHandle = canReorderLane
        ? _dragHandle(context, scope, feedbackBuilder: _fingerFeedbackBuilder(scope))
        : const SizedBox.shrink();

    final content = BoardCollectionLaneBody<T>(
      lane: lane,
      itemsBodyExtent: !scope.isVertical ? scope.laneExtent : null,
      leadingHeader: _header(context, scope, dragHandle: dragHandle),
      shellDecoration: decoration,
      pinHeader: scope.headerPin == BoardHeaderPin.pinned,
      itemsDragEnabled: !ghostPreview,
    );

    final sized = SizedBox(
      width: scope.isVertical
          ? extent
          : (crossExtent.isFinite ? crossExtent : null),
      height: scope.isVertical
          ? (crossExtent.isFinite ? crossExtent : null)
          : extent,
      child: content,
    );

    return Padding(
      padding: boardLaneOuterPadding(
        isVertical: scope.isVertical,
        style: scope.style,
      ),
      child: sized,
    );
  }
}
