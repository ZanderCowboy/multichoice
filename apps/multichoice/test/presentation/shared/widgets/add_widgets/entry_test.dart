// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

// Assuming AddEntryCard and _BaseCard are part of your project imports.

void main() {
  testWidgets('AddEntryCard renders correctly and responds to tap',
      (WidgetTester tester) async {
    // Test values
    const EdgeInsetsGeometry testPadding = EdgeInsets.all(10);
    const EdgeInsetsGeometry testMargin = EdgeInsets.all(5);
    const Color testColor = Colors.blue;
    const testSemanticLabel = 'Add Entry';

    // Track if the button was pressed
    var pressed = false;

    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddEntryCard(
            onPressed: () {
              pressed = true;
            },
            padding: testPadding,
            margin: testMargin,
            color: testColor,
            semanticLabel: testSemanticLabel,
          ),
        ),
      ),
    );

    // Check that the Icon widget is displayed
    expect(find.byIcon(Icons.add_outlined), findsOneWidget);

    // Check that the semantic label is applied correctly
    expect(find.bySemanticsLabel(testSemanticLabel), findsOneWidget);

    // Verify the padding and margin
    final cardWidget = tester.widget<Card>(find.byType(Card));
    expect(cardWidget.margin, equals(testMargin)); // Verify margin

    // Verify the color
    expect(cardWidget.color, equals(testColor));

    // Simulate a tap and check if onPressed was called
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle(); // Let any animations complete

    // Ensure the onPressed callback was triggered
    expect(pressed, isTrue);
  });

  testWidgets('AddEntryCard uses default values when not provided',
      (WidgetTester tester) async {
    // Track if the button was pressed
    var pressed = false;

    // Build the widget tree with only required parameters
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddEntryCard(
            onPressed: () {
              pressed = true;
            },
            padding:
                EdgeInsets.zero, // Custom padding to isolate the margin test
          ),
        ),
      ),
    );

    // Verify default padding and margin
    final cardWidget = tester.widget<Card>(find.byType(Card));
    expect(
      cardWidget.margin,
      equals(const EdgeInsets.all(4)),
    ); // Default margin for AddEntryCard

    // Tap the button and check if the callback is triggered
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });
}
