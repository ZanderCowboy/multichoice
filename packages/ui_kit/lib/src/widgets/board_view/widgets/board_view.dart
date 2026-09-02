import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../drag/board_drag_session.dart';
import '../enums/board_layout.dart';
import '../enums/drag_axis.dart';
import '../models/board_builders.dart';
import '../models/board_item_move.dart';
import '../models/board_lane.dart';
import '../models/board_view_config.dart';
import '../models/board_view_style.dart';
import 'board_collections_view.dart';
import 'board_delete_bin.dart';
import 'board_view_scope.dart';

part 'board_view_state.dart';

/// A plug-and-play, domain-agnostic drag-and-drop board.
///
/// This is the sole public widget entry point; state, drag session, and scroll
/// helpers are package-private.
///
/// ## Customization
///
/// Required:
/// - [itemBuilder] — full item card chrome ([BoardItemBuilder])
/// - [collectionHeaderBuilder] — header content; place [dragHandle] for reorder
/// - [itemIdOf], [onItemMoved]; optional [onCollectionsReorder]
///
/// Behavior / layout:
/// - [config] — knobs hosts may edit in their own settings UI
///   (defaults to [BoardViewConfig] when omitted)
///
/// Look:
/// - [style] — spacing, radii, and package chrome tokens
///   (defaults to [BoardViewStyle] when omitted)
/// - Builders for items, headers, adds, empty lanes, placeholders, shells
///
/// Optional add slots (visibility controlled by [BoardViewConfig.addVisibility];
/// parent owns mutations):
/// - [laneAddBuilder] (placement from [BoardViewConfig.laneAddPlacement])
/// - [boardAddBuilder] (placement from [BoardViewConfig.boardAddPlacement])
///
/// Optional shell behind each collection's header + items:
/// - [laneDecorationBuilder]; if omitted, [defaultBoardLaneDecoration] is used
///
/// Optional collection-drag chrome:
/// - [collectionDragFeedbackBuilder]; if omitted, the collection header is shown
///
/// The parent owns all data. During an active drag, [BoardView] maintains a
/// local preview (source item collapsed, live insert gap) so hover indices
/// match what the user sees.
///
/// [onItemMoved] receives a [BoardItemMove] whose [BoardItemMove.toIndex] is
/// the **final insertion index after source removal**. Apply with:
/// `removeAt(fromIndex)` then `insert(toIndex, item)`.
///
/// Reorder is only active when [editMode] is true. Add slots follow
/// [BoardViewConfig.addVisibility] (edit-only by default).
class BoardView<T> extends StatefulWidget {
  const BoardView({
    required this.lanes,
    required this.itemIdOf,
    required this.itemBuilder,
    required this.collectionHeaderBuilder,
    required this.onItemMoved,
    super.key,
    this.onCollectionsReorder,
    this.onItemDeleted,
    this.onCollectionDeleted,
    this.placeholderBuilder,
    this.emptyLaneBuilder,
    this.laneAddBuilder,
    this.boardAddBuilder,
    this.laneDecorationBuilder,
    this.collectionDragFeedbackBuilder,
    this.config = const BoardViewConfig(),
    this.style = const BoardViewStyle(),
    this.editMode = false,
    this.laneExtent,
    this.itemExtent = 72,
    this.scrollController,
    this.laneScrollControllers,
  });

  /// Ordered collection lanes.
  final List<BoardLane<T>> lanes;

  /// Stable id for each item (used in move callbacks).
  final String Function(T item) itemIdOf;

  /// Builds an item card. [isDragging] is true for the floating feedback.
  final BoardItemBuilder<T> itemBuilder;

  /// Builds the collection header. Place the provided [dragHandle] so
  /// collection reorder does not fight item drags.
  final BoardCollectionHeaderBuilder<T> collectionHeaderBuilder;

  /// Called when an item is dropped. See [BoardItemMove] for index semantics.
  final void Function(BoardItemMove move) onItemMoved;

  /// Called when a collection is reordered via its header.
  ///
  /// [newIndex] is the final insertion index after removal
  /// (ReorderableListView-style).
  final void Function(int oldIndex, int newIndex)? onCollectionsReorder;

  /// Called when an item is dropped on the delete bin.
  ///
  /// Parent owns confirmation and persistence. When null, item delete via the
  /// bin is disabled.
  final void Function(String itemId, String fromLaneId, int fromIndex)?
      onItemDeleted;

  /// Called when a collection is dropped on the delete bin.
  ///
  /// The lane ghost remains until [BoardCollectionDeletedCallback]'s [resolve]
  /// is called. Pass `true` after confirming deletion, or `false` to restore
  /// the lane. When null, collection delete via the bin is disabled.
  final BoardCollectionDeletedCallback? onCollectionDeleted;

  /// Optional custom insert-gap placeholder.
  final BoardPlaceholderBuilder? placeholderBuilder;

  /// Optional empty-lane affordance when not hovering a gap.
  final BoardEmptyLaneBuilder<T>? emptyLaneBuilder;

  /// Optional "+ item" chip for each lane. Visibility follows
  /// [BoardViewConfig.addVisibility]. Parent owns tap / mutation logic.
  final BoardLaneAddBuilder<T>? laneAddBuilder;

  /// Optional "+ collection" slot on the board. Visibility follows
  /// [BoardViewConfig.addVisibility].
  final BoardAddBuilder? boardAddBuilder;

  /// Optional shell decoration behind header + items for each lane.
  /// If null, [defaultBoardLaneDecoration] is used (radius from [style]).
  final BoardLaneDecorationBuilder<T>? laneDecorationBuilder;

  /// Optional compact feedback under the finger while dragging a collection.
  /// When null, [collectionHeaderBuilder] is used without a drag handle.
  final BoardCollectionDragFeedbackBuilder<T>? collectionDragFeedbackBuilder;

  /// Behavior and layout knobs. Defaults when the host has no settings page.
  final BoardViewConfig config;

  /// Spacing, radii, and package chrome. Defaults when the host does not
  /// customize look tokens.
  final BoardViewStyle style;

  /// When false, items and collections are not draggable. Enter edit mode to
  /// reorder. Add slots follow [BoardViewConfig.addVisibility].
  final bool editMode;

  /// Cross-axis size of each collection (width in vertical layout, height in
  /// horizontal). Defaults: 200 / 160.
  final double? laneExtent;

  /// Fixed extent along the item scroll axis (for reliable insert indexing).
  final double itemExtent;

  /// Outer board scroll controller (collections axis).
  final ScrollController? scrollController;

  /// Optional per-lane item scroll controllers keyed by lane id.
  final Map<String, ScrollController>? laneScrollControllers;

  @override
  State<BoardView<T>> createState() => _BoardViewState<T>();
}
