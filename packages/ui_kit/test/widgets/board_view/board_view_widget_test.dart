import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

List<BoardLane<String>> _lanes() {
  return const [
    BoardLane(id: 'todo', items: ['a', 'b']),
    BoardLane(id: 'empty', items: []),
  ];
}

Widget _harness({
  required List<BoardLane<String>> lanes,
  bool editMode = false,
  BoardViewConfig config = const BoardViewConfig(),
  double? laneExtent,
  double itemExtent = 72,
  BoardEmptyLaneBuilder<String>? emptyLaneBuilder,
  BoardLaneAddBuilder<String>? laneAddBuilder,
  BoardAddBuilder? boardAddBuilder,
  void Function(BoardItemMove move)? onItemMoved,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 800,
        height: 600,
        child: BoardView<String>(
          lanes: lanes,
          editMode: editMode,
          config: config,
          laneExtent: laneExtent,
          itemExtent: itemExtent,
          itemIdOf: (item) => item,
          itemBuilder: (context, item, isDragging) => Text(
            isDragging ? 'feedback:$item' : 'item:$item',
          ),
          collectionHeaderBuilder: (context, lane, index, dragHandle) {
            return Row(
              children: [
                dragHandle,
                Text('header:${lane.id}'),
              ],
            );
          },
          emptyLaneBuilder: emptyLaneBuilder,
          laneAddBuilder: laneAddBuilder,
          boardAddBuilder: boardAddBuilder,
          onItemMoved: onItemMoved ?? (_) {},
          onCollectionsReorder: (oldIndex, newIndex) {},
        ),
      ),
    ),
  );
}

void main() {
  group('BoardView', () {
    testWidgets('renders headers and items for both layouts', (tester) async {
      await tester.pumpWidget(_harness(lanes: _lanes()));
      await tester.pumpAndSettle();

      expect(find.text('header:todo'), findsOneWidget);
      expect(find.text('header:empty'), findsOneWidget);
      expect(find.text('item:a'), findsOneWidget);
      expect(find.text('item:b'), findsOneWidget);

      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          config: const BoardViewConfig(layout: BoardLayout.horizontal),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('header:todo'), findsOneWidget);
      expect(find.text('item:a'), findsOneWidget);
    });

    testWidgets('shows emptyLaneBuilder for empty lanes', (tester) async {
      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          emptyLaneBuilder: (context, lane) => Text('empty:${lane.id}'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('empty:empty'), findsOneWidget);
      expect(find.text('empty:todo'), findsNothing);
    });

    testWidgets('shows collection drag handles only in editMode', (tester) async {
      await tester.pumpWidget(_harness(lanes: _lanes()));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.drag_indicator), findsNothing);

      await tester.pumpWidget(_harness(lanes: _lanes(), editMode: true));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.drag_indicator), findsNWidgets(2));
    });

    testWidgets('add slots follow BoardAddVisibility', (tester) async {
      Widget laneAdd(BuildContext context, BoardLane<String> lane) {
        return Text('lane-add:${lane.id}');
      }

      Widget boardAdd(BuildContext context) => const Text('board-add');

      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          laneAddBuilder: laneAdd,
          boardAddBuilder: boardAdd,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('lane-add:todo'), findsNothing);
      expect(find.text('board-add'), findsNothing);

      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          editMode: true,
          laneAddBuilder: laneAdd,
          boardAddBuilder: boardAdd,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('lane-add:todo'), findsOneWidget);
      expect(find.text('lane-add:empty'), findsOneWidget);
      expect(find.text('board-add'), findsOneWidget);

      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          config: const BoardViewConfig(addVisibility: BoardAddVisibility.always),
          laneAddBuilder: laneAdd,
          boardAddBuilder: boardAdd,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('lane-add:todo'), findsOneWidget);
      expect(find.text('board-add'), findsOneWidget);
    });

    testWidgets('item drag feedback matches lane cross-extent', (tester) async {
      const laneExtent = 200.0;
      const itemExtent = 72.0;
      const padding = EdgeInsets.all(4);

      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          editMode: true,
          laneExtent: laneExtent,
          itemExtent: itemExtent,
        ),
      );
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('item:a')),
      );
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump();

      final feedbackSize = tester.getSize(find.text('feedback:a'));
      expect(
        feedbackSize.width,
        laneExtent - padding.horizontal,
      );
      expect(feedbackSize.height, itemExtent);

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });
}
