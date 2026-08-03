import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/src/widgets/board_view/drag/board_drag_session.dart';
import 'package:ui_kit/src/widgets/board_view/models/board_drag_models.dart';
import 'package:ui_kit/src/widgets/board_view/models/board_lane.dart';

BoardDragSession<String> _session() {
  return BoardDragSession<String>(
    onChanged: () {},
    onPointerRouteNeeded: () {},
    onPointerRouteReleased: () {},
  );
}

List<BoardLane<String>> _lanes() {
  return const [
    BoardLane(id: 'a', items: ['a0', 'a1', 'a2']),
    BoardLane(id: 'b', items: ['b0', 'b1']),
    BoardLane(id: 'c', items: []),
  ];
}

void main() {
  group('BoardDragSessionIndexing.previewLanes', () {
    test('returns lanes unchanged when idle', () {
      final session = _session();
      final lanes = _lanes();

      expect(session.previewLanes(lanes), same(lanes));
    });

    test('removes the dragged item from its source lane', () {
      final session = _session();
      session.itemDrag = const ItemDragPayload(
        item: 'a1',
        itemId: 'a1',
        fromLaneId: 'a',
        fromIndex: 1,
      );

      final preview = session.previewLanes(_lanes());

      expect(preview.map((l) => l.id), ['a', 'b', 'c']);
      expect(preview[0].items, ['a0', 'a2']);
      expect(preview[1].items, ['b0', 'b1']);
    });

    test('removes the dragged collection from preview', () {
      final session = _session();
      session.laneDrag = const LaneDragPayload(laneId: 'b', fromIndex: 1);

      final preview = session.previewLanes(_lanes());

      expect(preview.map((l) => l.id), ['a', 'c']);
    });

    test('applies lane then item removal when both are set', () {
      final session = _session();
      session.laneDrag = const LaneDragPayload(laneId: 'c', fromIndex: 2);
      session.itemDrag = const ItemDragPayload(
        item: 'a0',
        itemId: 'a0',
        fromLaneId: 'a',
        fromIndex: 0,
      );

      final preview = session.previewLanes(_lanes());

      expect(preview.map((l) => l.id), ['a', 'b']);
      expect(preview[0].items, ['a1', 'a2']);
    });
  });

  group('BoardDragSessionIndexing.originalIndexOf', () {
    test('returns preview index when not dragging from that lane', () {
      final session = _session();
      session.itemDrag = const ItemDragPayload(
        item: 'a0',
        itemId: 'a0',
        fromLaneId: 'a',
        fromIndex: 0,
      );

      expect(
        session.originalIndexOf(laneId: 'b', previewIndex: 1),
        1,
      );
    });

    test('shifts indices at or after the removed source slot', () {
      final session = _session();
      session.itemDrag = const ItemDragPayload(
        item: 'a1',
        itemId: 'a1',
        fromLaneId: 'a',
        fromIndex: 1,
      );

      expect(session.originalIndexOf(laneId: 'a', previewIndex: 0), 0);
      expect(session.originalIndexOf(laneId: 'a', previewIndex: 1), 2);
      expect(session.originalIndexOf(laneId: 'a', previewIndex: 2), 3);
    });
  });

  group('BoardDragSessionIndexing.collectionSlotCount', () {
    test('equals lane count when not dragging a collection', () {
      expect(_session().collectionSlotCount(3), 3);
    });

    test('adds a gap slot when lane hover index is set', () {
      final session = _session();
      session.laneDrag = const LaneDragPayload(laneId: 'a', fromIndex: 0);
      session.laneHover.update(1);

      expect(session.collectionSlotCount(2), 3);
    });
  });

  group('BoardDragSessionIndexing.laneIndexForVisualSlot', () {
    test('maps visual slots around an insert gap', () {
      final session = _session();
      session.laneDrag = const LaneDragPayload(laneId: 'a', fromIndex: 0);
      session.laneHover.update(1);

      expect(session.laneIndexForVisualSlot(0, 2), 0);
      expect(session.laneIndexForVisualSlot(1, 2), isNull);
      expect(session.laneIndexForVisualSlot(2, 2), 1);
    });

    test('maps 1:1 when idle', () {
      final session = _session();

      expect(session.laneIndexForVisualSlot(0, 2), 0);
      expect(session.laneIndexForVisualSlot(1, 2), 1);
      expect(session.laneIndexForVisualSlot(2, 2), isNull);
    });
  });

  group('BoardDragSessionIndexing.insertIndexFromPointer', () {
    Future<RenderBox> pumpLaneBox(WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              key: key,
              width: 200,
              height: 400,
              child: const ColoredBox(color: Colors.grey),
            ),
          ),
        ),
      );
      return key.currentContext!.findRenderObject()! as RenderBox;
    }

    testWidgets('returns 0 for empty lane or before first item', (
      tester,
    ) async {
      final session = _session();
      final box = await pumpLaneBox(tester);
      final origin = box.localToGlobal(Offset.zero);

      expect(
        session.insertIndexFromPointer(
          globalPosition: origin,
          laneBox: box,
          previewItemCount: 0,
          laneController: null,
          isVertical: true,
          itemExtent: 72,
        ),
        0,
      );

      expect(
        session.insertIndexFromPointer(
          globalPosition: origin,
          laneBox: box,
          previewItemCount: 3,
          laneController: null,
          isVertical: true,
          itemExtent: 72,
        ),
        0,
      );
    });

    testWidgets('rounds to nearest slot along the scroll axis', (tester) async {
      final session = _session();
      final box = await pumpLaneBox(tester);
      final origin = box.localToGlobal(Offset.zero);

      // Midpoint of item 0 → index 0; past midpoint of item 0 → index 1.
      expect(
        session.insertIndexFromPointer(
          globalPosition: origin + const Offset(0, 20),
          laneBox: box,
          previewItemCount: 3,
          laneController: null,
          isVertical: true,
          itemExtent: 72,
        ),
        0,
      );
      expect(
        session.insertIndexFromPointer(
          globalPosition: origin + const Offset(0, 40),
          laneBox: box,
          previewItemCount: 3,
          laneController: null,
          isVertical: true,
          itemExtent: 72,
        ),
        1,
      );
      expect(
        session.insertIndexFromPointer(
          globalPosition: origin + const Offset(0, 200),
          laneBox: box,
          previewItemCount: 3,
          laneController: null,
          isVertical: true,
          itemExtent: 72,
        ),
        3,
      );
    });

    testWidgets('subtracts leadingExtent and uses horizontal axis', (
      tester,
    ) async {
      final session = _session();
      final box = await pumpLaneBox(tester);
      final origin = box.localToGlobal(Offset.zero);

      expect(
        session.insertIndexFromPointer(
          globalPosition: origin + const Offset(100, 0),
          laneBox: box,
          previewItemCount: 4,
          laneController: null,
          isVertical: false,
          itemExtent: 72,
          leadingExtent: 28,
        ),
        // (100 - 28) / 72 ≈ 1.0 → round 1
        1,
      );
    });
  });

  group('BoardDragSessionIndexing.collectionInsertIndexForLane', () {
    Future<RenderBox> pumpLaneBox(WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              key: key,
              width: 100,
              height: 200,
              child: const ColoredBox(color: Colors.grey),
            ),
          ),
        ),
      );
      return key.currentContext!.findRenderObject()! as RenderBox;
    }

    testWidgets('uses before/after midpoint for vertical board layout', (
      tester,
    ) async {
      final session = _session();
      final box = await pumpLaneBox(tester);
      final origin = box.localToGlobal(Offset.zero);

      // Vertical layout: collections scroll horizontally → along is dx.
      expect(
        session.collectionInsertIndexForLane(
          laneIndex: 1,
          laneCount: 3,
          globalPosition: origin + const Offset(20, 0),
          laneBox: box,
          isVertical: true,
        ),
        1,
      );
      expect(
        session.collectionInsertIndexForLane(
          laneIndex: 1,
          laneCount: 3,
          globalPosition: origin + const Offset(60, 0),
          laneBox: box,
          isVertical: true,
        ),
        2,
      );
    });

    test('clamps when lane box is missing', () {
      final session = _session();

      expect(
        session.collectionInsertIndexForLane(
          laneIndex: 2,
          laneCount: 3,
          globalPosition: Offset.zero,
          laneBox: null,
          isVertical: true,
        ),
        2,
      );
      expect(
        session.collectionInsertIndexForLane(
          laneIndex: 0,
          laneCount: 0,
          globalPosition: Offset.zero,
          laneBox: null,
          isVertical: true,
        ),
        0,
      );
    });
  });
}
