import 'package:flutter/widgets.dart';

import '../models/board_builders.dart';
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
  final DeleteHoverPreview deleteHover = DeleteHoverPreview();

  ItemDragPayload<T>? itemDrag;
  LaneDragPayload? laneDrag;

  bool _dropHandled = false;
  bool _pendingLaneDelete = false;

  /// Whether a collection delete is awaiting parent confirmation.
  bool get pendingLaneDelete => _pendingLaneDelete;

  EdgeDragScroller? boardEdgeScroller;
  final Map<String, EdgeDragScroller> laneEdgeScrollers = {};

  bool get isDragging => itemDrag != null || laneDrag != null;

  void dispose() {
    itemHover.dispose();
    laneHover.dispose();
    deleteHover.dispose();
    boardEdgeScroller?.dispose();
    boardEdgeScroller = null;
    for (final scroller in laneEdgeScrollers.values) {
      scroller.dispose();
    }
    laneEdgeScrollers.clear();
  }

  void onItemDragStarted(ItemDragPayload<T> payload) {
    _dropHandled = false;
    itemDrag = payload;
    laneDrag = null;
    onChanged();
    itemHover.clear();
    deleteHover.clear();
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
    deleteHover.clear();
    if (itemDrag != null) {
      itemDrag = null;
      onChanged();
    }
  }

  void onDeleteHover() {
    if (deleteHover.active) return;
    deleteHover.update(true);
    itemHover.clear();
    final drag = laneDrag;
    if (drag != null) {
      // Keep the source slot reserved so the lane list does not collapse
      // while hovering the delete bin.
      laneHover.update(drag.fromIndex);
    } else {
      laneHover.clear();
    }
  }

  void onDeleteHoverEnd() {
    deleteHover.clear();
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
    if (deleteHover.active) return;
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
    if (deleteHover.active) return;
    itemHover.update(laneId, index);
    boardEdgeScroller?.onDragUpdate(globalPosition);
    laneEdgeScrollers[laneId]?.onDragUpdate(globalPosition);
  }

  void acceptItemDelete(
    ItemDragPayload<T> payload, {
    required void Function(String itemId, String fromLaneId, int fromIndex)
        onItemDeleted,
  }) {
    if (_dropHandled) return;
    _dropHandled = true;
    onItemDragEnded();
    onItemDeleted(payload.itemId, payload.fromLaneId, payload.fromIndex);
  }

  void acceptItemDrop(
    ItemDragPayload<T> payload, {
    required void Function(BoardItemMove move) onItemMoved,
  }) {
    if (_dropHandled) return;
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
    if (_pendingLaneDelete) {
      resolveLaneDelete(false);
    }
    _dropHandled = false;
    laneDrag = payload;
    itemDrag = null;
    onChanged();
    // Seed a drop gap at the source slot so a placeholder appears immediately
    // (post-removal index matches BoardItemMove / acceptLaneDrop semantics).
    laneHover.update(payload.fromIndex);
    itemHover.clear();
    deleteHover.clear();
    boardEdgeScroller?.onDragStart();
    onPointerRouteNeeded();
  }

  void onLaneDragEnded() {
    if (_pendingLaneDelete) {
      onPointerRouteReleased();
      boardEdgeScroller?.onDragEnd();
      deleteHover.clear();
      return;
    }
    _clearLaneDrag();
  }

  void _clearLaneDrag() {
    onPointerRouteReleased();
    boardEdgeScroller?.onDragEnd();
    laneHover.clear();
    deleteHover.clear();
    if (laneDrag != null) {
      laneDrag = null;
      onChanged();
    }
  }

  /// Ends a pending collection delete. Call from the parent after the confirm
  /// dialog closes. [confirmed] `true` clears the ghost after deletion;
  /// `false` restores the lane.
  void resolveLaneDelete(bool confirmed) {
    if (!_pendingLaneDelete) return;
    _pendingLaneDelete = false;
    _clearLaneDrag();
  }

  void cancelPendingLaneDelete() {
    resolveLaneDelete(false);
  }

  void acceptLaneDelete(
    LaneDragPayload payload, {
    required BoardCollectionDeletedCallback onCollectionDeleted,
  }) {
    if (_dropHandled) return;
    _dropHandled = true;
    _pendingLaneDelete = true;
    laneHover.update(payload.fromIndex);
    deleteHover.clear();
    onPointerRouteReleased();
    boardEdgeScroller?.onDragEnd();
    onCollectionDeleted(payload.laneId, payload.fromIndex, resolveLaneDelete);
  }

  void acceptLaneDrop(
    LaneDragPayload payload, {
    required void Function(int oldIndex, int newIndex)? onCollectionsReorder,
  }) {
    if (_dropHandled) return;
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
    if (!isDragging || deleteHover.active) return;
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
    laneEdgeScrollers[laneId]?.dispose();
    laneEdgeScrollers[laneId] = scroller;
    if (itemDrag != null) {
      scroller.onDragStart();
    }
  }

  void unregisterLaneEdgeScroller(String laneId) {
    laneEdgeScrollers.remove(laneId)?.dispose();
  }

  /// Drop edge-scrollers for lanes that are no longer present.
  void pruneLaneEdgeScrollers(Set<String> activeLaneIds) {
    final staleIds = laneEdgeScrollers.keys
        .where((id) => !activeLaneIds.contains(id))
        .toList(growable: false);
    for (final id in staleIds) {
      unregisterLaneEdgeScroller(id);
    }
  }
}
