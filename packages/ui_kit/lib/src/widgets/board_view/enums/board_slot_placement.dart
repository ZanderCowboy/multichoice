/// Where an add affordance sits relative to its siblings.
///
/// Used for per-lane item add slots and the board-level add-collection slot.
/// Placement is board-wide (same for every lane / for the whole board).
enum BoardSlotPlacement {
  /// Before items / before collections.
  start,

  /// After items / after collections.
  end,
}
