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
    super.key,
  });

  final BoardLane<T> lane;
  final BoardLane<T> originalLane;
  final int originalIndex;
  final double crossExtent;

  Widget _header(BuildContext context, BoardViewScope<T> scope) {
    final handle = scope.canReorder && scope.onCollectionsReorder != null
        ? BoardLaneDragHandle(
            laneId: lane.id,
            fromIndex: originalIndex,
            isVertical: scope.isVertical,
            style: scope.style,
            onDragStarted: scope.session.onLaneDragStarted,
            onDragEnded: scope.session.onLaneDragEnded,
          )
        : const SizedBox.shrink();

    final content = scope.collectionHeaderBuilder(
      context,
      originalLane,
      originalIndex,
      handle,
    );

    if (!scope.canReorder) return content;

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

  Widget _shelled(BoxDecoration decoration, Widget child) {
    return Container(
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = BoardViewScope.of<T>(context);
    final session = scope.session;
    final collapsed = session.collectionsCollapsed;
    final extent = collapsed ? scope.style.collapsedLaneExtent : scope.laneExtent;
    final header = _header(context, scope);
    final decoration =
        scope.laneDecorationBuilder?.call(context, originalLane) ??
        defaultBoardLaneDecoration(
          context,
          laneShellRadius: scope.style.laneShellRadius,
        );

    // Non-collapsed: shell scrolls with items (HM + VM).
    final scrollingShell = !collapsed;
    final hmScrollingShell = scrollingShell && !scope.isVertical;

    final body = BoardCollectionLaneBody<T>(
      lane: lane,
      itemsBodyExtent: hmScrollingShell ? scope.laneExtent : null,
      leadingHeader: collapsed ? null : header,
      shellDecoration: scrollingShell ? decoration : null,
      pinHeader: scope.headerPin == BoardHeaderPin.pinned,
    );

    final Widget content;
    if (scrollingShell) {
      content = body;
    } else {
      // Collapsed during collection reorder: keep the header at the start of
      // the strip (top in VM). Do not Expanded-wrap it — a Row inside Expanded
      // vertically centers and hides the title mid-lane.
      content = _shelled(
        decoration,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            const Spacer(),
          ],
        ),
      );
    }

    final Widget sized;
    if (scope.isVertical) {
      sized = SizedBox(
        width: extent,
        height: crossExtent.isFinite ? crossExtent : null,
        child: content,
      );
    } else if (collapsed) {
      sized = SizedBox(
        width: crossExtent.isFinite ? crossExtent : null,
        height: extent,
        child: content,
      );
    } else {
      // HM: always bind width + height to the board lane viewport so the shell
      // fits on-screen. Both pin modes split that height as header + items.
      sized = SizedBox(
        width: crossExtent.isFinite ? crossExtent : null,
        height: extent,
        child: content,
      );
    }

    return Padding(
      padding: boardLaneOuterPadding(
        isVertical: scope.isVertical,
        style: scope.style,
      ),
      child: sized,
    );
  }
}
