import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

import '../../../../helpers/widget_wrapper.dart';

void main() {
  testWidgets('AddEntryCard renders correctly and responds to tap',
      (WidgetTester tester) async {
    const EdgeInsetsGeometry testPadding = EdgeInsets.all(10);
    const EdgeInsetsGeometry testMargin = EdgeInsets.all(5);
    const Color testColor = Colors.blue;
    const testSemanticLabel = 'Add Entry';

    var pressed = false;
    await tester.pumpWidget(
      widgetWrapper(
        child: AddEntryCard(
          onPressed: () {
            pressed = true;
          },
          padding: testPadding,
          margin: testMargin,
          color: testColor,
          semanticLabel: testSemanticLabel,
        ),
      ),
    );

    expect(find.byIcon(Icons.add_outlined), findsOneWidget);

    expect(find.bySemanticsLabel(testSemanticLabel), findsOneWidget);

    final cardWidget = tester.widget<Card>(find.byType(Card));
    expect(cardWidget.margin, equals(testMargin));
    expect(cardWidget.color, equals(testColor));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });

  testWidgets('AddEntryCard uses default values when not provided',
      (WidgetTester tester) async {
    var pressed = false;

    await tester.pumpWidget(
      widgetWrapper(
        child: AddEntryCard(
          onPressed: () {
            pressed = true;
          },
          padding: EdgeInsets.zero,
        ),
      ),
    );

    final cardWidget = tester.widget<Card>(find.byType(Card));
    expect(
      cardWidget.margin,
      equals(const EdgeInsets.all(4)),
    );

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });
}
