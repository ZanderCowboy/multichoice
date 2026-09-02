import 'package:flutter/material.dart';

import '../models/board_view_style.dart';
import 'scroll_controller_utils.dart';

/// Edge-aligned, interactive scroll thumb for board and per-lane scroll axes.
///
/// Uses an explicit [Stack] overlay (not [RawScrollbar]) so horizontal thumbs
/// keep a correct cross-axis thickness and sit on the bottom/right edge.
class BoardScrollThumb extends StatefulWidget {
  const BoardScrollThumb({
    required this.controller,
    required this.scrollbarOrientation,
    required this.style,
    required this.child,
    super.key,
    this.trackInset,
  });

  final ScrollController controller;
  final ScrollbarOrientation scrollbarOrientation;
  final BoardViewStyle style;
  final Widget child;

  /// Inset of the thumb track from the leading/trailing edges of the scroll
  /// axis (left/right for horizontal, top/bottom for vertical).
  final double? trackInset;

  bool get _isHorizontal =>
      scrollbarOrientation == ScrollbarOrientation.bottom ||
      scrollbarOrientation == ScrollbarOrientation.top;

  @override
  State<BoardScrollThumb> createState() => _BoardScrollThumbState();
}

class _BoardScrollThumbState extends State<BoardScrollThumb> {
  bool? _lastShow;
  double? _lastPixels;
  double? _lastMaxExtent;
  bool _metricsUpdateScheduled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant BoardScrollThumb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() => _scheduleMetricsUpdate();

  void _scheduleMetricsUpdate() {
    if (_metricsUpdateScheduled) return;
    _metricsUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _metricsUpdateScheduled = false;
      if (!mounted) return;

      final position = primaryScrollPosition(widget.controller);
      final show = position != null &&
          position.hasContentDimensions &&
          position.maxScrollExtent > 0.5;
      final pixels = position?.hasPixels == true ? position!.pixels : 0.0;
      final max = position?.maxScrollExtent ?? 0.0;

      if (_lastShow == show &&
          _lastPixels != null &&
          (pixels - _lastPixels!).abs() < 0.5 &&
          _lastMaxExtent != null &&
          (max - _lastMaxExtent!).abs() < 0.5) {
        return;
      }

      _lastShow = show;
      _lastPixels = pixels;
      _lastMaxExtent = max;
      setState(() {});
    });
  }

  void _onDragUpdate(
    DragUpdateDetails details,
    double trackExtent,
    double thumbExtent,
  ) {
    final c = widget.controller;
    if (!c.hasClients) return;
    final position = primaryScrollPosition(c);
    if (position == null) return;
    final max = position.maxScrollExtent;
    if (max <= 0) return;

    final delta = widget._isHorizontal ? details.delta.dx : details.delta.dy;
    final movable = trackExtent - thumbExtent;
    if (movable <= 0) return;

    final scrollDelta = delta / movable * max;
    c.jumpTo((c.offset + scrollDelta).clamp(0.0, max));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = widget.style;
    final thickness = style.scrollThumbThickness;
    final edgePadding = style.scrollThumbEdgePadding;
    final inset = widget.trackInset ?? edgePadding;
    final thumbColor = style.scrollThumbColor ??
        scheme.onSurfaceVariant.withValues(alpha: style.scrollThumbOpacity);

    return LayoutBuilder(
      builder: (context, constraints) {
        final c = widget.controller;
        final position = primaryScrollPosition(c);
        final show = position != null &&
            position.hasContentDimensions &&
            position.maxScrollExtent > 0.5;

        Widget? thumb;
        if (show) {
          final max = position.maxScrollExtent;
          final viewport = position.viewportDimension;
          final content = max + viewport;
          final trackExtent = widget._isHorizontal
              ? constraints.maxWidth - inset * 2
              : constraints.maxHeight - inset * 2;

          final fraction = (viewport / content).clamp(0.0, 1.0);
          final thumbExtent = (trackExtent * fraction).clamp(
            style.scrollThumbMinExtent,
            trackExtent,
          );
          final movable = trackExtent - thumbExtent;
          final pixels = position.hasPixels ? position.pixels : 0.0;
          final thumbOffset = max <= 0
              ? 0.0
              : (pixels / max).clamp(0.0, 1.0) * movable;

          final thumbPaint = Container(
            width: widget._isHorizontal ? thumbExtent : thickness,
            height: widget._isHorizontal ? thickness : thumbExtent,
            decoration: BoxDecoration(
              color: thumbColor,
              borderRadius: BorderRadius.circular(thickness),
            ),
          );

          final draggable = GestureDetector(
            onHorizontalDragUpdate: widget._isHorizontal
                ? (d) => _onDragUpdate(d, trackExtent, thumbExtent)
                : null,
            onVerticalDragUpdate: widget._isHorizontal
                ? null
                : (d) => _onDragUpdate(d, trackExtent, thumbExtent),
            child: thumbPaint,
          );

          thumb = switch (widget.scrollbarOrientation) {
            ScrollbarOrientation.bottom => Positioned(
              left: inset + thumbOffset,
              bottom: edgePadding,
              child: draggable,
            ),
            ScrollbarOrientation.top => Positioned(
              left: inset + thumbOffset,
              top: edgePadding,
              child: draggable,
            ),
            ScrollbarOrientation.right => Positioned(
              top: inset + thumbOffset,
              right: edgePadding,
              child: draggable,
            ),
            ScrollbarOrientation.left => Positioned(
              top: inset + thumbOffset,
              left: edgePadding,
              child: draggable,
            ),
          };
        }

        return NotificationListener<ScrollMetricsNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis ==
                (widget._isHorizontal ? Axis.horizontal : Axis.vertical)) {
              _scheduleMetricsUpdate();
            }
            return false;
          },
          child: Stack(children: [widget.child, ?thumb]),
        );
      },
    );
  }
}
