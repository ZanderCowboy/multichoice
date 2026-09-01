import 'package:flutter/widgets.dart';

/// Primary [ScrollPosition] for [controller], safe during scrollable handoff.
///
/// [ScrollController.position] asserts when more than one scroll view is
/// attached (e.g. while a [CustomScrollView] is rebuilding after lane changes).
ScrollPosition? primaryScrollPosition(ScrollController controller) {
  if (!controller.hasClients) return null;
  final positions = controller.positions;
  if (positions.isEmpty) return null;
  if (positions.length == 1) return positions.single;
  return positions.last;
}
