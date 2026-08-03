/// Public API for the domain-agnostic [BoardView] platform.
///
/// Hosts should depend only on symbols re-exported here (via `package:ui_kit`).
/// Drag session, scroll helpers, and lane chrome widgets under this folder are
/// implementation details and are not part of the supported surface.
///
/// ## Surface
///
/// Widget / models:
/// - [BoardView], [BoardLane], [BoardItemMove]
/// - [BoardViewConfig], [BoardViewStyle]
/// - [DefaultBoardPlaceholder], [defaultBoardLaneDecoration]
/// - Builder typedefs in `board_builders.dart`
///
/// Config enums:
/// - [BoardLayout], [BoardSlotPlacement], [BoardAddVisibility]
/// - [BoardHeaderPin], [DragAxis], [BoardScrollIndicator]
library;

export 'enums/board_add_visibility.dart';
export 'enums/board_header_pin.dart';
export 'enums/board_layout.dart';
export 'enums/board_scroll_indicator.dart';
export 'enums/board_slot_placement.dart';
export 'enums/drag_axis.dart';
export 'models/board_builders.dart';
export 'models/board_item_move.dart';
export 'models/board_lane.dart';
export 'models/board_view_config.dart';
export 'models/board_view_style.dart';
export 'widgets/board_view.dart';
export 'widgets/default_placeholder.dart';
