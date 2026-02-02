import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/main.dart' as app;
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

import 'shared/export.dart';
import 'shared/settings_methods.dart';

/// This test will run a journey where the user
///
/// - opens the app with no existing data,
/// - adds new data,
/// - toggles theme and layout,
/// - exports data,
/// - clears all data,
/// - and exists the app.
///
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final keys = WidgetKeys.instance;

  testWidgets('Test User Journey', (tester) async {
    app.main();
    // Wait for the app to settle
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Note: Permission dialog is not shown as storage permissions are not requested
    // If you need to test with permissions, uncomment the following line and enable
    // storage permissions in AndroidManifest.xml
    // await permissionsDialog(tester, shouldDeny: true);

    // On Home Screen - Verify Add Tab Card
    expect(find.byIcon(Icons.add_outlined), findsOneWidget);
    expect(find.byType(AddTabCard), findsOneWidget);

    // Open Settings Drawer - Test Layout Switch
    await SettingsMethods.openOrCloseSettingsDrawer(tester);
    await SettingsMethods.toggleLayoutSwitch(
      tester,
      'Horizontal/Vertical Layout',
      keys.layoutSwitch,
    );
    await SettingsMethods.openOrCloseSettingsDrawer(tester, shouldClose: true);

    // On Home Screen - Add New Tab
    expect(find.byIcon(Icons.add_outlined), findsOneWidget);
    expect(find.byType(AddTabCard), findsOneWidget);

    // Opens new tab dialog, enters details, and closes dialog
    await TabsActions.pressAndOpenAddTab(tester);
    await TabsActions.addTabDialog(tester, 'Tab 1', 'Tab 2');
    await TabsActions.pressAndCloseDialog(tester);

    expect(find.text('Tab 1'), findsOneWidget);

    // Open Settings Drawer - Test Light/Dark Mode
    await SettingsMethods.openOrCloseSettingsDrawer(tester);
    await SettingsMethods.toggleLightDarkModeSwitch(
      tester,
      'Light / Dark Mode',
      keys.lightDarkModeSwitch,
    );
    await SettingsMethods.openOrCloseSettingsDrawer(tester, shouldClose: true);

    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.byType(AddTabCard), findsOneWidget);
    final BuildContext context = tester.element(find.byType(AddTabCard));
    final theme = Theme.of(context);
    expect(theme.brightness, Brightness.dark);

    // On Home Screen
    await tester.tap(find.byIcon(Icons.search_outlined));
    await tester.pumpAndSettle();
    expect(find.textContaining('not been implemented'), findsOneWidget);

    // Open Settings Drawer - Test Delete All Data - Cancel
    await SettingsMethods.openOrCloseSettingsDrawer(tester);
    await SettingsMethods.pressDeleteAllButton(
      tester,
      keys.deleteAllDataButton,
    );
    await SettingsMethods.deleteAllDataDialog(tester, shouldCancel: true);
    await SettingsMethods.openOrCloseSettingsDrawer(tester, shouldClose: true);

    // Open Settings Drawer - Test Delete All Data - Delete
    await SettingsMethods.openOrCloseSettingsDrawer(tester);
    await SettingsMethods.pressDeleteAllButton(
      tester,
      keys.deleteAllDataButton,
    );
    await SettingsMethods.deleteAllDataDialog(tester);
    await SettingsMethods.openOrCloseSettingsDrawer(tester, shouldClose: true);

    expect(find.text('Tab 1'), findsNothing);
  });
}
