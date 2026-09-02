import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Auto-scrolls [scrollable] while a drag pointer is near (or past) an edge.
///
/// Package-private helper used by BoardView — not part of the public
/// `board_view` API (see `export.dart`).
///
/// Keeps scrolling when the pointer leaves the scrollable along the scroll
/// axis so collections/items beyond the viewport stay reachable. Stops only at
/// scroll extent limits, or when the pointer leaves far off the cross-axis.
class EdgeDragScroller {
  EdgeDragScroller({
    required this.scrollable,
    this.edgeZone = 96,
    this.maxVelocity = 1600,
  });

  final ScrollableState scrollable;

  /// Distance from an edge (px) that starts auto-scroll.
  final double edgeZone;

  /// Peak scroll speed in px/s when the pointer is at/past the edge.
  final double maxVelocity;

  bool _isDragging = false;
  double _velocity = 0;
  bool _frameScheduled = false;
  Duration? _lastTimestamp;

  /// Viewport box when [scrollable] is still mounted and laid out.
  ///
  /// Pointer routes and drag targets can fire after preview rebuilds unmount
  /// the source lane/board scroller; never read [State.context] without this.
  RenderBox? get viewportBox {
    if (!scrollable.mounted) return null;
    final box = scrollable.context.findRenderObject();
    return box is RenderBox && box.hasSize ? box : null;
  }

  void onDragStart() {
    _isDragging = true;
    _velocity = 0;
    _lastTimestamp = null;
  }

  void onDragUpdate(Offset globalPosition) {
    if (!_isDragging) return;

    final box = viewportBox;
    if (box == null) {
      _velocity = 0;
      return;
    }

    final position = scrollable.position;
    if (!position.hasPixels || !position.hasContentDimensions) {
      _velocity = 0;
      return;
    }

    final local = box.globalToLocal(globalPosition);
    final size = box.size;
    final horizontal = position.axis == Axis.horizontal;

    // Abort if the pointer is far away on the cross-axis.
    final cross = horizontal ? local.dy : local.dx;
    final crossExtent = horizontal ? size.height : size.width;
    if (cross < -64 || cross > crossExtent + 64) {
      _velocity = 0;
      return;
    }

    final along = horizontal ? local.dx : local.dy;
    final extent = horizontal ? size.width : size.height;

    final atStart = position.pixels <= position.minScrollExtent + 0.5;
    final atEnd = position.pixels >= position.maxScrollExtent - 0.5;

    var velocity = 0.0;

    // Leading edge: in zone or past the start.
    if (along < edgeZone) {
      if (!atStart) {
        final depth = (edgeZone - along).clamp(0.0, edgeZone * 2);
        velocity = -maxVelocity * (depth / edgeZone).clamp(0.0, 2.0);
      }
    }
    // Trailing edge: in zone or past the end.
    else if (along > extent - edgeZone) {
      if (!atEnd) {
        final depth =
            (along - (extent - edgeZone)).clamp(0.0, edgeZone * 2);
        velocity = maxVelocity * (depth / edgeZone).clamp(0.0, 2.0);
      }
    }

    _velocity = velocity;
    if (_velocity != 0) {
      _scheduleFrame();
    }
  }

  void onDragEnd() {
    _isDragging = false;
    _velocity = 0;
    _lastTimestamp = null;
  }

  void dispose() {
    onDragEnd();
  }

  void _scheduleFrame() {
    if (_frameScheduled || !_isDragging) return;
    _frameScheduled = true;
    SchedulerBinding.instance.scheduleFrameCallback(_onFrame);
  }

  void _onFrame(Duration timestamp) {
    _frameScheduled = false;
    if (!_isDragging || _velocity == 0 || !scrollable.mounted) {
      _lastTimestamp = null;
      if (!scrollable.mounted) {
        onDragEnd();
      }
      return;
    }

    final last = _lastTimestamp;
    _lastTimestamp = timestamp;
    if (last == null) {
      _scheduleFrame();
      return;
    }

    final dt = (timestamp - last).inMicroseconds / 1e6;
    if (dt <= 0 || dt > 0.1) {
      _scheduleFrame();
      return;
    }

    final position = scrollable.position;
    if (!position.hasPixels) {
      _velocity = 0;
      return;
    }

    final next = (position.pixels + _velocity * dt).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((next - position.pixels).abs() < 0.05) {
      _velocity = 0;
      return;
    }
    if (!scrollable.mounted) {
      onDragEnd();
      return;
    }
    position.jumpTo(next);
    _scheduleFrame();
  }
}
