import 'package:flutter/material.dart';

import '../drag/board_drag_session.dart';
import '../drag/edge_drag_scroller.dart';
import '../enums/board_add_visibility.dart';
import '../enums/board_slot_placement.dart';
import '../models/board_lane.dart';
import '../models/board_metrics.dart';
import '../scroll/board_scroll_chrome.dart';
import '../scroll/scrollable_binder.dart';
import 'board_collection_slot.dart';
import 'board_view_scope.dart';

/// Outer scroll view of collections (lanes) for [BoardView].
class BoardCollectionsView<T> extends StatelessWidget {
  const BoardCollectionsView({
    required this.previewLanes,
    required this.originalLanes,
    required this.boardController,
    super.key,
  });

  final List<BoardLane<T>> previewLanes;
  final List<BoardLane<T>> originalLanes;
  final ScrollController boardController;

  Widget _buildBoardAdd(
    BuildContext context,
    BoardViewScope<T> scope, {
    required double crossExtent,
  }) {
    final extent = scope.session.collectionsCollapsed
        ? scope.style.collapsedLaneExtent
        : scope.laneExtent;
    return Padding(
      padding: boardLaneOuterPadding(
        isVertical: scope.isVertical,
        style: scope.style,
      ),
      child: SizedBox(
        width: scope.isVertical
            ? extent
            : (crossExtent.isFinite ? crossExtent : null),
        height: scope.isVertical
            ? (crossExtent.isFinite ? crossExtent : null)
            : extent,
        child: scope.boardAddBuilder!(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = BoardViewScope.of<T>(context);
    final session = scope.session;
    final collectionsAxis =
        scope.isVertical ? Axis.horizontal : Axis.vertical;
    final showAdds =
        scope.editMode || scope.addVisibility == BoardAddVisibility.always;
    final hasBoardAdd = showAdds && scope.boardAddBuilder != null;
    final boardAddAtStart =
        hasBoardAdd && scope.boardAddPlacement == BoardSlotPlacement.start;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListenableBuilder(
          listenable: session.laneHover,
          builder: (context, _) {
            final laneSlotCount = session.collectionSlotCount(
              previewLanes.length,
            );
            final childCount = laneSlotCount + (hasBoardAdd ? 1 : 0);

            return BoardScrollChrome(
              controller: boardController,
              indicator: scope.scrollIndicator,
              style: scope.style,
              scrollbarOrientation: scope.isVertical
                  ? ScrollbarOrientation.bottom
                  : ScrollbarOrientation.right,
              child: CustomScrollView(
                key: const ValueKey('board_collections'),
                controller: boardController,
                scrollDirection: collectionsAxis,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: ScrollableBinder(
                      onReady: (scrollable) {
                        session.boardEdgeScroller = EdgeDragScroller(
                          scrollable: scrollable,
                        );
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: boardCollectionsPadding(
                      isVertical: scope.isVertical,
                      style: scope.style,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((
                        context,
                        visualIndex,
                      ) {
                        final crossExtent = scope.isVertical
                            ? constraints.maxHeight
                            : constraints.maxWidth;

                        if (hasBoardAdd) {
                          if (boardAddAtStart && visualIndex == 0) {
                            return _buildBoardAdd(
                              context,
                              scope,
                              crossExtent: crossExtent,
                            );
                          }
                          if (!boardAddAtStart &&
                              visualIndex == laneSlotCount) {
                            return _buildBoardAdd(
                              context,
                              scope,
                              crossExtent: crossExtent,
                            );
                          }
                        }

                        final laneVisualIndex = boardAddAtStart
                            ? visualIndex - 1
                            : visualIndex;

                        return BoardCollectionSlot<T>(
                          visualIndex: laneVisualIndex,
                          previewLanes: previewLanes,
                          originalLanes: originalLanes,
                          crossExtent: crossExtent,
                        );
                      }, childCount: childCount),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
