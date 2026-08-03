import 'package:flutter/widgets.dart';

import 'board_view_style.dart';

/// Board scroller padding: along the collections axis only (cross axis is 0
/// so shells are full-bleed).
EdgeInsets boardCollectionsPadding({
  required bool isVertical,
  required BoardViewStyle style,
}) {
  return isVertical
      ? EdgeInsets.symmetric(horizontal: style.collectionsAlongPadding)
      : EdgeInsets.symmetric(vertical: style.collectionsAlongPadding);
}

/// Per-lane outer padding: along the collections axis only.
EdgeInsets boardLaneOuterPadding({
  required bool isVertical,
  required BoardViewStyle style,
}) {
  return isVertical
      ? EdgeInsets.symmetric(horizontal: style.laneAlongPadding)
      : EdgeInsets.symmetric(vertical: style.laneAlongPadding);
}
