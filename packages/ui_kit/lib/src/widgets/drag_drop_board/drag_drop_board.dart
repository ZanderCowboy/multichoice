import 'package:flutter/material.dart';

import '../../constants/ui_constants.dart';
import 'default_placeholder.dart';
import 'drag_axis.dart';
import 'edge_drag_scroller.dart';
import 'lane.dart';

/// Internal payload for drag operations.
class _DragPayload<T> {
  const _DragPayload({
    required this.item,
    required this.sourceLaneId,
    required this.sourceIndex,
  });

  final T item;
  final String sourceLaneId;
  final int sourceIndex;
}

/// Layout mode for the board.
enum BoardLayout {
  /// Lanes in a horizontal row; items in each lane scroll vertically.
  vertical,

  /// Lanes in a vertical column; items in each lane as horizontal row.
  horizontal,
}

/// A Jira-style drag-and-drop board for reordering and moving items across lanes.
class DragDropBoard<T> extends StatefulWidget {
  const DragDropBoard({
    required this.lanes,
    required this.itemIdOf,
    required this.itemBuilder,
    required this.onDrop,
    super.key,
    this.placeholderBuilder,
    this.emptyLanePlaceholderBuilder,
    this.dragAxis = DragAxis.multi,
    this.laneBuilder,
    this.scrollController,
    this.onDragTargetChanged,
    this.dragHandleBuilder,
    this.layout = BoardLayout.vertical,
    this.laneWidth,
    this.laneHeight,
    this.itemExtent,
  });

  final List<Lane<T>> lanes;
  final String Function(T item) itemIdOf;
  final Widget Function(BuildContext context, T item, bool isPlaceholder, {Widget? leading}) itemBuilder;
  final void Function(String itemId, String fromLaneId, int fromIndex, String toLaneId, int toIndex) onDrop;
  final Widget Function(BuildContext context, {double? width, double? height})? placeholderBuilder;
  final Widget Function(BuildContext context)? emptyLanePlaceholderBuilder;
  final DragAxis dragAxis;
  final Widget Function(BuildContext context, String laneId, Widget child)? laneBuilder;
  final ScrollController? scrollController;
  final void Function(String? laneId, int? index)? onDragTargetChanged;
  final Widget Function(BuildContext context, T item)? dragHandleBuilder;
  final BoardLayout layout;
  final double? laneWidth;
  final double? laneHeight;
  final double? itemExtent;

  @override
  State<DragDropBoard<T>> createState() => _DragDropBoardState<T>();
}

class _DragDropBoardState<T> extends State<DragDropBoard<T>> {
  String? _dropTargetLaneId;
  int? _dropTargetIndex;
  _DragPayload<T>? _draggingPayload;

  void _updateDropTarget(String? laneId, int? index) {
    if (_dropTargetLaneId == laneId && _dropTargetIndex == index) return;
    setState(() {
      _dropTargetLaneId = laneId;
      _dropTargetIndex = index;
    });
    widget.onDragTargetChanged?.call(laneId, index);
  }

  void _clearDropTarget() => _updateDropTarget(null, null);

  void _acceptDrop(BuildContext context, _DragPayload<T> payload, String laneId, int slotIndex) {
    if (payload.sourceLaneId == laneId && payload.sourceIndex == slotIndex) return;
    widget.onDrop(
      widget.itemIdOf(payload.item),
      payload.sourceLaneId,
      payload.sourceIndex,
      laneId,
      slotIndex,
    );
    _updateDropTarget(null, null);
    _draggingPayload = null;
  }

