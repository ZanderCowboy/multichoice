import 'package:flutter/material.dart';

import '../models/board_view_style.dart';

/// Edge arrows that appear when the [controller] can scroll in that direction.
///
/// Tap nudges by roughly one [ScrollPosition.viewportDimension].
class BoardScrollArrows extends StatefulWidget {
  const BoardScrollArrows({
    required this.controller,
    required this.scrollbarOrientation,
    required this.style,
    required this.child,
    super.key,
  });

  final ScrollController controller;
  final ScrollbarOrientation scrollbarOrientation;
  final BoardViewStyle style;
  final Widget child;

  static const double _epsilon = 0.5;
  static const Duration _nudgeDuration = Duration(milliseconds: 250);

  bool get _isHorizontal =>
      scrollbarOrientation == ScrollbarOrientation.bottom ||
      scrollbarOrientation == ScrollbarOrientation.top;

  @override
  State<BoardScrollArrows> createState() => _BoardScrollArrowsState();
}

class _BoardScrollArrowsState extends State<BoardScrollArrows> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant BoardScrollArrows oldWidget) {
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

  void _onScroll() {
    if (mounted) setState(() {});
  }

  Future<void> _nudge(double direction) async {
    final c = widget.controller;
    if (!c.hasClients) return;
    final position = c.position;
    if (!position.hasContentDimensions || !position.hasPixels) return;
    final max = position.maxScrollExtent;
    if (max <= BoardScrollArrows._epsilon) return;

    final target =
        (position.pixels + direction * position.viewportDimension).clamp(
      0.0,
      max,
    );
    await c.animateTo(
      target,
      duration: BoardScrollArrows._nudgeDuration,
      curve: Curves.easeOut,
    );
  }

  Widget _arrowButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final style = widget.style;
    return Material(
      color: style.scrollArrowBackgroundColor ?? scheme.surface,
      elevation: style.scrollArrowElevation,
      shape: const CircleBorder(),
      child: Semantics(
        label: label,
        button: true,
        child: Tooltip(
          message: label,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(style.scrollArrowPadding),
              child: Icon(
                icon,
                size: style.scrollArrowIconSize,
                color: style.scrollArrowIconColor ?? scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final position = c.hasClients ? c.position : null;
    final metricsReady =
        position != null && position.hasContentDimensions;
    final showable =
        metricsReady && position.maxScrollExtent > BoardScrollArrows._epsilon;
    final pixels = metricsReady && position.hasPixels ? position.pixels : 0.0;
    final showStart = showable && pixels > BoardScrollArrows._epsilon;
    final showEnd = showable &&
        pixels < position.maxScrollExtent - BoardScrollArrows._epsilon;

    final horizontal = widget._isHorizontal;
    final startIcon = horizontal
        ? Icons.keyboard_arrow_left
        : Icons.keyboard_arrow_up;
    final endIcon = horizontal
        ? Icons.keyboard_arrow_right
        : Icons.keyboard_arrow_down;
    final startLabel = horizontal ? 'Scroll left' : 'Scroll up';
    final endLabel = horizontal ? 'Scroll right' : 'Scroll down';
    final arrowInset = widget.style.scrollArrowPadding;

    Widget? startArrow;
    Widget? endArrow;

    if (showStart) {
      final button = _arrowButton(
        icon: startIcon,
        label: startLabel,
        onTap: () => _nudge(-1),
      );
      startArrow = switch (widget.scrollbarOrientation) {
        ScrollbarOrientation.bottom || ScrollbarOrientation.top => Positioned(
            left: arrowInset,
            top: 0,
            bottom: 0,
            child: Center(child: button),
          ),
        ScrollbarOrientation.left || ScrollbarOrientation.right => Positioned(
            top: arrowInset,
            left: 0,
            right: 0,
            child: Center(child: button),
          ),
      };
    }

    if (showEnd) {
      final button = _arrowButton(
        icon: endIcon,
        label: endLabel,
        onTap: () => _nudge(1),
      );
      endArrow = switch (widget.scrollbarOrientation) {
        ScrollbarOrientation.bottom || ScrollbarOrientation.top => Positioned(
            right: arrowInset,
            top: 0,
            bottom: 0,
            child: Center(child: button),
          ),
        ScrollbarOrientation.left || ScrollbarOrientation.right => Positioned(
            bottom: arrowInset,
            left: 0,
            right: 0,
            child: Center(child: button),
          ),
      };
    }

    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis ==
            (horizontal ? Axis.horizontal : Axis.vertical)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() {});
          });
        }
        return false;
      },
      child: Stack(
        children: [
          widget.child,
          ?startArrow,
          ?endArrow,
        ],
      ),
    );
  }
}
