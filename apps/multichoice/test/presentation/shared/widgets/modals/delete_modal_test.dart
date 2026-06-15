import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/shared/widgets/modals/delete_modal.dart';

import '../../../../helpers/export.dart';

void main() {
  testWidgets('deleteModal displays correctly and handles actions', (
    tester,
  ) async {
    var confirmPressed = false;
    var cancelPressed = false;
    final t = LocaleSettings.instance.currentTranslations;

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
    expect(find.byKey(keys.deleteModalTitle), findsOneWidget);
    expect(find.text('Delete Item?'), findsOneWidget);
    expect(
      find.text('Are you sure you want to delete this item?'),
      findsOneWidget,
    );
    expect(find.text(t.common.cancel), findsOneWidget);
    expect(find.text(t.common.delete), findsOneWidget);

    await tester.tap(find.text(t.common.cancel));
    await tester.pumpAndSettle();
    expect(cancelPressed, isTrue);

    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(t.common.delete));
    await tester.pumpAndSettle();
    expect(confirmPressed, isTrue);
  });

  testWidgets('deleteModal uses default cancel when onCancel is omitted', (
    tester,
  ) async {
    var confirmPressed = false;
    final t = LocaleSettings.instance.currentTranslations;

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
    expect(find.text(t.modals.deleteItem(item: 'Item')), findsOneWidget);
    expect(find.text(t.common.cancel), findsOneWidget);
    expect(find.text(t.common.delete), findsOneWidget);

    await tester.tap(find.text(t.common.cancel));
    await tester.pumpAndSettle();
    expect(find.text('Open Modal'), findsOneWidget);

    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(t.common.delete));
    await tester.pumpAndSettle();
    expect(confirmPressed, isTrue);
  });
}
