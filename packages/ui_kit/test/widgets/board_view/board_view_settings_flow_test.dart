import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/src/widgets/board_view/models/board_drag_models.dart';
import 'package:ui_kit/src/widgets/board_view/scroll/board_scroll_arrows.dart';
import 'package:ui_kit/src/widgets/board_view/scroll/board_scroll_thumb.dart';
import 'package:ui_kit/ui_kit.dart';

List<BoardLane<String>> _flowLanes() {
  return const [
    BoardLane(id: 'todo', items: ['a', 'b', 'c']),
    BoardLane(id: 'doing', items: ['d']),
    BoardLane(id: 'empty', items: []),
  ];
}

List<BoardLane<String>> _overflowLanes({
  required int laneCount,
  required int itemsPerLane,
}) {
  return [
    for (var lane = 0; lane < laneCount; lane++)
      BoardLane<String>(
        id: 'lane-$lane',
        items: [for (var i = 0; i < itemsPerLane; i++) 'lane-$lane-item-$i'],
      ),
  ];
}

Widget _app(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(width: 800, height: 600, child: child),
    ),
  );
}

BoardView<String> _board({
  required List<BoardLane<String>> lanes,
  required void Function(BoardItemMove move) onItemMoved,
  bool editMode = false,
  BoardViewConfig config = const BoardViewConfig(),
  double? laneExtent,
  double itemExtent = 72,
  ScrollController? scrollController,
  Map<String, ScrollController>? laneScrollControllers,
  BoardEmptyLaneBuilder<String>? emptyLaneBuilder,
  BoardLaneAddBuilder<String>? laneAddBuilder,
  BoardAddBuilder? boardAddBuilder,
  void Function(int oldIndex, int newIndex)? onCollectionsReorder,
}) {
  return BoardView<String>(
    lanes: lanes,
    editMode: editMode,
    config: config,
    laneExtent: laneExtent,
    itemExtent: itemExtent,
    scrollController: scrollController,
    laneScrollControllers: laneScrollControllers,
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
    onItemMoved: onItemMoved,
    onCollectionsReorder: onCollectionsReorder ?? (oldIndex, newIndex) {},
  );
}

class _LiveBoard extends StatefulWidget {
  const _LiveBoard({
    required this.initialLanes,
    this.config = const BoardViewConfig(),
    this.emptyLaneBuilder,
    this.onItemMoved,
    this.onCollectionsReorder,
  });

  final List<BoardLane<String>> initialLanes;
  final BoardViewConfig config;
  final BoardEmptyLaneBuilder<String>? emptyLaneBuilder;
  final void Function(BoardItemMove move)? onItemMoved;
  final void Function(int oldIndex, int newIndex)? onCollectionsReorder;

  @override
  State<_LiveBoard> createState() => _LiveBoardState();
}

class _LiveBoardState extends State<_LiveBoard> {
  late final List<BoardLane<String>> _lanes = List<BoardLane<String>>.of(
    widget.initialLanes,
  );

  void _applyItemMove(BoardItemMove move) {
    widget.onItemMoved?.call(move);
    setState(() {
      final fromI = _lanes.indexWhere((lane) => lane.id == move.fromLaneId);
      final toI = _lanes.indexWhere((lane) => lane.id == move.toLaneId);
      if (fromI < 0 || toI < 0) return;

      final fromItems = List<String>.of(_lanes[fromI].items);
      final toItems = fromI == toI
          ? fromItems
          : List<String>.of(_lanes[toI].items);
      if (move.fromIndex < 0 || move.fromIndex >= fromItems.length) return;

      final item = fromItems.removeAt(move.fromIndex);
      toItems.insert(move.toIndex.clamp(0, toItems.length), item);
      _lanes[fromI] = _lanes[fromI].copyWith(items: fromItems);
      if (fromI != toI) {
        _lanes[toI] = _lanes[toI].copyWith(items: toItems);
      } else {
        _lanes[fromI] = _lanes[fromI].copyWith(items: toItems);
      }
    });
  }

