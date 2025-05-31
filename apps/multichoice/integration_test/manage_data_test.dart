import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:multichoice/main.dart' as app;

import 'helpers/time.dart';
import 'shared/entry_methods.dart';
import 'shared/export.dart';

/// This test will run a journey where the user
///
/// - starts with a clean app,
/// - adds new tabs and entries,
/// - manages tabs by editing or deleting them,
/// - manages entries by editing or deleting them,
/// - finishes by clearing all data,
/// - and exists.
///
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Manage Data Journey', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await permissionsDialog(tester, shouldDeny: true);

    await TabsActions.pressAndOpenAddTab(tester);
    await TabsActions.addTabDialog(tester, 'Tab 1', 'Sub Tab 1');
    await TabsActions.pressAndCloseDialog(tester);

    await TabsActions.pressAndOpenAddTab(tester);
    await TabsActions.addTabDialog(tester, 'Tab 12', 'Sub Tab 12');
    await TabsActions.pressAndCloseDialog(tester);

    await tester.threeSeconds;

    await EntryMethods.pressAndOpenAddEntry(tester);
    await tester.threeSeconds;
    await EntryMethods.addEntryDialog(tester, 'Entry 1', 'Sub Entry 1');
    await EntryMethods.pressAndCloseDialog(tester);

    await EntryMethods.pressAndOpenAddEntry(tester);
    await tester.threeSeconds;
    await EntryMethods.addEntryDialog(tester, 'Entry 12', 'Sub Entry 12');
    await EntryMethods.pressAndCloseDialog(tester);

    await tester.hold;

    // expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    // await tester.tap(find.byIcon(Icons.settings_outlined));
    // await tester.pumpAndSettle();
  });
}
