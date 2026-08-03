/// Whether the collection header stays fixed while items scroll.
///
/// Applies to both [BoardLayout.vertical] and [BoardLayout.horizontal].
enum BoardHeaderPin {
  /// Header scrolls away with the shell (default).
  unpinned,

  /// Header stays fixed as a viewport overlay; the shell fills the visible
  /// lane and items scroll underneath (both layouts).
  pinned,
}
