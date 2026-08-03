part of 'board_view.dart';

/// Package-private [State] for [BoardView]. Not exported from `board_view`.
class _BoardViewState<T> extends State<BoardView<T>> {
  late final BoardDragSession<T> _session = BoardDragSession<T>(
    onChanged: () {
      if (mounted) setState(() {});
    },
    onPointerRouteNeeded: _addPointerRoute,
    onPointerRouteReleased: _removePointerRoute,
  );

  ScrollController? _ownedBoardController;
  final Map<String, ScrollController> _ownedLaneControllers = {};

  bool _pointerRouteActive = false;

  bool get _isVertical => widget.config.layout == BoardLayout.vertical;

  double get _laneExtent => widget.laneExtent ?? (_isVertical ? 200.0 : 160.0);

  ScrollController get _boardController {
    if (widget.scrollController != null) return widget.scrollController!;
    return _ownedBoardController ??= ScrollController();
  }

  ScrollController _laneControllerFor(String laneId) {
    final external = widget.laneScrollControllers?[laneId];
    if (external != null) return external;
    return _ownedLaneControllers.putIfAbsent(laneId, ScrollController.new);
  }

  Axis? get _dragAxisConstraint {
    switch (widget.config.dragAxis) {
      case DragAxis.horizontal:
        return Axis.horizontal;
      case DragAxis.vertical:
        return Axis.vertical;
      case DragAxis.multi:
        return null;
    }
  }

  void _pruneOwnedLaneResources(Set<String> activeLaneIds) {
    final staleIds = _ownedLaneControllers.keys
        .where((id) => !activeLaneIds.contains(id))
        .toList(growable: false);
    for (final id in staleIds) {
      _ownedLaneControllers.remove(id)?.dispose();
    }
    _session.pruneLaneEdgeScrollers(activeLaneIds);
  }

  @override
  void didUpdateWidget(covariant BoardView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.editMode && !widget.editMode) {
      _session.onItemDragEnded();
      _session.onLaneDragEnded();
    }
    _pruneOwnedLaneResources(widget.lanes.map((l) => l.id).toSet());
  }

  @override
  void dispose() {
    _removePointerRoute();
    _session.dispose();
    _ownedBoardController?.dispose();
    for (final c in _ownedLaneControllers.values) {
      c.dispose();
    }
    _ownedLaneControllers.clear();
    super.dispose();
  }

  void _addPointerRoute() {
    if (_pointerRouteActive) return;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onGlobalPointer);
    _pointerRouteActive = true;
  }

  void _removePointerRoute() {
    if (!_pointerRouteActive) return;
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onGlobalPointer);
    _pointerRouteActive = false;
  }

  void _onGlobalPointer(PointerEvent event) {
    if (!_session.isDragging) return;
    if (event is! PointerMoveEvent && event is! PointerHoverEvent) return;

    _session.onGlobalPointerMove(
      position: event.position,
      isVertical: _isVertical,
      laneCount: _session.previewLanes(widget.lanes).length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final config = widget.config;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: BoardViewScope<T>(
        session: _session,
        isVertical: _isVertical,
        laneExtent: _laneExtent,
        itemExtent: widget.itemExtent,
        editMode: widget.editMode,
        dragAxis: _dragAxisConstraint,
        itemBuilder: widget.itemBuilder,
        collectionHeaderBuilder: widget.collectionHeaderBuilder,
        itemIdOf: widget.itemIdOf,
        laneControllerFor: _laneControllerFor,
        onItemMoved: widget.onItemMoved,
        onCollectionsReorder: widget.onCollectionsReorder,
        placeholderBuilder: widget.placeholderBuilder,
        emptyLaneBuilder: widget.emptyLaneBuilder,
        laneAddBuilder: widget.laneAddBuilder,
        boardAddBuilder: widget.boardAddBuilder,
        laneDecorationBuilder: widget.laneDecorationBuilder,
        laneAddPlacement: config.laneAddPlacement,
        boardAddPlacement: config.boardAddPlacement,
        addVisibility: config.addVisibility,
        headerPin: config.headerPin,
        scrollIndicator: config.scrollIndicator,
        style: widget.style,
        child: BoardCollectionsView<T>(
          previewLanes: _session.previewLanes(widget.lanes),
          originalLanes: widget.lanes,
          boardController: _boardController,
        ),
      ),
    );
  }
}
