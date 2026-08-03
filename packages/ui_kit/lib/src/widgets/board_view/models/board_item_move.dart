/// Canonical description of an item move between (or within) lanes.
///
/// [toIndex] is the **final insertion index after the item has been removed**
/// from its source position. Parents should apply:
///
/// ```dart
/// final item = fromLane.removeAt(fromIndex);
/// toLane.insert(toIndex, item);
/// ```
///
/// Same-lane moves already use ReorderableListView-style semantics: the
/// index accounts for the source removal, so no further adjustment is needed.
class BoardItemMove {
  const BoardItemMove({
    required this.itemId,
    required this.fromLaneId,
    required this.fromIndex,
    required this.toLaneId,
    required this.toIndex,
  });

  final String itemId;
  final String fromLaneId;
  final int fromIndex;
  final String toLaneId;
  final int toIndex;

  @override
  String toString() =>
      'BoardItemMove($itemId: $fromLaneId[$fromIndex] → $toLaneId[$toIndex])';
}
