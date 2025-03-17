import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

import '../../test/helpers/export.dart';

class EntryMethods {
  static Future<void> pressAndOpenAddEntry(WidgetTester tester) async {
    // await tester.tapAt(find.);
    await tester.tap(find.byKey(keys.addNewEntryButton).first);
    await tester.pumpAndSettle();

    expect(find.text('Add New Entry', findRichText: true), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    expect(find.byType(TextFormField), findsExactly(2));
  }

  static Future<void> addEntryDialog(
    WidgetTester tester,
    String title,
    String? subtitle,
  ) async {
    await tester.enterText(find.byType(TextFormField).first, title);
    await tester.enterText(find.byType(TextFormField).last, subtitle ?? '');
    await tester.pumpAndSettle();

    expect(find.text(title), findsOneWidget);
    expect(find.text(subtitle ?? ''), findsOneWidget);
  }

  static Future<void> pressAndCloseDialog(
    WidgetTester tester, {
    bool? shouldCancel,
  }) async {
    if (shouldCancel ?? false) {
      await tester.tap(find.text('Cancel'));
    } else {
      await tester.tap(find.text('Add'));
    }

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // add check to confirm modal has closed.
    expect(find.byIcon(Icons.add_outlined), findsAtLeast(1));
    expect(find.byType(AddEntryCard), findsAtLeast(1));
  }
}
