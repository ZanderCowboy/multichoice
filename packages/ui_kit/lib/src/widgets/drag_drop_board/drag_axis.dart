/// Controls which direction(s) a dragged item can move.
enum DragAxis {
  /// Only horizontal movement (e.g. lanes in a row).
  horizontal,

  /// Only vertical movement (e.g. items in a column).
  vertical,

  /// Unrestricted movement in both directions.
  multi,
}
