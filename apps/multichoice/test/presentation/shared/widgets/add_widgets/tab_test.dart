import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

// Assuming AddTabCard is part of your project imports.

void main() {
  testWidgets('AddTabCard renders correctly and responds to tap',
      (WidgetTester tester) async {
    // Test values
    const testWidth = 100.0;
    const Color testColor = Colors.blue;
    const testSemanticLabel = 'Add Tab';

    // Track if the button was pressed
    var pressed = false;

    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddTabCard(
            onPressed: () {
              pressed = true;
            },
            width: testWidth,
            color: testColor,
            semanticLabel: testSemanticLabel,
          ),
        ),
      ),
    );

    // Ensure only one Icon widget is displayed
    expect(find.byIcon(Icons.add_outlined), findsOneWidget);

    // Ensure only one widget with the semantic label is found
    expect(find.bySemanticsLabel(testSemanticLabel), findsOneWidget);

    // Verify the Card widget color (since _BaseCard is private, we check the Card directly)
    final cardWidget = tester.widget<Card>(find.byType(Card));
    expect(cardWidget.color, equals(testColor));

    // debugDumpApp();
    // Verify the width of the SizedBox inside the AddTabCard
    final sizedBox = tester.widget<SizedBox>(
      // find.descendant(
      //   of: find.byType(Padding),
      //   matching: find.byType(SizedBox),
      //   matchRoot: true,
      // ),
      find.byKey(const Key('AddTabSizedBox')),
    );

    expect(sizedBox.width, equals(testWidth));

    // Simulate a tap and check if onPressed was called
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle(); // Let any animations complete

    // Ensure the onPressed callback was triggered
    expect(pressed, isTrue);
  });

  testWidgets('AddTabCard uses default values when not provided',
      (WidgetTester tester) async {
    // Track if the button was pressed
    var pressed = false;

    // Build the widget tree with only required parameters
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddTabCard(
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    // Ensure only one widget with the default semantic label
    expect(
      find.bySemanticsLabel('AddTab'),
      findsOneWidget,
    ); // Default label is empty string

    // Verify the Card widget uses the default color
    final cardWidget = tester.widget<Card>(find.byType(Card));
    expect(cardWidget.color, isNotNull); // Ensure a color is applied

    // Verify the width of the SizedBox inside the AddTabCard (default is null)
    final sizedBox = tester.widget<SizedBox>(
      find.byKey(const Key('AddTabSizedBox')),
    );
    expect(sizedBox.width, isNull); // Default width is null

    // Tap the button and check if the callback is triggered
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });
}