  void _applyCollectionsReorder(int oldIndex, int newIndex) {
    widget.onCollectionsReorder?.call(oldIndex, newIndex);
    setState(() {
      final lane = _lanes.removeAt(oldIndex);
      _lanes.insert(newIndex, lane);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _board(
      lanes: _lanes,
      editMode: true,
      config: widget.config,
      emptyLaneBuilder: widget.emptyLaneBuilder,
      onItemMoved: _applyItemMove,
      onCollectionsReorder: _applyCollectionsReorder,
    );
  }
}

Future<void> _dragFromTo(
  WidgetTester tester,
  Finder from,
  Offset to,
) async {
  final gesture = await tester.startGesture(tester.getCenter(from));
  await gesture.moveTo(to);
  await tester.pump();
  await gesture.up();
  await tester.pumpAndSettle();
}

List<String> _orderAlong(
  WidgetTester tester,
  List<String> labels, {
  required bool vertical,
}) {
  final entries = [
    for (final label in labels)
      if (tester.any(find.text(label)))
        (
          label,
          vertical
              ? tester.getCenter(find.text(label)).dy
              : tester.getCenter(find.text(label)).dx,
        ),
  ]..sort((a, b) => a.$2.compareTo(b.$2));
  return [for (final entry in entries) entry.$1];
}

CustomScrollView _collectionsScroll(WidgetTester tester) {
  return tester.widget<CustomScrollView>(
    find.byKey(const ValueKey('board_collections')),
  );
}

Draggable<ItemDragPayload<String>> _itemDraggable(WidgetTester tester) {
  return tester.widget<Draggable<ItemDragPayload<String>>>(
    find
        .ancestor(
          of: find.text('item:a'),
          matching: find.byWidgetPredicate(
            (widget) => widget is Draggable<ItemDragPayload<String>>,
          ),
        )
        .first,
  );
}

void main() {
  group('BoardView vertical (VM) flow', () {
    testWidgets('lays out columns with items stacked vertically', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(_board(lanes: _flowLanes(), onItemMoved: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(_collectionsScroll(tester).scrollDirection, Axis.horizontal);
      expect(find.text('header:todo'), findsOneWidget);
      expect(find.text('header:doing'), findsOneWidget);
      expect(find.text('item:a'), findsOneWidget);
      expect(find.text('item:d'), findsOneWidget);
      expect(find.byIcon(Icons.drag_indicator), findsNothing);

      expect(
        _orderAlong(
          tester,
          ['header:todo', 'header:doing', 'header:empty'],
          vertical: false,
        ),
        ['header:todo', 'header:doing', 'header:empty'],
      );
      expect(
        _orderAlong(tester, ['item:a', 'item:b', 'item:c'], vertical: true),
        ['item:a', 'item:b', 'item:c'],
      );
    });

    testWidgets('reorders an item within a lane in edit mode', (tester) async {
      BoardItemMove? lastMove;
      await tester.pumpWidget(
        _app(
          _LiveBoard(
            initialLanes: _flowLanes(),
            onItemMoved: (move) => lastMove = move,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final firstItem = tester.getRect(find.text('item:a'));
      await _dragFromTo(
        tester,
        find.text('item:c'),
        Offset(firstItem.center.dx, firstItem.top + firstItem.height * 0.25),
      );

      expect(lastMove, isNotNull);
      expect(lastMove!.itemId, 'c');
      expect(lastMove!.fromLaneId, 'todo');
      expect(lastMove!.toLaneId, 'todo');
      expect(lastMove!.fromIndex, 2);
      expect(lastMove!.toIndex, 0);
      expect(
        _orderAlong(tester, ['item:a', 'item:b', 'item:c'], vertical: true),
        ['item:c', 'item:a', 'item:b'],
      );
    });

    testWidgets('moves an item onto another collection', (tester) async {
      BoardItemMove? lastMove;
      await tester.pumpWidget(
        _app(
          _LiveBoard(
            initialLanes: _flowLanes(),
            emptyLaneBuilder: (context, lane) => Text('drop:${lane.id}'),
            onItemMoved: (move) => lastMove = move,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _dragFromTo(
        tester,
        find.text('item:a'),
        tester.getCenter(find.text('drop:empty')),
      );

      expect(lastMove, isNotNull);
      expect(lastMove!.itemId, 'a');
      expect(lastMove!.fromLaneId, 'todo');
      expect(lastMove!.toLaneId, 'empty');
      expect(find.text('item:a'), findsOneWidget);
      expect(find.text('drop:empty'), findsNothing);
    });

    testWidgets('reorders collections along the board axis', (tester) async {
      var oldIndex = -1;
      var newIndex = -1;
      await tester.pumpWidget(
        _app(
          _LiveBoard(
            initialLanes: _flowLanes(),
            onCollectionsReorder: (from, to) {
              oldIndex = from;
              newIndex = to;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _dragFromTo(
        tester,
        find.byIcon(Icons.drag_indicator).first,
        tester.getCenter(find.text('header:empty')),
      );

      expect(oldIndex, 0);
      expect(newIndex, isNot(0));
      expect(
        _orderAlong(
          tester,
          ['header:todo', 'header:doing', 'header:empty'],
          vertical: false,
        ).first,
        isNot('header:todo'),
      );
    });
  });

  group('BoardView horizontal (HM) flow', () {
    const hm = BoardViewConfig(layout: BoardLayout.horizontal);

    testWidgets('lays out rows with items stacked horizontally', (tester) async {
      await tester.pumpWidget(
        _app(_board(lanes: _flowLanes(), config: hm, onItemMoved: (_) {})),
      );
      await tester.pumpAndSettle();

      expect(_collectionsScroll(tester).scrollDirection, Axis.vertical);
      expect(find.text('header:todo'), findsOneWidget);
      expect(find.text('item:a'), findsOneWidget);
      expect(find.byIcon(Icons.drag_indicator), findsNothing);

      expect(
        _orderAlong(
          tester,
          ['header:todo', 'header:doing', 'header:empty'],
          vertical: true,
        ),
        ['header:todo', 'header:doing', 'header:empty'],
      );
      expect(
        _orderAlong(tester, ['item:a', 'item:b', 'item:c'], vertical: false),
        ['item:a', 'item:b', 'item:c'],
      );
    });

    testWidgets('reorders an item within a lane in edit mode', (tester) async {
      BoardItemMove? lastMove;
      await tester.pumpWidget(
        _app(
          _LiveBoard(
            initialLanes: _flowLanes(),
            config: hm,
            onItemMoved: (move) => lastMove = move,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final firstItem = tester.getRect(find.text('item:a'));
      await _dragFromTo(
        tester,
        find.text('item:c'),
        Offset(firstItem.left + firstItem.width * 0.25, firstItem.center.dy),
      );

      expect(lastMove, isNotNull);
      expect(lastMove!.itemId, 'c');
      expect(lastMove!.fromLaneId, 'todo');
      expect(lastMove!.toLaneId, 'todo');
      expect(lastMove!.fromIndex, 2);
      expect(lastMove!.toIndex, 0);
      expect(
        _orderAlong(tester, ['item:a', 'item:b', 'item:c'], vertical: false),
        ['item:c', 'item:a', 'item:b'],
      );
    });

    testWidgets('moves an item onto another collection', (tester) async {
      BoardItemMove? lastMove;
      await tester.pumpWidget(
        _app(
          _LiveBoard(
            initialLanes: _flowLanes(),
            config: hm,
            emptyLaneBuilder: (context, lane) => Text('drop:${lane.id}'),
            onItemMoved: (move) => lastMove = move,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _dragFromTo(
        tester,
        find.text('item:d'),
        tester.getCenter(find.text('drop:empty')),
      );

      expect(lastMove, isNotNull);
      expect(lastMove!.itemId, 'd');
      expect(lastMove!.fromLaneId, 'doing');
      expect(lastMove!.toLaneId, 'empty');
      expect(find.text('drop:empty'), findsNothing);
    });

    testWidgets('reorders collections along the board axis', (tester) async {
      var oldIndex = -1;
      var newIndex = -1;
      await tester.pumpWidget(
        _app(
          _LiveBoard(
            initialLanes: _flowLanes(),
            config: hm,
            onCollectionsReorder: (from, to) {
              oldIndex = from;
              newIndex = to;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _dragFromTo(
        tester,
        find.byIcon(Icons.drag_indicator).first,
        tester.getCenter(find.text('header:empty')),
      );

      expect(oldIndex, 0);
      expect(newIndex, isNot(0));
      expect(
        _orderAlong(
          tester,
          ['header:todo', 'header:doing', 'header:empty'],
          vertical: true,
        ).first,
        isNot('header:todo'),
      );
    });

    testWidgets('item drag feedback uses HM extents', (tester) async {
      const laneExtent = 160.0;
      const itemExtent = 72.0;
      const padding = EdgeInsets.all(4);

      await tester.pumpWidget(
        _app(
          _board(
            lanes: _flowLanes(),
            editMode: true,
            config: hm,
            laneExtent: laneExtent,
            itemExtent: itemExtent,
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('item:a')),
      );
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump();

      final feedbackSize = tester.getSize(find.text('feedback:a'));
      expect(feedbackSize.width, itemExtent);
      expect(feedbackSize.height, laneExtent - padding.vertical);

      await gesture.up();
      await tester.pumpAndSettle();
    });
  });

  group('BoardView add placement and visibility', () {
    testWidgets('edit-only hides adds until edit mode in both layouts', (
      tester,
    ) async {
      Widget laneAdd(BuildContext context, BoardLane<String> lane) {
        return Text('lane-add:${lane.id}');
      }

      Widget boardAdd(BuildContext context) => const Text('board-add');

      for (final layout in BoardLayout.values) {
        await tester.pumpWidget(
          _app(
            _board(
              lanes: _flowLanes(),
              config: BoardViewConfig(layout: layout),
              laneAddBuilder: laneAdd,
              boardAddBuilder: boardAdd,
              onItemMoved: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('lane-add:todo'), findsNothing);
        expect(find.text('board-add'), findsNothing);

        await tester.pumpWidget(
          _app(
            _board(
              lanes: _flowLanes(),
              editMode: true,
              config: BoardViewConfig(layout: layout),
              laneAddBuilder: laneAdd,
              boardAddBuilder: boardAdd,
              onItemMoved: (_) {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('lane-add:todo'), findsOneWidget);
        expect(find.text('board-add'), findsOneWidget);
      }
    });

    testWidgets('start-placed adds sit before items and collections (VM)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _board(
            lanes: const [
              BoardLane(id: 'todo', items: ['a', 'b']),
            ],
            editMode: true,
            config: const BoardViewConfig(
              laneAddPlacement: BoardSlotPlacement.start,
              boardAddPlacement: BoardSlotPlacement.start,
              addVisibility: BoardAddVisibility.always,
            ),
            laneAddBuilder: (context, lane) => const Text('lane-add'),
            boardAddBuilder: (context) => const Text('board-add'),
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        _orderAlong(
          tester,
          ['board-add', 'header:todo'],
          vertical: false,
        ).first,
        'board-add',
      );
      expect(
        _orderAlong(tester, ['lane-add', 'item:a', 'item:b'], vertical: true),
        ['lane-add', 'item:a', 'item:b'],
      );
    });

    testWidgets('end-placed adds sit after items and collections (HM)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _board(
            lanes: const [
              BoardLane(id: 'todo', items: ['a', 'b']),
            ],
            editMode: true,
            config: const BoardViewConfig(
              layout: BoardLayout.horizontal,
              laneAddPlacement: BoardSlotPlacement.end,
              boardAddPlacement: BoardSlotPlacement.end,
              addVisibility: BoardAddVisibility.always,
            ),
            laneAddBuilder: (context, lane) => const Text('lane-add'),
            boardAddBuilder: (context) => const Text('board-add'),
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        _orderAlong(
          tester,
          ['header:todo', 'board-add'],
          vertical: true,
        ).last,
        'board-add',
      );
      expect(
        _orderAlong(tester, ['item:a', 'item:b', 'lane-add'], vertical: false),
        ['item:a', 'item:b', 'lane-add'],
      );
    });
  });

  group('BoardView header pin', () {
    testWidgets('VM pinned header stays hit-testable after item scroll', (
      tester,
    ) async {
      final laneController = ScrollController();
      addTearDown(laneController.dispose);

      await tester.pumpWidget(
        _app(
          _board(
            lanes: _overflowLanes(laneCount: 1, itemsPerLane: 16),
            config: const BoardViewConfig(headerPin: BoardHeaderPin.pinned),
            laneScrollControllers: {'lane-0': laneController},
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      laneController.jumpTo(600);
      await tester.pumpAndSettle();

      expect(find.text('header:lane-0').hitTestable(), findsOneWidget);
      expect(find.text('item:lane-0-item-0').hitTestable(), findsNothing);
    });

    testWidgets('HM pinned header stays hit-testable after item scroll', (
      tester,
    ) async {
      final laneController = ScrollController();
      addTearDown(laneController.dispose);

      await tester.pumpWidget(
        _app(
          _board(
            lanes: _overflowLanes(laneCount: 1, itemsPerLane: 16),
            config: const BoardViewConfig(
              layout: BoardLayout.horizontal,
              headerPin: BoardHeaderPin.pinned,
            ),
            laneScrollControllers: {'lane-0': laneController},
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      laneController.jumpTo(600);
      await tester.pumpAndSettle();

      expect(find.text('header:lane-0').hitTestable(), findsOneWidget);
    });

    testWidgets('VM unpinned header scrolls away with items', (tester) async {
      final laneController = ScrollController();
      addTearDown(laneController.dispose);

      await tester.pumpWidget(
        _app(
          _board(
            lanes: _overflowLanes(laneCount: 1, itemsPerLane: 16),
            laneScrollControllers: {'lane-0': laneController},
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      laneController.jumpTo(600);
      await tester.pumpAndSettle();

      expect(find.text('header:lane-0').hitTestable(), findsNothing);
    });
  });

  group('BoardView scroll indicator', () {
    testWidgets('default overflow chrome is a thumb, not arrows', (
      tester,
    ) async {
      final boardController = ScrollController();
      addTearDown(boardController.dispose);

      await tester.pumpWidget(
        _app(
          _board(
            lanes: _overflowLanes(laneCount: 8, itemsPerLane: 1),
            scrollController: boardController,
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BoardScrollThumb), findsWidgets);
      expect(find.byType(BoardScrollArrows), findsNothing);
      expect(find.byIcon(Icons.keyboard_arrow_right), findsNothing);
    });

    testWidgets('VM arrows nudge the collections scroller', (tester) async {
      final boardController = ScrollController();
      addTearDown(boardController.dispose);

      await tester.pumpWidget(
        _app(
          _board(
            lanes: _overflowLanes(laneCount: 8, itemsPerLane: 1),
            config: const BoardViewConfig(
              scrollIndicator: BoardScrollIndicator.arrows,
            ),
            scrollController: boardController,
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BoardScrollArrows), findsWidgets);
      expect(find.bySemanticsLabel('Scroll right'), findsWidgets);

      final before = boardController.offset;
      await tester.tap(find.bySemanticsLabel('Scroll right').first);
      await tester.pumpAndSettle();
      expect(boardController.offset, greaterThan(before));
    });

    testWidgets('HM arrows nudge the collections scroller', (tester) async {
      final boardController = ScrollController();
      addTearDown(boardController.dispose);

      await tester.pumpWidget(
        _app(
          _board(
            lanes: _overflowLanes(laneCount: 8, itemsPerLane: 1),
            config: const BoardViewConfig(
              layout: BoardLayout.horizontal,
              scrollIndicator: BoardScrollIndicator.arrows,
            ),
            scrollController: boardController,
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Scroll down'), findsWidgets);

      final before = boardController.offset;
      await tester.tap(find.bySemanticsLabel('Scroll down').first);
      await tester.pumpAndSettle();
      expect(boardController.offset, greaterThan(before));
    });
  });

  group('BoardView drag axis', () {
    testWidgets('constrains item Draggable to the configured axis', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _board(
            lanes: _flowLanes(),
            editMode: true,
            config: const BoardViewConfig(dragAxis: DragAxis.vertical),
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_itemDraggable(tester).axis, Axis.vertical);

      await tester.pumpWidget(
        _app(
          _board(
            lanes: _flowLanes(),
            editMode: true,
            config: const BoardViewConfig(dragAxis: DragAxis.horizontal),
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_itemDraggable(tester).axis, Axis.horizontal);

      await tester.pumpWidget(
        _app(
          _board(
            lanes: _flowLanes(),
            editMode: true,
            onItemMoved: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_itemDraggable(tester).axis, isNull);
    });
  });
}
