import 'package:flutter/foundation.dart';

/// Payload carried while an item is being dragged.
class ItemDragPayload<T> {
  const ItemDragPayload({
    required this.item,
    required this.itemId,
    required this.fromLaneId,
    required this.fromIndex,
  });

  final T item;
  final String itemId;
  final String fromLaneId;
  final int fromIndex;
}

/// Payload carried while a collection header is being dragged.
class LaneDragPayload {
  const LaneDragPayload({required this.laneId, required this.fromIndex});

  final String laneId;
  final int fromIndex;
}

/// Hover preview for item drops. Notifies listeners without rebuilding the
/// entire board on every pointer move.
class ItemHoverPreview extends ChangeNotifier {
  String? laneId;
  int? index;

  void update(String? nextLaneId, int? nextIndex) {
    if (laneId == nextLaneId && index == nextIndex) return;
    laneId = nextLaneId;
    index = nextIndex;
    notifyListeners();
  }

  void clear() => update(null, null);
}

/// Hover preview for collection reorder.
class LaneHoverPreview extends ChangeNotifier {
  int? index;

  void update(int? nextIndex) {
    if (index == nextIndex) return;
    index = nextIndex;
    notifyListeners();
  }

  void clear() => update(null);
}
