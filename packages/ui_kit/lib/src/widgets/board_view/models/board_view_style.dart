import 'package:flutter/painting.dart';

/// Look tokens for [BoardView] spacing, radii, and package chrome.
///
/// Apps own look: pass a custom [BoardViewStyle], or rely on these defaults.
/// Content chrome (items, headers, adds) still comes from builders.
class BoardViewStyle {
  const BoardViewStyle({
    this.collectionsAlongPadding = 8,
    this.laneAlongPadding = 4,
    this.laneScrollPadding = 12,
    this.laneShellRadius = 12,
    this.collapsedHeaderCross = 48,
    this.laneDragGhostOpacity = 0.45,
    this.collectionGapExtent = 48,
    this.scrollThumbThickness = 12,
    this.scrollThumbMinExtent = 40,
    this.scrollThumbEdgePadding = 2,
    this.scrollThumbOpacity = 0.55,
    this.scrollThumbColor,
    this.scrollArrowIconSize = 22,
    this.scrollArrowPadding = 4,
    this.scrollArrowElevation = 1,
    this.scrollArrowIconColor,
    this.scrollArrowBackgroundColor,
    this.dragHandleIconSize = 22,
    this.dragHandleIconColor,
    this.dragHandleFeedbackElevation = 4,
    this.dragHandleFeedbackRadius = 8,
    this.dragHandleFeedbackPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    this.dragHandleFeedbackColor,
    this.itemDragPadding = const EdgeInsets.all(4),
    this.itemDragFeedbackElevation = 6,
    this.deleteBinIdleSize = 60,
    this.deleteBinActiveSize = 96,
    this.deleteBinBottomInset = 16,
  });

  /// Along-axis inset for the board collections scroller.
  final double collectionsAlongPadding;

  /// Along-axis outer margin per collection lane (gap between shells).
  final double laneAlongPadding;

  /// Start/end inset for lane scrollers (shell + items).
  final double laneScrollPadding;

  /// Corner radius for collection shells and pinned-header top corners.
  final double laneShellRadius;

  /// Fallback header reserve before the header is measured.
  final double collapsedHeaderCross;

  /// Opacity of the lane ghost shown at the collection insert gap.
  final double laneDragGhostOpacity;

  /// Insert-gap extent between collections during collection drag.
  final double collectionGapExtent;

  /// Cross-axis size of the scroll thumb.
  final double scrollThumbThickness;

  /// Minimum thumb extent along the scroll axis.
  final double scrollThumbMinExtent;

  /// Inset of the thumb from the viewport edge (cross-axis).
  final double scrollThumbEdgePadding;

  /// Opacity applied when [scrollThumbColor] is null (Theme-derived).
  final double scrollThumbOpacity;

  /// Thumb fill color. When null, uses `onSurfaceVariant` at [scrollThumbOpacity].
  final Color? scrollThumbColor;

  final double scrollArrowIconSize;
  final double scrollArrowPadding;
  final double scrollArrowElevation;
  final Color? scrollArrowIconColor;
  final Color? scrollArrowBackgroundColor;

  final double dragHandleIconSize;
  final Color? dragHandleIconColor;
  final double dragHandleFeedbackElevation;
  final double dragHandleFeedbackRadius;
  final EdgeInsets dragHandleFeedbackPadding;
  final Color? dragHandleFeedbackColor;

  final EdgeInsets itemDragPadding;
  final double itemDragFeedbackElevation;

  /// Compact delete-bin diameter while idle in edit mode.
  final double deleteBinIdleSize;

  /// Expanded delete-bin diameter while a drag is active.
  final double deleteBinActiveSize;

  /// Bottom inset for the floating delete bin.
  final double deleteBinBottomInset;