  Widget _buildPlaceholder(BuildContext context, String laneId, int slotIndex, {double? width, double? height}) {
    final isEmptyLane = widget.lanes.where((l) => l.id == laneId).firstOrNull?.items.isEmpty ?? true;
    if (isEmptyLane && widget.emptyLanePlaceholderBuilder != null) {
      return widget.emptyLanePlaceholderBuilder!(context);
    }
    if (widget.placeholderBuilder != null) {
      return widget.placeholderBuilder!(context, width: width, height: height);
    }
    return DefaultDropPlaceholder(
      width: width,
      height: height,
      message: isEmptyLane ? 'Drop here' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.layout == BoardLayout.vertical;
    final laneW = widget.laneWidth ?? (isVertical ? UIConstants.vertTabWidth(context) : double.infinity);
    final laneH = widget.laneHeight ?? (isVertical ? double.infinity : UIConstants.horiTabHeight(context));

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossExtent = isVertical ? constraints.maxHeight : constraints.maxWidth;

        return SingleChildScrollView(
          controller: widget.scrollController,
          scrollDirection: isVertical ? Axis.horizontal : Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          child: _EdgeScrollHost(
            child: isVertical
                ? SizedBox(
                    height: crossExtent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widget.lanes.map((lane) {
                        return _buildLane(
                          context,
                          lane,
                          laneW,
                          crossExtent,
                          isVertical,
                        );
                      }).toList(),
                    ),
                  )
                : SizedBox(
                    width: crossExtent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: widget.lanes.map((lane) {
                        return _buildLane(
                          context,
                          lane,
                          crossExtent,
                          laneH,
                          isVertical,
                        );
                      }).toList(),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLane(
    BuildContext context,
    Lane<T> lane,
    double laneWidth,
    double laneHeight,
    bool isVertical,
  ) {
    final laneChild = isVertical
        ? _buildVerticalLaneItems(context, lane, laneWidth)
        : _buildHorizontalLaneItems(context, lane, laneHeight);

    if (widget.laneBuilder != null) {
      final built = widget.laneBuilder!(context, lane.id, laneChild);
      // Constrain lane so Row/Column children with Expanded get bounded constraints
      return isVertical
          ? SizedBox(width: laneWidth, child: built)
          : SizedBox(height: laneHeight, child: built);
    }
    return laneChild;
  }

  Widget _buildVerticalLaneItems(BuildContext context, Lane<T> lane, double laneWidth) {
    final entries = lane.items;
    final slotCount = entries.length + 1;
    final itemH = widget.itemExtent ?? UIConstants.entryHeight(context);

    return SizedBox(
      width: laneWidth,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: slotCount,
        itemBuilder: (context, slotIndex) => _buildSlot(
          context,
          lane,
          slotIndex,
          laneWidth,
          itemH,
        ),
      ),
    );
  }

  Widget _buildHorizontalLaneItems(BuildContext context, Lane<T> lane, double laneHeight) {
    final entries = lane.items;
    final slotCount = entries.length + 1;
    final cellWidth = widget.itemExtent ?? laneHeight / 2;
    final cellHeight = laneHeight / 2;

    return SizedBox(
      height: laneHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: slotCount,
        itemBuilder: (context, slotIndex) => SizedBox(
          width: cellWidth,
          child: _buildSlot(context, lane, slotIndex, cellWidth, cellHeight),
        ),
      ),
    );
  }

  Widget _buildSlot(
    BuildContext context,
    Lane<T> lane,
    int slotIndex, [
    double? slotWidth,
    double? slotHeight,
  ]) {
    final isDropTarget = _dropTargetLaneId == lane.id && _dropTargetIndex == slotIndex;
    if (isDropTarget) {
      return _buildPlaceholder(context, lane.id, slotIndex, width: slotWidth, height: slotHeight);
    }

    if (slotIndex >= lane.items.length) {
      return DragTarget<_DragPayload<T>>(
        onAcceptWithDetails: (details) => _acceptDrop(context, details.data, lane.id, slotIndex),
        onMove: (details) {
          _updateDropTarget(lane.id, slotIndex);
          _EdgeScrollScope.of(context)?.onDragUpdate(details.offset);
        },
        onLeave: (_) => _clearDropTarget(),
        builder: (context, candidateData, rejects) => SizedBox(
          width: slotWidth,
          height: (slotHeight ?? 72) * 0.5,
        ),
      );
    }

    final item = lane.items[slotIndex];
    final payload = _DragPayload(item: item, sourceLaneId: lane.id, sourceIndex: slotIndex);
    final isSource = _draggingPayload?.sourceLaneId == lane.id && _draggingPayload?.sourceIndex == slotIndex;

    if (isSource) {
      return _buildPlaceholder(context, lane.id, slotIndex, width: slotWidth, height: slotHeight);
    }

    return DragTarget<_DragPayload<T>>(
      onAcceptWithDetails: (details) => _acceptDrop(context, details.data, lane.id, slotIndex),
      onMove: (details) {
        _updateDropTarget(lane.id, slotIndex);
        _EdgeScrollScope.of(context)?.onDragUpdate(details.offset);
      },
      onLeave: (_) => _clearDropTarget(),
      builder: (context, candidateData, rejects) => _buildDraggableItem(context, payload, slotWidth, slotHeight),
    );
  }

  Axis? _getDragAxis() {
    switch (widget.dragAxis) {
      case DragAxis.horizontal:
        return Axis.horizontal;
      case DragAxis.vertical:
        return Axis.vertical;
      case DragAxis.multi:
        return null;
    }
  }

  Widget _buildDraggableItem(
    BuildContext context,
    _DragPayload<T> payload, [
    double? width,
    double? height,
  ]) {
    final scroller = _EdgeScrollScope.of(context);

    if (widget.dragHandleBuilder != null) {
      final handle = widget.dragHandleBuilder!(context, payload.item);
      return Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: width,
          height: height ?? 72,
          child: widget.itemBuilder(
            context,
            payload.item,
            false,
            leading: Draggable<_DragPayload<T>>(
              data: payload,
              axis: _getDragAxis(),
              onDragStarted: () {
                setState(() => _draggingPayload = payload);
                scroller?.onDragStart();
              },
              onDragEnd: (_) {
                scroller?.onDragEnd();
                setState(() => _draggingPayload = null);
                _clearDropTarget();
              },
              feedback: Material(
                type: MaterialType.transparency,
                child: SizedBox(
                  width: width,
                  height: height ?? 72,
                  child: widget.itemBuilder(context, payload.item, true),
                ),
              ),
              child: handle,
            ),
          ),
        ),
      );
    }

    return Draggable<_DragPayload<T>>(
      data: payload,
      axis: _getDragAxis(),
      onDragStarted: () {
        setState(() => _draggingPayload = payload);
        scroller?.onDragStart();
      },
      onDragEnd: (_) {
        scroller?.onDragEnd();
        setState(() => _draggingPayload = null);
        _clearDropTarget();
      },
      feedback: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: width,
          height: height ?? 72,
          child: widget.itemBuilder(context, payload.item, true),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: width,
          height: height ?? 72,
          child: widget.itemBuilder(context, payload.item, false),
        ),
      ),
    );
  }
}

/// Provides [EdgeDragScroller] to descendants when inside a [Scrollable].
class _EdgeScrollHost extends StatefulWidget {
  const _EdgeScrollHost({required this.child});

  final Widget child;

  @override
  State<_EdgeScrollHost> createState() => _EdgeScrollHostState();
}

class _EdgeScrollHostState extends State<_EdgeScrollHost> {
  EdgeDragScroller? _scroller;

  @override
  Widget build(BuildContext context) {
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != null && _scroller == null) {
      _scroller = EdgeDragScroller(scrollable: scrollable);
    }
    return _EdgeScrollScope(
      scroller: _scroller,
      child: widget.child,
    );
  }
}

class _EdgeScrollScope extends InheritedWidget {
  const _EdgeScrollScope({
    required this.scroller,
    required super.child,
  });

  final EdgeDragScroller? scroller;

  static EdgeDragScroller? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_EdgeScrollScope>()
        ?.scroller;
  }

  @override
  bool updateShouldNotify(_EdgeScrollScope oldWidget) =>
      scroller != oldWidget.scroller;
}
