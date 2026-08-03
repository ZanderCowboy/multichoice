import 'package:flutter/material.dart';

import '../drag/edge_drag_scroller.dart';
import '../enums/board_scroll_indicator.dart';
import '../enums/board_slot_placement.dart';
import '../models/board_drag_models.dart';
import '../models/board_lane.dart';
import '../models/board_view_style.dart';
import '../scroll/board_scroll_chrome.dart';
import '../scroll/scrollable_binder.dart';
import 'draggable_board_item.dart';

/// Scrollable item list for a single lane.
class LaneItemsPane<T> extends StatefulWidget {
  const LaneItemsPane({
    required this.lane,
    required this.isVertical,
    required this.itemExtent,
    required this.itemHover,
    required this.itemBuilder,
    required this.placeholderBuilder,
    required this.dragAxis,
    required this.dragEnabled,
    required this.onItemDragStarted,
    required this.onItemDragEnded,
    required this.onHover,
    required this.onAccept,
    required this.itemIdOf,
    required this.originalIndexOf,
    required this.style,
    super.key,
    this.leadingHeader,
    this.shellDecoration,
    this.itemsBodyExtent,
    this.pinHeader = false,
    this.scrollIndicator = BoardScrollIndicator.thumb,
    this.emptyLaneBuilder,
    this.addBuilder,
    this.addPlacement = BoardSlotPlacement.end,
    this.scrollController,
    this.onEdgeScrollerReady,
  });

  final BoardLane<T> lane;
  final bool isVertical;
  final double itemExtent;
  final ItemHoverPreview itemHover;
  final Widget Function(BuildContext context, T item, bool isDragging)
  itemBuilder;
  final Widget Function(BuildContext context) placeholderBuilder;
  final Widget Function(BuildContext context)? emptyLaneBuilder;
  final Widget Function(BuildContext context)? addBuilder;
  final BoardSlotPlacement addPlacement;
  final Axis? dragAxis;
  final bool dragEnabled;
  final ScrollController? scrollController;
  final void Function(EdgeDragScroller scroller)? onEdgeScrollerReady;
  final void Function(ItemDragPayload<T> payload) onItemDragStarted;
  final VoidCallback onItemDragEnded;
  final void Function({
    required String laneId,
    required Offset globalPosition,
    required RenderBox laneBox,
    required int previewItemCount,
    required ScrollController? laneController,
    required double leadingExtent,
  })
  onHover;
  final void Function(ItemDragPayload<T> payload) onAccept;
  final String Function(T item) itemIdOf;
  final int Function(int previewIndex) originalIndexOf;

  /// Optional leading chrome (scrolls with shell, or viewport-pinned).
  final Widget? leadingHeader;

  /// When set, header + items share this decoration and scroll together.
  final BoxDecoration? shellDecoration;

  /// Fixed height of the items row inside an HM scrolling shell.
  final double? itemsBodyExtent;

  /// When true, header stays fixed while items scroll.
  final bool pinHeader;

  /// Overflow chrome for this lane's item scroller.
  final BoardScrollIndicator scrollIndicator;

  final BoardViewStyle style;

  @override
  State<LaneItemsPane<T>> createState() => _LaneItemsPaneState<T>();
}

class _LaneItemsPaneState<T> extends State<LaneItemsPane<T>> {
  final GlobalKey _laneKey = GlobalKey();
  final GlobalKey _headerKey = GlobalKey();

  /// Measured height of the pinned overlay header (0 until first layout).
  double _pinnedHeaderHeight = 0;

