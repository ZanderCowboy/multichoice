import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('DragDropBoard', () {
    testWidgets('renders lanes and items', (tester) async {
      final lanes = [
        Lane<String>(id: '1', items: ['a', 'b']),
        Lane<String>(id: '2', items: ['c']),
      ];
      final onDropCalls = <List<dynamic>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: DragDropBoard<String>(
                lanes: lanes,
                itemIdOf: (s) => s,
                itemBuilder: (context, item, isPlaceholder, {leading}) =>
                    Text(item, key: ValueKey(item)),
                onDrop: (itemId, fromLaneId, fromIndex, toLaneId, toIndex) {
                  onDropCalls.add([
                    itemId,
                    fromLaneId,
                    fromIndex,
                    toLaneId,
                    toIndex,
                  ]);
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
      expect(onDropCalls, isEmpty);
    });

    testWidgets('calls onDrop with correct args on same-lane reorder',
        (tester) async {
      final lanes = [
        Lane<String>(id: '1', items: ['a', 'b']),
      ];
      final onDropCalls = <List<dynamic>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: DragDropBoard<String>(
                lanes: lanes,
                itemIdOf: (s) => s,
                itemBuilder: (context, item, isPlaceholder, {leading}) =>
                    SizedBox(
                  height: 72,
                  child: leading ?? Text(item, key: ValueKey(item)),
                ),
                onDrop: (itemId, fromLaneId, fromIndex, toLaneId, toIndex) {
                  onDropCalls.add([
                    itemId,
                    fromLaneId,
                    fromIndex,
                    toLaneId,
                    toIndex,
                  ]);
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Drag 'a' (index 0) down to below 'b' (index 2)
      final draggable = find.text('a');
      await tester.drag(draggable, const Offset(0, 100));
      await tester.pumpAndSettle();

      expect(onDropCalls.length, 1);
      expect(onDropCalls[0][0], 'a');
      expect(onDropCalls[0][1], '1');
      expect(onDropCalls[0][2], 0);
      expect(onDropCalls[0][3], '1');
      expect(onDropCalls[0][4], greaterThanOrEqualTo(1));
    });

    testWidgets('calls onDrop with correct args on cross-lane move',
        (tester) async {
      final lanes = [
        Lane<String>(id: '1', items: ['a']),
        Lane<String>(id: '2', items: ['b']),
      ];
      final onDropCalls = <List<dynamic>>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 500,
              height: 300,
              child: DragDropBoard<String>(
                lanes: lanes,
                itemIdOf: (s) => s,
                itemBuilder: (context, item, isPlaceholder, {leading}) =>
                    SizedBox(
                  height: 72,
                  width: 200,
                  child: leading ?? Text(item, key: ValueKey(item)),
                ),
                layout: BoardLayout.vertical,
                laneWidth: 220,
                onDrop: (itemId, fromLaneId, fromIndex, toLaneId, toIndex) {
                  onDropCalls.add([
                    itemId,
                    fromLaneId,
                    fromIndex,
                    toLaneId,
                    toIndex,
                  ]);
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Drag 'a' from lane 1 to lane 2 (horizontal movement)
      final draggable = find.text('a');
      await tester.drag(draggable, const Offset(250, 0));
      await tester.pumpAndSettle();

      expect(onDropCalls.length, 1);
      expect(onDropCalls[0], ['a', '1', 0, '2', 0]);
    });

    testWidgets('accepts custom placeholderBuilder', (tester) async {
      final lanes = [
        Lane<String>(id: '1', items: ['a']),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 300,
              child: DragDropBoard<String>(
                lanes: lanes,
                itemIdOf: (s) => s,
                itemBuilder: (context, item, isPlaceholder, {leading}) =>
                    SizedBox(
                  height: 72,
                  child: leading ?? Text(item, key: ValueKey(item)),
                ),
                placeholderBuilder: (context, {width, height}) =>
                    Container(key: const Key('custom_placeholder')),
                onDrop: (_, __, ___, ____, _____) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(const Key('custom_placeholder')), findsNothing);

      // Complete a drag - source slot shows placeholder during drag
      await tester.drag(find.text('a'), const Offset(0, 80));
      await tester.pumpAndSettle();
    });

    testWidgets('renders board with empty lane', (tester) async {
      final lanes = [
        Lane<String>(id: '1', items: ['a']),
        Lane<String>(id: '2', items: []),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 600,
              height: 300,
              child: DragDropBoard<String>(
                lanes: lanes,
                itemIdOf: (s) => s,
                itemBuilder: (context, item, isPlaceholder, {leading}) =>
                    SizedBox(
                  height: 72,
                  width: 250,
                  child: leading ?? Text(item, key: ValueKey(item)),
                ),
                layout: BoardLayout.vertical,
                laneWidth: 280,
                onDrop: (_, __, ___, ____, _____) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('a'), findsOneWidget);
      // Empty lane has one drop slot; board builds successfully
    });
  });
}
