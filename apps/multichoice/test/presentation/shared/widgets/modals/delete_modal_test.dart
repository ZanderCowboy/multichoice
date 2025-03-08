import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';

// Assuming deleteModal is part of your project imports.
// import 'path/to/delete_modal.dart';

void main() {
  testWidgets('deleteModal displays correctly and handles actions',
      (WidgetTester tester) async {
    // Track if the onConfirm callback is triggered
    var confirmPressed = false;
    var cancelPressed = false;

    // Build a test widget tree that includes the deleteModal call
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
      ),
    );

    // Open the modal by tapping the button
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Verify that the AlertDialog is displayed
    expect(find.byType(AlertDialog), findsOneWidget);

    // Use the key to directly find the RichText widget for the modal title
    final richTextWidget =
        tester.widget<RichText>(find.byKey(const Key('DeleteModalTitle')));

    // Extract the TextSpan from the RichText and verify the parts of the title
    final textSpan = richTextWidget.text as TextSpan;
    expect(textSpan.text, 'Delete ');
    expect((textSpan.children![0] as TextSpan).text, 'Item');
    expect((textSpan.children![1] as TextSpan).text, '?');

    // Verify the content of the modal
    expect(
      find.text('Are you sure you want to delete this item?'),
      findsOneWidget,
    );

    // Verify the Cancel and Delete buttons are present
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Tap the Cancel button and verify that the onCancel callback is triggered
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle(); // Wait for the dialog to close
    expect(cancelPressed, isTrue);

    // Reopen the modal for testing the Delete button
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    // Tap the Delete button and verify that the onConfirm callback is triggered
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle(); // Wait for the dialog to close
    expect(confirmPressed, isTrue);
  });

  testWidgets('deleteModal displays correctly and handles actions',
      (WidgetTester tester) async {
    // Track if the onConfirm callback is triggered
    var confirmPressed = false;
    // Will still possibly be used.
    // ignore: unused_local_variable
    const cancelPressed = false;

    // Build a test widget tree that includes the deleteModal call
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

    // Open the modal by tapping the button
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle(); // Wait for the dialog to appear

    // Verify that the AlertDialog is displayed
    expect(find.byType(AlertDialog), findsOneWidget);

    // Use the key to directly find the RichText widget for the modal title
    final richTextWidget =
        tester.widget<RichText>(find.byKey(const Key('DeleteModalTitle')));

    // Extract the TextSpan from the RichText and verify the parts of the title
    final textSpan = richTextWidget.text as TextSpan;
    expect(textSpan.text, 'Delete ');
    expect((textSpan.children![0] as TextSpan).text, 'Item');
    expect((textSpan.children![1] as TextSpan).text, '?');

    // Verify the content of the modal
    expect(
      find.text('Are you sure you want to delete this item?'),
      findsOneWidget,
    );

    // Verify the Cancel and Delete buttons are present
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Tap the Cancel button and verify that the onCancel callback is triggered
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle(); // Wait for the dialog to close
    expect(find.text('Open Modal'), findsOneWidget);

    // Reopen the modal for testing the Delete button
    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    // Tap the Delete button and verify that the onConfirm callback is triggered
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle(); // Wait for the dialog to close
    expect(confirmPressed, isTrue);
  });
}
