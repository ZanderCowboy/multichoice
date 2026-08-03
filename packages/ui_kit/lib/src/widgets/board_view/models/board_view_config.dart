import '../enums/board_add_visibility.dart';
import '../enums/board_header_pin.dart';
import '../enums/board_layout.dart';
import '../enums/board_scroll_indicator.dart';
import '../enums/board_slot_placement.dart';
import '../enums/drag_axis.dart';

/// Behavior and layout knobs for [BoardView].
///
/// Hosts may persist this DTO and edit it in their own settings UI. When no
/// custom config is supplied, [BoardView] uses [BoardViewConfig] defaults.
class BoardViewConfig {
  const BoardViewConfig({
    this.layout = BoardLayout.vertical,
    this.laneAddPlacement = BoardSlotPlacement.end,
    this.boardAddPlacement = BoardSlotPlacement.end,
    this.addVisibility = BoardAddVisibility.editOnly,
    this.headerPin = BoardHeaderPin.unpinned,
    this.dragAxis = DragAxis.multi,
    this.scrollIndicator = BoardScrollIndicator.thumb,
  });

  /// Board orientation (columns vs rows).
  final BoardLayout layout;

  /// Where the per-lane item add slot sits.
  final BoardSlotPlacement laneAddPlacement;

  /// Where the board-level add-collection slot sits.
  final BoardSlotPlacement boardAddPlacement;

  /// Whether add buttons require edit mode or are always shown.
  final BoardAddVisibility addVisibility;

  /// Whether collection headers stay pinned while items scroll.
  final BoardHeaderPin headerPin;

  /// Item drag axis constraint.
  final DragAxis dragAxis;

  /// Board and per-lane scroll overflow chrome.
  final BoardScrollIndicator scrollIndicator;

  BoardViewConfig copyWith({
    BoardLayout? layout,
    BoardSlotPlacement? laneAddPlacement,
    BoardSlotPlacement? boardAddPlacement,
    BoardAddVisibility? addVisibility,
    BoardHeaderPin? headerPin,
    DragAxis? dragAxis,
    BoardScrollIndicator? scrollIndicator,
  }) {
    return BoardViewConfig(
      layout: layout ?? this.layout,
      laneAddPlacement: laneAddPlacement ?? this.laneAddPlacement,
      boardAddPlacement: boardAddPlacement ?? this.boardAddPlacement,
      addVisibility: addVisibility ?? this.addVisibility,
      headerPin: headerPin ?? this.headerPin,
      dragAxis: dragAxis ?? this.dragAxis,
      scrollIndicator: scrollIndicator ?? this.scrollIndicator,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BoardViewConfig &&
        other.layout == layout &&
        other.laneAddPlacement == laneAddPlacement &&
        other.boardAddPlacement == boardAddPlacement &&
        other.addVisibility == addVisibility &&
        other.headerPin == headerPin &&
        other.dragAxis == dragAxis &&
        other.scrollIndicator == scrollIndicator;
  }

  @override
  int get hashCode => Object.hash(
        layout,
        laneAddPlacement,
        boardAddPlacement,
        addVisibility,
        headerPin,
        dragAxis,
        scrollIndicator,
      );
}
