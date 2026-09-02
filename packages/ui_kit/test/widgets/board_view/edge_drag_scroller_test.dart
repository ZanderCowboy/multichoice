import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/src/widgets/board_view/drag/board_drag_session.dart';
import 'package:ui_kit/src/widgets/board_view/drag/edge_drag_scroller.dart';
import 'package:ui_kit/src/widgets/board_view/models/board_drag_models.dart';

Future<ScrollableState> _pumpScrollable(WidgetTester tester) async {
  late ScrollableState scrollable;
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: 200,
        height: 200,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Builder(
            builder: (context) {
              scrollable = Scrollable.of(context);
              return const SizedBox(width: 800, height: 200);
            },
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return scrollable;
}

void main() {
  group('EdgeDragScroller', () {
    testWidgets('onDragUpdate is a no-op after the scrollable unmounts', (
      tester,
    ) async {
      final scrollable = await _pumpScrollable(tester);
      final scroller = EdgeDragScroller(scrollable: scrollable);

      scroller.onDragStart();
      expect(scroller.viewportBox, isNotNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      expect(scrollable.mounted, isFalse);
      expect(scroller.viewportBox, isNull);
      expect(
        () => scroller.onDragUpdate(const Offset(10, 10)),
        returnsNormally,
      );

      scroller.dispose();
    });

    testWidgets('frame callback does not touch an unmounted scrollable', (
      tester,
    ) async {
      final scrollable = await _pumpScrollable(tester);
      final scroller = EdgeDragScroller(scrollable: scrollable);

      scroller.onDragStart();
      // Pointer past the leading edge so a frame is scheduled.
      scroller.onDragUpdate(const Offset(-20, 100));

      await tester.pumpWidget(const SizedBox.shrink());
      expect(() => tester.pump(const Duration(milliseconds: 16)), returnsNormally);

      scroller.dispose();
    });
  });

  group('BoardDragSession unmounted scrollable', () {
    BoardDragSession<String> session() {
      return BoardDragSession<String>(
        onChanged: () {},
        onPointerRouteNeeded: () {},
        onPointerRouteReleased: () {},
      );
    }

    testWidgets('updateLaneHoverAtBoardEdges ignores a disposed board scroller', (
      tester,
    ) async {
      final scrollable = await _pumpScrollable(tester);
      final drag = session()
        ..boardEdgeScroller = EdgeDragScroller(scrollable: scrollable)
        ..laneDrag = const LaneDragPayload(laneId: 'a', fromIndex: 0);

      await tester.pumpWidget(const SizedBox.shrink());

      expect(
        () => drag.updateLaneHoverAtBoardEdges(
          globalPosition: Offset.zero,
          isVertical: true,
          laneCount: 3,
        ),
        returnsNormally,
      );

      drag.dispose();
    });

    testWidgets('item hover does not throw when the lane scroller unmounted', (
      tester,
    ) async {
      final scrollable = await _pumpScrollable(tester);
      final drag = session();
      drag.registerLaneEdgeScroller(
        'a',
        EdgeDragScroller(scrollable: scrollable),
      );
      drag.onItemDragStarted(
        const ItemDragPayload(
          item: 'a0',
          itemId: 'a0',
          fromLaneId: 'a',
          fromIndex: 0,
        ),
      );

      await tester.pumpWidget(const SizedBox.shrink());

      // Live lane box for hover math; the registered lane scroller is stale.
      const laneKey = ValueKey('lane');
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            key: laneKey,
            width: 100,
            height: 200,
            child: ColoredBox(color: Colors.grey),
          ),
        ),
      );
      final laneBox = tester.renderObject<RenderBox>(find.byKey(laneKey));

      expect(
        () => drag.onItemHover(
          laneId: 'a',
          globalPosition: Offset.zero,
          laneBox: laneBox,
          previewItemCount: 2,
          laneController: null,
          isVertical: true,
          itemExtent: 72,
        ),
        returnsNormally,
      );

      drag.dispose();
    });
  });
}
