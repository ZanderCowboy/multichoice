import 'package:flutter/material.dart';

import '../drag/board_drag_session.dart';
import '../models/board_drag_models.dart';
import '../models/board_lane.dart';
import 'board_collection_lane.dart';
import 'board_view_scope.dart';

/// Builds a visual collection slot (lane or insert gap) for the board scroller.
class BoardCollectionSlot<T> extends StatelessWidget {
  const BoardCollectionSlot({
    required this.visualIndex,
    required this.previewLanes,
    required this.originalLanes,
    required this.crossExtent,
    super.key,
  });

  final int visualIndex;
  final List<BoardLane<T>> previewLanes;
  final List<BoardLane<T>> originalLanes;
  final double crossExtent;

  BoardLane<T>? _draggedLane(BoardDragSession<T> session) {
    final drag = session.laneDrag;
    if (drag == null) return null;
    for (final lane in originalLanes) {
      if (lane.id == drag.laneId) return lane;
    }
    return null;
  }

  Widget _buildGapTarget(
    BuildContext context,
    BoardViewScope<T> scope, {
    required int insertIndex,
    required BoardLane<T> draggedLane,
    required int draggedFromIndex,
  }) {
    final session = scope.session;
    return DragTarget<LaneDragPayload>(
      onMove: (details) {
        session.laneHover.update(insertIndex);
        session.boardEdgeScroller?.onDragUpdate(details.offset);
      },
      onAcceptWithDetails: (details) {
        session.laneHover.update(insertIndex);
        session.acceptLaneDrop(
          details.data,
          onCollectionsReorder: scope.onCollectionsReorder,
        );
      },
      builder: (context, candidate, rejected) {
        final ghost = BoardCollectionLane<T>(
          lane: draggedLane,
          originalLane: draggedLane,
          originalIndex: draggedFromIndex,
          crossExtent: crossExtent,
          ghostPreview: true,
        );
        return IgnorePointer(
          child: Opacity(
            opacity: scope.style.laneDragGhostOpacity,
            child: ghost,
          ),
        );
      },
    );
  }

  Widget _buildLaneTarget(
    BuildContext context,
    BoardViewScope<T> scope, {
    required BoardLane<T> lane,
    required int laneIndex,
    required int laneCount,
  }) {
    final session = scope.session;
    final originalIndex = originalLanes.indexWhere((l) => l.id == lane.id);
    final resolvedIndex = originalIndex >= 0 ? originalIndex : laneIndex;
    final originalLane = originalLanes.firstWhere(
      (l) => l.id == lane.id,
      orElse: () => lane,
    );

    RenderBox? laneBox;
    return DragTarget<LaneDragPayload>(
      onMove: (details) {
        final insertAt = session.collectionInsertIndexForLane(
          laneIndex: laneIndex,
          laneCount: laneCount,
          globalPosition: details.offset,
          laneBox: laneBox,
          isVertical: scope.isVertical,
        );
        session.laneHover.update(insertAt);
        session.boardEdgeScroller?.onDragUpdate(details.offset);
      },
      onLeave: (_) {
        // Keep last hover until another lane claims it or drag ends.
      },
      onAcceptWithDetails: (details) {
        final insertAt = session.collectionInsertIndexForLane(
          laneIndex: laneIndex,
          laneCount: laneCount,
          globalPosition: details.offset,
          laneBox: laneBox,
          isVertical: scope.isVertical,
        );
        session.laneHover.update(insertAt);
        session.acceptLaneDrop(
          details.data,
          onCollectionsReorder: scope.onCollectionsReorder,
        );
      },
      builder: (context, candidate, rejected) {
        laneBox = context.findRenderObject() as RenderBox?;
        return BoardCollectionLane<T>(
          lane: lane,
          originalLane: originalLane,
          originalIndex: resolvedIndex,
          crossExtent: crossExtent,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = BoardViewScope.of<T>(context);
    final session = scope.session;
    final laneCount = previewLanes.length;
    final laneIndex = session.laneIndexForVisualSlot(visualIndex, laneCount);
    final gapIndex = session.laneDrag != null ? session.laneHover.index : null;
    final draggedLane = _draggedLane(session);
    final draggedFromIndex = session.laneDrag?.fromIndex;

    if (gapIndex != null &&
        visualIndex == gapIndex &&
        draggedLane != null &&
        draggedFromIndex != null) {
      return _buildGapTarget(
        context,
        scope,
        insertIndex: gapIndex,
        draggedLane: draggedLane,
        draggedFromIndex: draggedFromIndex,
      );
    }

    if (laneIndex == null || laneIndex < 0 || laneIndex >= laneCount) {
      return const SizedBox.shrink();
    }

    return _buildLaneTarget(
      context,
      scope,
      lane: previewLanes[laneIndex],
      laneIndex: laneIndex,
      laneCount: laneCount,
    );
  }
}
