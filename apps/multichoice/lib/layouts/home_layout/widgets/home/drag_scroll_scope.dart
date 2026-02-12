import 'package:flutter/material.dart';

/// Provides callbacks so that a draggable child can report drag position
/// and the vertical home can scroll the collections list when near edges.
class DragScrollScope extends InheritedWidget {
  const DragScrollScope({
    required this.onDragStarted,
    required this.onDragEnd,
    required this.onDragUpdate,
    required super.child,
    super.key,
  });

  final VoidCallback onDragStarted;
  final VoidCallback onDragEnd;
  final void Function(Offset globalPosition) onDragUpdate;

  static DragScrollScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DragScrollScope>();
  }

  @override
  bool updateShouldNotify(DragScrollScope oldWidget) {
    return onDragStarted != oldWidget.onDragStarted ||
        onDragEnd != oldWidget.onDragEnd ||
        onDragUpdate != oldWidget.onDragUpdate;
  }
}
