import 'package:flutter/material.dart';

import 'board_lane.dart';

/// Builds an item card. [isDragging] is true for the floating drag feedback.
///
/// Caller owns full card chrome. Prefer a height/width that fits [BoardView.itemExtent].
typedef BoardItemBuilder<T> =
    Widget Function(BuildContext context, T item, bool isDragging);

/// Builds a collection header.
///
/// Place [dragHandle] in the header when collection reorder is enabled so
/// collection drags do not fight item drags.
typedef BoardCollectionHeaderBuilder<T> =
    Widget Function(
      BuildContext context,
      BoardLane<T> lane,
      int index,
      Widget dragHandle,
    );

/// Optional "+ item" affordance for a lane. Parent owns tap / create logic.
typedef BoardLaneAddBuilder<T> =
    Widget Function(BuildContext context, BoardLane<T> lane);

/// Optional "+ collection" affordance for the board. Parent owns tap / create.
typedef BoardAddBuilder = Widget Function(BuildContext context);

/// Optional shell decoration behind a lane's header and items body.
typedef BoardLaneDecorationBuilder<T> =
    BoxDecoration Function(BuildContext context, BoardLane<T> lane);

/// Optional empty-lane affordance when not hovering an insert gap.
typedef BoardEmptyLaneBuilder<T> =
    Widget Function(BuildContext context, BoardLane<T> lane);

/// Optional custom insert-gap placeholder.
typedef BoardPlaceholderBuilder =
    Widget Function(BuildContext context, {double? width, double? height});

/// Default collection shell when [BoardView.laneDecorationBuilder] is omitted.
BoxDecoration defaultBoardLaneDecoration(
  BuildContext context, {
  double laneShellRadius = 12,
}) {
  return BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(laneShellRadius),
  );
}
