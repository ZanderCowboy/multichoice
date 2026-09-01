import 'package:flutter/widgets.dart';

import '../models/board_drag_models.dart';
import '../models/board_item_move.dart';
import 'board_drag_indexing.dart';
import 'edge_drag_scroller.dart';

export 'board_drag_indexing.dart';

/// Non-UI drag session for [BoardView]: payloads, hover previews, and DnD flow.
///
/// Rebuilds stay in the widget layer via [onChanged].
class BoardDragSession<T> {
  BoardDragSession({
    required this.onChanged,
    required this.onPointerRouteNeeded,
    required this.onPointerRouteReleased,
  });

  final VoidCallback onChanged;
  final VoidCallback onPointerRouteNeeded;
  final VoidCallback onPointerRouteReleased;

  final ItemHoverPreview itemHover = ItemHoverPreview();
  final LaneHoverPreview laneHover = LaneHoverPreview();

  ItemDragPayload<T>? itemDrag;
  LaneDragPayload? laneDrag;

  EdgeDragScroller? boardEdgeScroller;
  final Map<String, EdgeDragScroller> laneEdgeScrollers = {};

  bool get isDragging => itemDrag != null || laneDrag != null;

  bool get collectionsCollapsed => laneDrag != null;

  void dispose() {
    itemHover.dispose();
    laneHover.dispose();
  }

  void onItemDragStarted(ItemDragPayload<T> payload) {
    itemDrag = payload;
    laneDrag = null;
    onChanged();
    itemHover.clear();
    boardEdgeScroller?.onDragStart();
    for (final scroller in laneEdgeScrollers.values) {
      scroller.onDragStart();
    }
    onPointerRouteNeeded();
  }

  void onItemDragEnded() {
    onPointerRouteReleased();
    boardEdgeScroller?.onDragEnd();
    for (final scroller in laneEdgeScrollers.values) {
      scroller.onDragEnd();
    }
    itemHover.clear();
    if (itemDrag != null) {
      itemDrag = null;
      onChanged();
    }
  }

  void onItemHover({
    required String laneId,
    required Offset globalPosition,
    required RenderBox laneBox,
    required int previewItemCount,
    required ScrollController? laneController,
    required bool isVertical,
    required double itemExtent,
    double leadingExtent = 0,
  }) {
    final index = insertIndexFromPointer(
      globalPosition: globalPosition,
      laneBox: laneBox,
      previewItemCount: previewItemCount,
      laneController: laneController,
      isVertical: isVertical,
      itemExtent: itemExtent,
      leadingExtent: leadingExtent,
    );
    itemHover.update(laneId, index);
    boardEdgeScroller?.onDragUpdate(globalPosition);
    laneEdgeScrollers[laneId]?.onDragUpdate(globalPosition);
  }

  void onItemHoverAtIndex({
    required String laneId,
    required int index,
    required Offset globalPosition,
  }) {
    itemHover.update(laneId, index);
    boardEdgeScroller?.onDragUpdate(globalPosition);
    laneEdgeScrollers[laneId]?.onDragUpdate(globalPosition);
  }

  void acceptItemDrop(
    ItemDragPayload<T> payload, {
    required void Function(BoardItemMove move) onItemMoved,
  }) {
    final toLaneId = itemHover.laneId;
    final toIndex = itemHover.index;
    onItemDragEnded();

    if (toLaneId == null || toIndex == null) return;

    // No-op: dropped back onto the same final slot.
    if (payload.fromLaneId == toLaneId && payload.fromIndex == toIndex) {
      return;
    }

    onItemMoved(
      BoardItemMove(
        itemId: payload.itemId,
        fromLaneId: payload.fromLaneId,
        fromIndex: payload.fromIndex,
        toLaneId: toLaneId,
        toIndex: toIndex,
      ),
    );
  }

  void onLaneDragStarted(LaneDragPayload payload) {
    laneDrag = payload;
    itemDrag = null;
    onChanged();
    // Seed a drop gap at the source slot so a placeholder appears immediately
    // (post-removal index matches BoardItemMove / acceptLaneDrop semantics).
    laneHover.update(payload.fromIndex);
    itemHover.clear();
    boardEdgeScroller?.onDragStart();
    onPointerRouteNeeded();
  }

  void onLaneDragEnded() {
    onPointerRouteReleased();
    boardEdgeScroller?.onDragEnd();
    laneHover.clear();
    if (laneDrag != null) {
      laneDrag = null;
      onChanged();
    }
  }

  void acceptLaneDrop(
    LaneDragPayload payload, {
    required void Function(int oldIndex, int newIndex)? onCollectionsReorder,
  }) {
    final visualIndex = laneHover.index;
    onLaneDragEnded();

    final callback = onCollectionsReorder;
    if (callback == null || visualIndex == null) return;

    // Source lane is removed from preview, so visualIndex is already the
    // final insertion index after removal.
    if (payload.fromIndex == visualIndex) return;

    callback(payload.fromIndex, visualIndex);
  }

  void onGlobalPointerMove({
    required Offset position,
    required bool isVertical,
    required int laneCount,
  }) {
    if (!isDragging) return;
    boardEdgeScroller?.onDragUpdate(position);
    updateLaneHoverAtBoardEdges(
      globalPosition: position,
      isVertical: isVertical,
      laneCount: laneCount,
    );

    final hoverLaneId = itemHover.laneId;
    if (hoverLaneId != null) {
      laneEdgeScrollers[hoverLaneId]?.onDragUpdate(position);
    }
  }

  void registerLaneEdgeScroller(String laneId, EdgeDragScroller scroller) {
    laneEdgeScrollers[laneId] = scroller;
    if (itemDrag != null) {
      scroller.onDragStart();
    }
  }

  void unregisterLaneEdgeScroller(String laneId) {
    laneEdgeScrollers.remove(laneId);
  }

  /// Drop edge-scrollers for lanes that are no longer present.
  void pruneLaneEdgeScrollers(Set<String> activeLaneIds) {
    laneEdgeScrollers.removeWhere((id, _) => !activeLaneIds.contains(id));
  }
}