  BoardViewStyle copyWith({
    double? collectionsAlongPadding,
    double? laneAlongPadding,
    double? laneScrollPadding,
    double? laneShellRadius,
    double? collapsedHeaderCross,
    double? laneDragGhostOpacity,
    double? collectionGapExtent,
    double? scrollThumbThickness,
    double? scrollThumbMinExtent,
    double? scrollThumbEdgePadding,
    double? scrollThumbOpacity,
    Color? scrollThumbColor,
    double? scrollArrowIconSize,
    double? scrollArrowPadding,
    double? scrollArrowElevation,
    Color? scrollArrowIconColor,
    Color? scrollArrowBackgroundColor,
    double? dragHandleIconSize,
    Color? dragHandleIconColor,
    double? dragHandleFeedbackElevation,
    double? dragHandleFeedbackRadius,
    EdgeInsets? dragHandleFeedbackPadding,
    Color? dragHandleFeedbackColor,
    EdgeInsets? itemDragPadding,
    double? itemDragFeedbackElevation,
    double? deleteBinIdleSize,
    double? deleteBinActiveSize,
    double? deleteBinBottomInset,
  }) {
    return BoardViewStyle(
      collectionsAlongPadding:
          collectionsAlongPadding ?? this.collectionsAlongPadding,
      laneAlongPadding: laneAlongPadding ?? this.laneAlongPadding,
      laneScrollPadding: laneScrollPadding ?? this.laneScrollPadding,
      laneShellRadius: laneShellRadius ?? this.laneShellRadius,
      collapsedHeaderCross: collapsedHeaderCross ?? this.collapsedHeaderCross,
      laneDragGhostOpacity: laneDragGhostOpacity ?? this.laneDragGhostOpacity,
      collectionGapExtent: collectionGapExtent ?? this.collectionGapExtent,
      scrollThumbThickness: scrollThumbThickness ?? this.scrollThumbThickness,
      scrollThumbMinExtent: scrollThumbMinExtent ?? this.scrollThumbMinExtent,
      scrollThumbEdgePadding:
          scrollThumbEdgePadding ?? this.scrollThumbEdgePadding,
      scrollThumbOpacity: scrollThumbOpacity ?? this.scrollThumbOpacity,
      scrollThumbColor: scrollThumbColor ?? this.scrollThumbColor,
      scrollArrowIconSize: scrollArrowIconSize ?? this.scrollArrowIconSize,
      scrollArrowPadding: scrollArrowPadding ?? this.scrollArrowPadding,
      scrollArrowElevation: scrollArrowElevation ?? this.scrollArrowElevation,
      scrollArrowIconColor: scrollArrowIconColor ?? this.scrollArrowIconColor,
      scrollArrowBackgroundColor:
          scrollArrowBackgroundColor ?? this.scrollArrowBackgroundColor,
      dragHandleIconSize: dragHandleIconSize ?? this.dragHandleIconSize,
      dragHandleIconColor: dragHandleIconColor ?? this.dragHandleIconColor,
      dragHandleFeedbackElevation:
          dragHandleFeedbackElevation ?? this.dragHandleFeedbackElevation,
      dragHandleFeedbackRadius:
          dragHandleFeedbackRadius ?? this.dragHandleFeedbackRadius,
      dragHandleFeedbackPadding:
          dragHandleFeedbackPadding ?? this.dragHandleFeedbackPadding,
      dragHandleFeedbackColor:
          dragHandleFeedbackColor ?? this.dragHandleFeedbackColor,
      itemDragPadding: itemDragPadding ?? this.itemDragPadding,
      itemDragFeedbackElevation:
          itemDragFeedbackElevation ?? this.itemDragFeedbackElevation,
      deleteBinIdleSize: deleteBinIdleSize ?? this.deleteBinIdleSize,
      deleteBinActiveSize: deleteBinActiveSize ?? this.deleteBinActiveSize,
      deleteBinBottomInset: deleteBinBottomInset ?? this.deleteBinBottomInset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoardViewStyle &&
        other.collectionsAlongPadding == collectionsAlongPadding &&
        other.laneAlongPadding == laneAlongPadding &&
        other.laneScrollPadding == laneScrollPadding &&
        other.laneShellRadius == laneShellRadius &&
        other.collapsedHeaderCross == collapsedHeaderCross &&
        other.laneDragGhostOpacity == laneDragGhostOpacity &&
        other.collectionGapExtent == collectionGapExtent &&
        other.scrollThumbThickness == scrollThumbThickness &&
        other.scrollThumbMinExtent == scrollThumbMinExtent &&
        other.scrollThumbEdgePadding == scrollThumbEdgePadding &&
        other.scrollThumbOpacity == scrollThumbOpacity &&
        other.scrollThumbColor == scrollThumbColor &&
        other.scrollArrowIconSize == scrollArrowIconSize &&
        other.scrollArrowPadding == scrollArrowPadding &&
        other.scrollArrowElevation == scrollArrowElevation &&
        other.scrollArrowIconColor == scrollArrowIconColor &&
        other.scrollArrowBackgroundColor == scrollArrowBackgroundColor &&
        other.dragHandleIconSize == dragHandleIconSize &&
        other.dragHandleIconColor == dragHandleIconColor &&
        other.dragHandleFeedbackElevation == dragHandleFeedbackElevation &&
        other.dragHandleFeedbackRadius == dragHandleFeedbackRadius &&
        other.dragHandleFeedbackPadding == dragHandleFeedbackPadding &&
        other.dragHandleFeedbackColor == dragHandleFeedbackColor &&
        other.itemDragPadding == itemDragPadding &&
        other.itemDragFeedbackElevation == itemDragFeedbackElevation &&
        other.deleteBinIdleSize == deleteBinIdleSize &&
        other.deleteBinActiveSize == deleteBinActiveSize &&
        other.deleteBinBottomInset == deleteBinBottomInset;
  }

  @override
  int get hashCode => Object.hashAll([
    collectionsAlongPadding,
    laneAlongPadding,
    laneScrollPadding,
    laneShellRadius,
    collapsedHeaderCross,
    laneDragGhostOpacity,
    collectionGapExtent,
    scrollThumbThickness,
    scrollThumbMinExtent,
    scrollThumbEdgePadding,
    scrollThumbOpacity,
    scrollThumbColor,
    scrollArrowIconSize,
    scrollArrowPadding,
    scrollArrowElevation,
    scrollArrowIconColor,
    scrollArrowBackgroundColor,
    dragHandleIconSize,
    dragHandleIconColor,
    dragHandleFeedbackElevation,
    dragHandleFeedbackRadius,
    dragHandleFeedbackPadding,
    dragHandleFeedbackColor,
    itemDragPadding,
    itemDragFeedbackElevation,
    deleteBinIdleSize,
    deleteBinActiveSize,
    deleteBinBottomInset,
  ]);
}
