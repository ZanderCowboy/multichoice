import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class SettingsMethods {
  static Future<void> openOrCloseSettingsDrawer(
    WidgetTester tester, {
    bool shouldClose = false,
  }) async {
    if (shouldClose) {
      expect(find.byIcon(Icons.close_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_outlined));
    } else {
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.settings_outlined));
    }
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), shouldClose ? findsNothing : findsOneWidget);
  }

  static Future<void> toggleLayoutSwitch(
    WidgetTester tester,
    String text,
    Key key, {
    bool shouldSwitch = true,
  }) async {
    expect(find.text(text), findsOneWidget);
    expect(find.byKey(key), findsOneWidget);
    if (shouldSwitch) await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }

  static Future<void> toggleLightDarkModeSwitch(
    WidgetTester tester,
    String text,
    Key key, {
    bool shouldSwitch = true,
  }) async {
    expect(find.text(text), findsOneWidget);
    expect(find.byKey(key), findsOneWidget);
    if (shouldSwitch) await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }

  static Future<void> pressDeleteAllButton(
    WidgetTester tester,
    Key key,
  ) async {
    expect(find.text('Delete All Data'), findsOneWidget);
    expect(find.byKey(key), findsOneWidget);
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }

  static Future<void> deleteAllDataDialog(
    WidgetTester tester, {
    bool shouldCancel = false,
  }) async {
    expect(find.text('Delete all tabs and entries?'), findsOneWidget);
    expect(
      find.text('Are you sure you want to delete all tabs and their entries?'),
      findsOneWidget,
    );
    expect(find.text('No, cancel'), findsOneWidget);
    expect(find.text('Yes, delete'), findsOneWidget);

    if (shouldCancel) {
      await tester.tap(find.text('No, cancel'));
    } else {
      await tester.tap(find.text('Yes, delete'));
    }
    await tester.pumpAndSettle();
  }

  static Future<void> pressExportButton(
    WidgetTester tester,
    Key key, {
    bool shouldExport = true,
  }) async {
    expect(find.text('Import / Export Data'), findsOneWidget);
    expect(find.byIcon(Icons.import_export_outlined), findsOneWidget);
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();

    if (shouldExport) {
      expect(find.text('Export Successful'), findsOneWidget);
    } else {
      expect(find.text('Import'), findsNothing);
    }
  }
}
