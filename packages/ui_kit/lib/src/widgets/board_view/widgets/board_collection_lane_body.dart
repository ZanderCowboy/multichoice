import 'package:flutter/material.dart';

import '../drag/board_drag_session.dart';
import '../enums/board_add_visibility.dart';
import '../models/board_lane.dart';
import 'board_view_scope.dart';
import 'default_placeholder.dart';
import 'lane_items_pane.dart';

/// Item list (or collapsed stub) for a [BoardCollectionLane].
class BoardCollectionLaneBody<T> extends StatelessWidget {
  const BoardCollectionLaneBody({
    required this.lane,
    super.key,
    this.leadingHeader,
    this.shellDecoration,
    this.itemsBodyExtent,
    this.pinHeader = false,
  });

  final BoardLane<T> lane;
  final Widget? leadingHeader;
  final BoxDecoration? shellDecoration;
  final double? itemsBodyExtent;
  final bool pinHeader;

  Widget _placeholder(
    BuildContext context,
    BoardViewScope<T> scope, {
    String? emptyMessage,
  }) {
    if (scope.placeholderBuilder != null) {
      return scope.placeholderBuilder!(
        context,
        width: scope.isVertical ? null : scope.itemExtent,
        height: scope.isVertical ? scope.itemExtent : null,
      );
    }
    return DefaultBoardPlaceholder(
      width: scope.isVertical ? null : scope.itemExtent,
      height: scope.isVertical ? scope.itemExtent : null,
      message: emptyMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = BoardViewScope.of<T>(context);
    final session = scope.session;

    if (session.collectionsCollapsed) {
      return SizedBox(
        height: scope.style.collapsedHeaderCross,
        width: double.infinity,
      );
    }

    final showAdds =
        scope.editMode || scope.addVisibility == BoardAddVisibility.always;
    final add = showAdds && scope.laneAddBuilder != null
        ? scope.laneAddBuilder!(context, lane)
        : null;

    return LaneItemsPane<T>(
      lane: lane,
      isVertical: scope.isVertical,
      itemExtent: scope.itemExtent,
      itemsBodyExtent: itemsBodyExtent,
      itemHover: session.itemHover,
      itemBuilder: scope.itemBuilder,
      leadingHeader: leadingHeader,
      shellDecoration: shellDecoration,
      pinHeader: pinHeader,
      scrollIndicator: scope.scrollIndicator,
      style: scope.style,
      placeholderBuilder: (ctx) => _placeholder(
        ctx,
        scope,
        emptyMessage: lane.items.isEmpty ? 'Drop here' : null,
      ),
      emptyLaneBuilder: scope.emptyLaneBuilder == null
          ? null
          : (ctx) => scope.emptyLaneBuilder!(ctx, lane),
      addBuilder: add == null ? null : (_) => add,
      addPlacement: scope.laneAddPlacement,
      dragEnabled: scope.canReorder,
      dragAxis: scope.dragAxis,
      scrollController: scope.laneControllerFor(lane.id),
      onEdgeScrollerReady: (scroller) {
        session.registerLaneEdgeScroller(lane.id, scroller);
      },
      onItemDragStarted: session.onItemDragStarted,
      onItemDragEnded: session.onItemDragEnded,
      onHover:
          ({
            required String laneId,
            required Offset globalPosition,
            required RenderBox laneBox,
            required int previewItemCount,
            required ScrollController? laneController,
            required double leadingExtent,
          }) {
            session.onItemHover(
              laneId: laneId,
              globalPosition: globalPosition,
              laneBox: laneBox,
              previewItemCount: previewItemCount,
              laneController: laneController,
              isVertical: scope.isVertical,
              itemExtent: scope.itemExtent,
              leadingExtent: leadingExtent,
            );
          },
      onAccept: (payload) => session.acceptItemDrop(
        payload,
        onItemMoved: scope.onItemMoved,
      ),
      itemIdOf: scope.itemIdOf,
      originalIndexOf: (previewIndex) => session.originalIndexOf(
        laneId: lane.id,
        previewIndex: previewIndex,
      ),
    );
  }
}
