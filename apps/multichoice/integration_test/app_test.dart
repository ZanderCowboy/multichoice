import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:multichoice/main.dart' as app;
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test counter increment', (WidgetTester tester) async {
    // Launch the app
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify initial value is 0
    expect(find.text('Permission Required'), findsOneWidget);
    expect(find.text('Deny'), findsOneWidget);
    expect(find.text('Open Settings'), findsOneWidget);

    // Tap the "+" button
    await tester.tap(find.text('Deny'));
    await tester.pumpAndSettle();

    // Verify the counter has incremented
    expect(find.byIcon(Icons.add_outlined), findsOneWidget);
    expect(find.byType(AddTabCard), findsOneWidget);

    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    var isVertical = true;
    // Will still possibly be used.
    // ignore: unused_local_variable
    final layoutSwitch = Switch(
      value: isVertical,
      onChanged: (bool value) {
        isVertical = value;
      },
    );
    expect(find.text('Horizontal/Vertical Layout'), findsOneWidget);
    // expect(find.byWidget(layoutSwitch), findsOneWidget);
    expect(find.byKey(const Key('layoutSwitch')), findsOneWidget);
    await tester.tap(find.byKey(const Key('layoutSwitch')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add_outlined), findsOneWidget);
    expect(find.byType(AddTabCard), findsOneWidget);
    await tester.tap(find.byType(AddTabCard));
    await tester.pumpAndSettle();

    expect(find.text('Add New Tab'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);

    expect(find.byType(TextFormField), findsExactly(2));
    await tester.enterText(find.byType(TextFormField).first, 'Tab 1');
    await tester.enterText(find.byType(TextFormField).last, 'Tab 2');
    await tester.pumpAndSettle();
    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('Tab 2'), findsOneWidget);
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Tab 1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search_outlined));
    await tester.pumpAndSettle();
    expect(find.textContaining('not been implemented'), findsOneWidget);

    // await tester.tap(find.text('Cancel'));
    // await tester.pumpAndSettle();
    // expect(find.text('Open Modal'), findsOneWidget);
  });
}
