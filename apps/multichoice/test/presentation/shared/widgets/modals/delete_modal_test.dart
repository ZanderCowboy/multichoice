import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';

import '../../../../helpers/export.dart';

void main() {
  testWidgets('deleteModal displays correctly and handles actions', (
    tester,
  ) async {
    var confirmPressed = false;
    var cancelPressed = false;

    await tester.pumpWidget(
      widgetWrapper(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                deleteModal(
                  context: context,
                  title: 'Item',
                  content: const Text(
                    'Are you sure you want to delete this item?',
                  ),
                  onConfirm: () {
                    confirmPressed = true;
                    Navigator.of(context).pop();
                  },
                  onCancel: () {
                    cancelPressed = true;
                    Navigator.of(context).pop();
                  },
                );
              },
              child: const Text('Open Modal'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    final richTextWidget = tester.widget<RichText>(
      find.byKey(keys.deleteModalTitle),
    );

    final textSpan = richTextWidget.text as TextSpan;
    expect(textSpan.text, 'Delete ');
    expect((textSpan.children![0] as TextSpan).text, 'Item');
    expect((textSpan.children![1] as TextSpan).text, '?');

    expect(
      find.text('Are you sure you want to delete this item?'),
      findsOneWidget,
    );

    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(cancelPressed, isTrue);

    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(confirmPressed, isTrue);
  });

  testWidgets('deleteModal displays correctly and handles actions', (
    tester,
  ) async {
    var confirmPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  deleteModal(
                    context: context,
                    title: 'Item',
                    content: const Text(
                      'Are you sure you want to delete this item?',
                    ),
                    onConfirm: () {
                      confirmPressed = true;
                      Navigator.of(context).pop();
                    },
                  );
                },
                child: const Text('Open Modal'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    final richTextWidget = tester.widget<RichText>(
      find.byKey(keys.deleteModalTitle),
    );

    final textSpan = richTextWidget.text as TextSpan;
    expect(textSpan.text, 'Delete ');
    expect((textSpan.children![0] as TextSpan).text, 'Item');
    expect((textSpan.children![1] as TextSpan).text, '?');

    expect(
      find.text('Are you sure you want to delete this item?'),
      findsOneWidget,
    );

    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Open Modal'), findsOneWidget);

    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(confirmPressed, isTrue);
  });
}
