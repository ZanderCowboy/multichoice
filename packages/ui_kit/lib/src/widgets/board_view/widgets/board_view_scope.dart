import 'package:flutter/widgets.dart';

import '../drag/board_drag_session.dart';
import '../enums/board_add_visibility.dart';
import '../enums/board_header_pin.dart';
import '../enums/board_scroll_indicator.dart';
import '../enums/board_slot_placement.dart';
import '../models/board_builders.dart';
import '../models/board_item_move.dart';
import '../models/board_view_style.dart';

/// Shared [BoardView] dependencies for descendant widgets.
///
/// Avoids threading config, builders, and session through every intermediate
/// constructor. Look up with [BoardViewScope.of].
class BoardViewScope<T> extends InheritedWidget {
  const BoardViewScope({
    required this.session,
    required this.isVertical,
    required this.laneExtent,
    required this.itemExtent,
    required this.editMode,
    required this.dragAxis,
    required this.itemBuilder,
    required this.collectionHeaderBuilder,
    required this.itemIdOf,
    required this.laneControllerFor,
    required this.onItemMoved,
    required this.style,
    required this.laneAddPlacement,
    required this.boardAddPlacement,
    required this.addVisibility,
    required this.headerPin,
    required this.scrollIndicator,
    required super.child,
    super.key,
    this.onCollectionsReorder,
    this.placeholderBuilder,
    this.emptyLaneBuilder,
    this.laneAddBuilder,
    this.boardAddBuilder,
    this.laneDecorationBuilder,
  });

  final BoardDragSession<T> session;
  final bool isVertical;
  final double laneExtent;
  final double itemExtent;

  /// When false, items and collections are not draggable.
  final bool editMode;

  /// Same as [editMode]; kept as a named alias for drag-enable call sites.
  bool get canReorder => editMode;

  final Axis? dragAxis;
  final BoardItemBuilder<T> itemBuilder;
  final BoardCollectionHeaderBuilder<T> collectionHeaderBuilder;
  final String Function(T item) itemIdOf;
  final ScrollController Function(String laneId) laneControllerFor;
  final void Function(BoardItemMove move) onItemMoved;
  final void Function(int oldIndex, int newIndex)? onCollectionsReorder;
  final BoardPlaceholderBuilder? placeholderBuilder;
  final BoardEmptyLaneBuilder<T>? emptyLaneBuilder;
  final BoardLaneAddBuilder<T>? laneAddBuilder;
  final BoardAddBuilder? boardAddBuilder;
  final BoardLaneDecorationBuilder<T>? laneDecorationBuilder;
  final BoardSlotPlacement laneAddPlacement;
  final BoardSlotPlacement boardAddPlacement;
  final BoardAddVisibility addVisibility;
  final BoardHeaderPin headerPin;
  final BoardScrollIndicator scrollIndicator;
  final BoardViewStyle style;

  static BoardViewScope<T> of<T>(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<BoardViewScope<T>>();
    assert(
      scope != null,
      'BoardViewScope<$T> not found. Ensure the widget is under BoardView.',
    );
    return scope!;
  }

  @override
  bool updateShouldNotify(BoardViewScope<T> oldWidget) {
    return session != oldWidget.session ||
        isVertical != oldWidget.isVertical ||
        laneExtent != oldWidget.laneExtent ||
        itemExtent != oldWidget.itemExtent ||
        editMode != oldWidget.editMode ||
        dragAxis != oldWidget.dragAxis ||
        itemBuilder != oldWidget.itemBuilder ||
        collectionHeaderBuilder != oldWidget.collectionHeaderBuilder ||
        itemIdOf != oldWidget.itemIdOf ||
        laneControllerFor != oldWidget.laneControllerFor ||
        onItemMoved != oldWidget.onItemMoved ||
        onCollectionsReorder != oldWidget.onCollectionsReorder ||
        placeholderBuilder != oldWidget.placeholderBuilder ||
        emptyLaneBuilder != oldWidget.emptyLaneBuilder ||
        laneAddBuilder != oldWidget.laneAddBuilder ||
        boardAddBuilder != oldWidget.boardAddBuilder ||
        laneDecorationBuilder != oldWidget.laneDecorationBuilder ||
        laneAddPlacement != oldWidget.laneAddPlacement ||
        boardAddPlacement != oldWidget.boardAddPlacement ||
        addVisibility != oldWidget.addVisibility ||
        headerPin != oldWidget.headerPin ||
        scrollIndicator != oldWidget.scrollIndicator ||
        style != oldWidget.style;
  }
}