  @override
  void didUpdateWidget(covariant LaneItemsPane<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leadingHeader != null && widget.leadingHeader == null) {
      _pinnedHeaderHeight = 0;
    }
  }

  bool get _scrollingShell => widget.shellDecoration != null;

  bool get _hmScrollingShell => _scrollingShell && !widget.isVertical;

  double get _laneScrollPadding => widget.style.laneScrollPadding;

  /// Space reserved for the lane header (pinned overlay or in-shell).
  double get _headerReserve {
    if (widget.leadingHeader == null) return 0;
    if (_pinnedHeaderHeight > 0) return _pinnedHeaderHeight;
    return widget.style.collapsedHeaderCross;
  }

  double get _leadingExtent {
    if (!_scrollingShell) return 0;
    if (_hmScrollingShell) return _laneScrollPadding;
    // VM: start inset + header height (pinned overlay or unpinned in-shell).
    var extent = _laneScrollPadding;
    if (widget.leadingHeader != null) {
      extent += _headerReserve;
    }
    return extent;
  }

  void _scheduleHeaderMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.leadingHeader == null) return;
      final box = _headerKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      final height = box.size.height;
      if ((height - _pinnedHeaderHeight).abs() < 0.5) return;
      setState(() => _pinnedHeaderHeight = height);
    });
  }

  void _handleMove(Offset globalPosition) {
    final box = _laneKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    widget.onHover(
      laneId: widget.lane.id,
      globalPosition: globalPosition,
      laneBox: box,
      previewItemCount: widget.lane.items.length,
      laneController: widget.scrollController,
      leadingExtent: _leadingExtent,
    );
  }

  Widget _buildItem(BuildContext context, int itemIndex) {
    final items = widget.lane.items;
    final item = items[itemIndex];
    final originalIndex = widget.originalIndexOf(itemIndex);
    final payload = ItemDragPayload<T>(
      item: item,
      itemId: widget.itemIdOf(item),
      fromLaneId: widget.lane.id,
      fromIndex: originalIndex,
    );

    return DraggableBoardItem<T>(
      payload: payload,
      axis: widget.dragAxis,
      extent: widget.itemExtent,
      isVertical: widget.isVertical,
      dragEnabled: widget.dragEnabled,
      itemBuilder: widget.itemBuilder,
      style: widget.style,
      onDragStarted: () => widget.onItemDragStarted(payload),
      onDragEnd: widget.onItemDragEnded,
    );
  }

  List<Widget> _buildShellItemChildren({
    required BuildContext context,
    required int? gapIndex,
    required bool horizontal,
  }) {
    final items = widget.lane.items;
    final children = <Widget>[];

    SizedBox wrapChild(Widget child) {
      return SizedBox(
        width: horizontal ? widget.itemExtent : double.infinity,
        height: horizontal ? double.infinity : widget.itemExtent,
        child: child,
      );
    }

    if (items.isEmpty && gapIndex == null) {
      children.add(
        wrapChild(
          widget.emptyLaneBuilder?.call(context) ??
              widget.placeholderBuilder(context),
        ),
      );
    } else {
      final childCount = items.length + (gapIndex != null ? 1 : 0);
      for (var visualIndex = 0; visualIndex < childCount; visualIndex++) {
        if (gapIndex != null && visualIndex == gapIndex) {
          children.add(wrapChild(widget.placeholderBuilder(context)));
          continue;
        }

        final itemIndex = gapIndex != null && visualIndex > gapIndex
            ? visualIndex - 1
            : visualIndex;
        if (itemIndex < 0 || itemIndex >= items.length) continue;

        children.add(wrapChild(_buildItem(context, itemIndex)));
      }
    }

    return children;
  }

  Widget _wrapWithChrome({
    required Widget scrollView,
    required ScrollbarOrientation orientation,
    double? trackInset,
  }) {
    final scrollController = widget.scrollController;
    if (scrollController == null) return scrollView;
    return BoardScrollChrome(
      controller: scrollController,
      indicator: widget.scrollIndicator,
      style: widget.style,
      scrollbarOrientation: orientation,
      trackInset: trackInset ?? _laneScrollPadding,
      child: scrollView,
    );
  }

  /// Opaque backdrop for a viewport-pinned header so scrolling items cannot
  /// show through. Blends a translucent shell tint onto the scaffold surface
  /// so the bar matches the visible shell color. Top corners match the shell
  /// radius so the pinned bar does not square off the shell at rest.
  Widget _opaquePinnedHeader(BuildContext context, Widget header) {
    final shellColor = widget.shellDecoration?.color;
    final surface = Theme.of(context).colorScheme.surface;
    final color = shellColor == null
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Color.alphaBlend(shellColor, surface);
    final topRadius = BorderRadius.vertical(
      top: Radius.circular(widget.style.laneShellRadius),
    );
    return DecoratedBox(
      decoration: BoxDecoration(color: color, borderRadius: topRadius),
      child: ClipRRect(borderRadius: topRadius, child: header),
    );
  }

  /// Items plus optional add slot at [BoardSlotPlacement].
  List<Widget> _shellItemsWithAdd(
    BuildContext context,
    int? gapIndex, {
    required bool horizontal,
  }) {
    var children = _buildShellItemChildren(
      context: context,
      gapIndex: gapIndex,
      horizontal: horizontal,
    );
    final add = widget.addBuilder?.call(context);
    if (add == null) return children;
    return widget.addPlacement == BoardSlotPlacement.start
        ? [add, ...children]
        : [...children, add];
  }

  Widget _edgeScrollerBinder() {
    return ScrollableBinder(
      onReady: (scrollable) {
        widget.onEdgeScrollerReady?.call(
          EdgeDragScroller(scrollable: scrollable),
        );
      },
    );
  }

  Widget _laneScrollView({
    required Axis scrollDirection,
    required EdgeInsetsGeometry padding,
    required CrossAxisAlignment crossAxisAlignment,
    required Widget shell,
  }) {
    return SingleChildScrollView(
      key: _laneKey,
      controller: widget.scrollController,
      scrollDirection: scrollDirection,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          _edgeScrollerBinder(),
          shell,
        ],
      ),
    );
  }

  /// HM: shell fills the lane viewport. Pinned header overlays via [Stack];
  /// unpinned header scrolls with the shell, capped to the visible width.
  Widget _buildHmScrollingShell(BuildContext context, int? gapIndex) {
    final header = widget.leadingHeader;
    final pin = widget.pinHeader;
    final itemChildren = _shellItemsWithAdd(
      context,
      gapIndex,
      horizontal: true,
    );

    _scheduleHeaderMeasure();

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportW = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : 0.0;
        final shellHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : (widget.itemsBodyExtent ?? widget.itemExtent);
        final pad = _laneScrollPadding;
        final minShellWidth = (viewportW - pad * 2).clamp(0.0, double.infinity);
        final headerReserve = header == null ? 0.0 : _headerReserve;
        final bodyHeight = (shellHeight - headerReserve).clamp(
          0.0,
          double.infinity,
        );

        final shell = Container(
          height: shellHeight,
          constraints: BoxConstraints(minWidth: minShellWidth),
          decoration: widget.shellDecoration,
          clipBehavior: Clip.antiAlias,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (pin) ...[
                  if (headerReserve > 0) SizedBox(height: headerReserve),
                ] else if (header != null)
                  // Cap header to visible lane width so labels align across
                  // lanes at rest; do not stretch to item-row width.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: minShellWidth,
                      child: KeyedSubtree(key: _headerKey, child: header),
                    ),
                  ),
                SizedBox(
                  height: bodyHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: itemChildren,
                  ),
                ),
              ],
            ),
          ),
        );

        final scrollView = _laneScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: pad),
          crossAxisAlignment: CrossAxisAlignment.start,
          shell: shell,
        );

        final chromeChild = pin
            ? SizedBox(
                width: viewportW > 0 ? viewportW : null,
                height: shellHeight,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned.fill(child: scrollView),
                    if (header != null)
                      Positioned(
                        left: pad,
                        top: 0,
                        width: minShellWidth,
                        child: KeyedSubtree(
                          key: _headerKey,
                          child: _opaquePinnedHeader(context, header),
                        ),
                      ),
                  ],
                ),
              )
            : scrollView;

        return _wrapWithChrome(
          scrollView: chromeChild,
          orientation: ScrollbarOrientation.bottom,
        );
      },
    );
  }

  /// VM: shell fills at least the lane viewport. Pinned header overlays via
  /// [Stack] (spacer keeps items clear); unpinned header scrolls in-shell.
  Widget _buildVmScrollingShell(BuildContext context, int? gapIndex) {
    final header = widget.leadingHeader;
    final pin = widget.pinHeader;
    final itemChildren = _shellItemsWithAdd(
      context,
      gapIndex,
      horizontal: false,
    );

    if (pin) {
      _scheduleHeaderMeasure();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final pad = _laneScrollPadding;
        final viewportW = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : double.infinity;
        final viewportH = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : 0.0;
        final minShellHeight = constraints.hasBoundedHeight
            ? (viewportH - pad * 2).clamp(0.0, double.infinity)
            : 0.0;
        final headerReserve = header == null ? 0.0 : _headerReserve;

        final shell = Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: minShellHeight),
          decoration: widget.shellDecoration,
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (pin) ...[
                if (headerReserve > 0) SizedBox(height: headerReserve),
              ] else if (header != null)
                KeyedSubtree(key: _headerKey, child: header),
              ...itemChildren,
            ],
          ),
        );

        final scrollView = _laneScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(vertical: pad),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          shell: shell,
        );

        final chromeChild = pin
            ? SizedBox(
                width: viewportW.isFinite ? viewportW : null,
                height: viewportH > 0 ? viewportH : null,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned.fill(child: scrollView),
                    if (header != null)
                      Positioned(
                        top: pad,
                        left: 0,
                        right: 0,
                        child: KeyedSubtree(
                          key: _headerKey,
                          child: _opaquePinnedHeader(context, header),
                        ),
                      ),
                  ],
                ),
              )
            : scrollView;

        return _wrapWithChrome(
          scrollView: chromeChild,
          orientation: ScrollbarOrientation.right,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.itemHover,
      builder: (context, _) {
        final hoverHere = widget.itemHover.laneId == widget.lane.id;
        final gapIndex = hoverHere ? widget.itemHover.index : null;

        return DragTarget<ItemDragPayload<T>>(
          onMove: (details) => _handleMove(details.offset),
          onLeave: (_) {
            if (widget.itemHover.laneId == widget.lane.id) {
              // Keep last index until another lane claims hover or drag ends.
            }
          },
          onAcceptWithDetails: (details) {
            _handleMove(details.offset);
            widget.onAccept(details.data);
          },
          builder: (context, candidate, rejected) {
            assert(
              _scrollingShell,
              'LaneItemsPane expects a scrolling shell decoration',
            );
            if (_hmScrollingShell) {
              return _buildHmScrollingShell(context, gapIndex);
            }
            return _buildVmScrollingShell(context, gapIndex);
          },
        );
      },
    );
  }
}
