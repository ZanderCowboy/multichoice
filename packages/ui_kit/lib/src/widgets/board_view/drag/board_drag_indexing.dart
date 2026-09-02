import 'package:flutter/widgets.dart';

import '../models/board_lane.dart';
import 'board_drag_session.dart';

/// Preview and insert-index helpers for [BoardDragSession].
extension BoardDragSessionIndexing<T> on BoardDragSession<T> {
  /// Lanes with active drag sources removed for preview indexing.
  List<BoardLane<T>> previewLanes(List<BoardLane<T>> lanes) {
    var result = lanes;

    final activeLaneDrag = laneDrag;
    if (activeLaneDrag != null) {
      result = [
        for (var i = 0; i < result.length; i++)
          if (i != activeLaneDrag.fromIndex) result[i],
      ];
    }

    final activeItemDrag = itemDrag;
    if (activeItemDrag == null) return result;

    return result.map((lane) {
      if (lane.id != activeItemDrag.fromLaneId) return lane;
      final items = List<T>.of(lane.items);
      if (activeItemDrag.fromIndex >= 0 &&
          activeItemDrag.fromIndex < items.length) {
        items.removeAt(activeItemDrag.fromIndex);
      }
      return lane.copyWith(items: items);
    }).toList();
  }

  int insertIndexFromPointer({
    required Offset globalPosition,
    required RenderBox laneBox,
    required int previewItemCount,
    required ScrollController? laneController,
    required bool isVertical,
    required double itemExtent,
    double leadingExtent = 0,
  }) {
    final local = laneBox.globalToLocal(globalPosition);
    final scrollOffset = laneController?.hasClients == true
        ? laneController!.offset
        : 0.0;

    final along =
        (isVertical ? local.dy : local.dx) + scrollOffset - leadingExtent;

    if (previewItemCount == 0 || along <= 0) return 0;

    final raw = along / itemExtent;
    final index = raw.round();
    return index.clamp(0, previewItemCount);
  }

  /// Insert index for a pointer over a preview lane (before vs after midpoint).
  int collectionInsertIndexForLane({
    required int laneIndex,
    required int laneCount,
    required Offset globalPosition,
    required RenderBox? laneBox,
    required bool isVertical,
  }) {
    if (laneCount <= 0) return 0;
    final box = laneBox;
    if (box != null && box.hasSize) {
      final local = box.globalToLocal(globalPosition);
      final along = isVertical ? local.dx : local.dy;
      final size = isVertical ? box.size.width : box.size.height;
      if (along > size / 2) {
        return (laneIndex + 1).clamp(0, laneCount);
      }
    }
    return laneIndex.clamp(0, laneCount);
  }

  /// Item-style slots: lanes only, plus one placeholder when hover is set.
  int collectionSlotCount(int laneCount) {
    if (laneDrag == null) return laneCount;
    final gapIndex = laneHover.index;
    return laneCount + (gapIndex != null ? 1 : 0);
  }

  /// Maps a visual collection slot to a preview lane index, or null for the
  /// active insert placeholder.
  int? laneIndexForVisualSlot(int visualIndex, int laneCount) {
    final gapIndex = laneDrag != null ? laneHover.index : null;
    if (gapIndex != null && visualIndex == gapIndex) return null;
    if (gapIndex != null && visualIndex > gapIndex) {
      return visualIndex - 1;
    }
    return visualIndex < laneCount ? visualIndex : null;
  }

  /// When dragging a collection past the board edges, pin hover to start/end
  /// so drops beyond the viewport still land correctly.
  void updateLaneHoverAtBoardEdges({
    required Offset globalPosition,
    required bool isVertical,
    required int laneCount,
  }) {
    if (laneDrag == null) return;
    final scroller = boardEdgeScroller;
    if (scroller == null) return;

    final box = scroller.viewportBox;
    if (box == null) return;

    final local = box.globalToLocal(globalPosition);
    final size = box.size;
    final along = isVertical ? local.dx : local.dy;
    final extent = isVertical ? size.width : size.height;

    // Only when the pointer is past the viewport (gutter), not merely near
    // an edge while hovering a visible lane.
    if (along < 0) {
      laneHover.update(0);
    } else if (along > extent) {
      laneHover.update(laneCount);
    }
  }

  int originalIndexOf({
    required String laneId,
    required int previewIndex,
  }) {
    final drag = itemDrag;
    if (drag == null || drag.fromLaneId != laneId) {
      return previewIndex;
    }
    // Source removed from preview: indices at/after fromIndex shift +1.
    if (previewIndex >= drag.fromIndex) {
      return previewIndex + 1;
    }
    return previewIndex;
  }
}
