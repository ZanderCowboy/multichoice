/// A lane (collection) containing draggable items.
class Lane<T> {
  const Lane({
    required this.id,
    required this.items,
  });

  final String id;
  final List<T> items;
}
