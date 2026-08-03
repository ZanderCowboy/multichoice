/// A lane (collection) containing draggable items of type [T].
class BoardLane<T> {
  const BoardLane({
    required this.id,
    required this.items,
  });

  /// Stable identifier for this lane.
  final String id;

  /// Ordered items in this lane.
  final List<T> items;

  BoardLane<T> copyWith({
    String? id,
    List<T>? items,
  }) {
    return BoardLane<T>(
      id: id ?? this.id,
      items: items ?? this.items,
    );
  }
}
