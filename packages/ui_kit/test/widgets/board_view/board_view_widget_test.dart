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
  void Function(String itemId, String fromLaneId, int fromIndex)? onItemDeleted,
  BoardCollectionDeletedCallback? onCollectionDeleted,
  void Function(int oldIndex, int newIndex)? onCollectionsReorder,
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
                Expanded(child: Text('header:${lane.id}')),
              ],
            );
          },
          emptyLaneBuilder: emptyLaneBuilder,
          laneAddBuilder: laneAddBuilder,
          boardAddBuilder: boardAddBuilder,
          onItemMoved: onItemMoved ?? (_) {},
          onCollectionsReorder: onCollectionsReorder ?? (oldIndex, newIndex) {},
          onItemDeleted: onItemDeleted,
          onCollectionDeleted: onCollectionDeleted,
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

    testWidgets('toggling edit mode completes without hanging', (tester) async {
      final lanes = [
        for (var lane = 0; lane < 4; lane++)
          BoardLane<String>(
            id: 'lane-$lane',
            items: [for (var i = 0; i < 8; i++) 'lane-$lane-item-$i'],
          ),
      ];

      await tester.pumpWidget(_harness(lanes: lanes));
      await tester.pumpAndSettle();

      await tester.pumpWidget(_harness(lanes: lanes, editMode: true));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.drag_indicator), findsNWidgets(4));
      expect(find.text('item:lane-0-item-0'), findsOneWidget);
    });

    testWidgets('collection drag removes source and shows lane ghost at gap', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          lanes: const [
            BoardLane(id: 'todo', items: ['a', 'b']),
            BoardLane(id: 'done', items: ['c']),
          ],
          editMode: true,
        ),
      );
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(
        tester.getCenter(find.byIcon(Icons.drag_indicator).first),
      );
      await gesture.moveBy(const Offset(80, 0));
      await tester.pump();

      expect(find.text('item:c'), findsOneWidget);
      expect(find.text('header:done'), findsOneWidget);
      expect(find.text('header:todo'), findsOneWidget);
      expect(find.text('item:a'), findsOneWidget);
      expect(find.text('Drop here'), findsNothing);

      final ghosts = tester.widgetList<Opacity>(find.byType(Opacity)).where(
        (opacity) => opacity.opacity < 1,
      );
      expect(ghosts, isNotEmpty);

      await gesture.up();
      await tester.pumpAndSettle();
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

    testWidgets('start-placed lane add does not shift item drop index', (
      tester,
    ) async {
      BoardItemMove? lastMove;
      await tester.pumpWidget(
        _harness(
          lanes: const [
            BoardLane(id: 'todo', items: ['a', 'b', 'c']),
          ],
          editMode: true,
          config: const BoardViewConfig(
            laneAddPlacement: BoardSlotPlacement.start,
            addVisibility: BoardAddVisibility.always,
          ),
          laneAddBuilder: (context, lane) => const Text('lane-add'),
          onItemMoved: (move) => lastMove = move,
        ),
      );
      await tester.pumpAndSettle();

      final firstItem = tester.getRect(find.text('item:a'));
      final lastItem = tester.getCenter(find.text('item:c'));
      // First half of item a — insert index 0 after source-c is removed.
      final dropOnFirst = Offset(
        firstItem.center.dx,
        firstItem.top + firstItem.height * 0.25,
      );

      final gesture = await tester.startGesture(lastItem);
      await gesture.moveTo(dropOnFirst);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(lastMove, isNotNull);
      expect(lastMove!.fromLaneId, 'todo');
      expect(lastMove!.toLaneId, 'todo');
      expect(lastMove!.fromIndex, 2);
      expect(lastMove!.toIndex, 0);
    });

    testWidgets('hides delete bin when not in edit mode or callbacks missing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          editMode: true,
          onItemDeleted: (_, _, _) {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('board-delete-bin')), findsOneWidget);

      await tester.pumpWidget(_harness(lanes: _lanes(), editMode: true));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('board-delete-bin')), findsNothing);

      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          onItemDeleted: (_, _, _) {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('board-delete-bin')), findsNothing);
    });

    testWidgets('dropping item on delete bin calls onItemDeleted only', (
      tester,
    ) async {
      String? deletedItemId;
      BoardItemMove? moved;

      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          editMode: true,
          onItemDeleted: (itemId, fromLaneId, fromIndex) {
            deletedItemId = itemId;
          },
          onItemMoved: (move) => moved = move,
        ),
      );
      await tester.pumpAndSettle();

      final binCenter = tester.getCenter(
        find.byKey(const ValueKey('board-delete-bin')),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('item:a')),
      );
      await gesture.moveTo(binCenter);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(deletedItemId, 'a');
      expect(moved, isNull);
    });

    testWidgets('dropping lane on delete bin calls onCollectionDeleted only', (
      tester,
    ) async {
      String? deletedLaneId;
      int? reorderedOld;
      int? reorderedNew;

      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          editMode: true,
          onCollectionDeleted: (laneId, fromIndex, resolve) {
            deletedLaneId = laneId;
            resolve(true);
          },
          onCollectionsReorder: (oldIndex, newIndex) {
            reorderedOld = oldIndex;
            reorderedNew = newIndex;
          },
        ),
      );
      await tester.pumpAndSettle();

      final binCenter = tester.getCenter(
        find.byKey(const ValueKey('board-delete-bin')),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byIcon(Icons.drag_indicator).first),
      );
      await gesture.moveTo(binCenter);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(deletedLaneId, 'todo');
      expect(reorderedOld, isNull);
      expect(reorderedNew, isNull);
    });

    testWidgets('lane ghost persists until onCollectionDeleted resolve', (
      tester,
    ) async {
      void Function(bool confirmed)? pendingResolve;

      await tester.pumpWidget(
        _harness(
          lanes: _lanes(),
          editMode: true,
          onCollectionDeleted: (laneId, fromIndex, resolve) {
            pendingResolve = resolve;
          },
        ),
      );
      await tester.pumpAndSettle();

      final binCenter = tester.getCenter(
        find.byKey(const ValueKey('board-delete-bin')),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byIcon(Icons.drag_indicator).first),
      );
      await gesture.moveTo(binCenter);
      await tester.pump();
      await gesture.up();
      await tester.pump();

      expect(pendingResolve, isNotNull);
      final ghostsWhilePending = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .where((opacity) => opacity.opacity < 1);
      expect(ghostsWhilePending, isNotEmpty);

      pendingResolve!(false);
      await tester.pumpAndSettle();

      expect(find.text('header:todo'), findsOneWidget);
    });

    testWidgets('in-lane drop still moves when delete callbacks are set', (
      tester,
    ) async {
      BoardItemMove? lastMove;
      var deleteCount = 0;

      await tester.pumpWidget(
        _harness(
          lanes: const [
            BoardLane(id: 'todo', items: ['a', 'b', 'c']),
          ],
          editMode: true,
          onItemDeleted: (_, _, _) => deleteCount++,
          onItemMoved: (move) => lastMove = move,
        ),
      );
      await tester.pumpAndSettle();

      final firstItem = tester.getRect(find.text('item:a'));
      final lastItem = tester.getCenter(find.text('item:c'));
      final dropOnFirst = Offset(
        firstItem.center.dx,
        firstItem.top + firstItem.height * 0.25,
      );

      final gesture = await tester.startGesture(lastItem);
      await gesture.moveTo(dropOnFirst);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(lastMove, isNotNull);
      expect(lastMove!.fromIndex, 2);
      expect(lastMove!.toIndex, 0);
      expect(deleteCount, 0);
    });

    testWidgets('adding a collection does not crash scroll thumb', (
      tester,
    ) async {
      var lanes = _lanes();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return BoardView<String>(
                    lanes: lanes,
                    editMode: true,
                    itemIdOf: (item) => item,
                    itemBuilder: (context, item, isDragging) =>
                        Text('item:$item'),
                    collectionHeaderBuilder:
                        (context, lane, index, dragHandle) {
                      return Row(
                        children: [
                          dragHandle,
                          Expanded(child: Text('header:${lane.id}')),
                        ],
                      );
                    },
                    boardAddBuilder: (context) => TextButton(
                      onPressed: () {
                        setState(() {
                          lanes = [
                            ...lanes,
                            const BoardLane(id: 'new', items: []),
                          ];
                        });
                      },
                      child: const Text('board-add'),
                    ),
                    onItemMoved: (_) {},
                    onItemDeleted: (_, _, _) {},
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('board-add'));
      await tester.pumpAndSettle();

      expect(find.text('header:new'), findsOneWidget);
    });
  });
}
