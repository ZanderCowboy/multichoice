import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/shared/widgets/add_widgets/_base.dart';

import '../../../../helpers/export.dart';

void main() {
  testWidgets('AddTabCard renders correctly and responds to tap',
      (WidgetTester tester) async {
    const testWidth = 100.0;
    const Color testColor = Colors.blue;
    const testSemanticLabel = 'Add Tab';
    var pressed = false;

    await tester.pumpWidget(
      widgetWrapper(
        child: AddTabCard(
          onPressed: () {
            pressed = true;
          },
          width: testWidth,
          color: testColor,
          semanticLabel: testSemanticLabel,
        ),
      ),
    );

    expect(find.byIcon(Icons.add_outlined), findsOneWidget);

    expect(find.bySemanticsLabel(testSemanticLabel), findsOneWidget);

    final cardWidget = tester.widget<Card>(find.byType(Card));
    expect(cardWidget.color, equals(testColor));

    final sizedBox = tester.widget<SizedBox>(
      find.byKey(const Key('AddTabSizedBox')),
    );

    expect(sizedBox.width, equals(testWidth));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(pressed, isTrue);
  });

  testWidgets('AddTabCard uses default values when not provided',
      (WidgetTester tester) async {
    var pressed = false;

    await tester.pumpWidget(
      widgetWrapper(
        child: AddTabCard(
          onPressed: () {
            pressed = true;
          },
        ),
      ),
    );

    expect(
      find.bySemanticsLabel('AddTab'),
      findsOneWidget,
    );

    final cardWidget = tester.widget<Card>(find.byType(Card));
    expect(cardWidget.color, isNotNull);

    final sizedBox = tester.widget<SizedBox>(
      find.byKey(keys.addTabSizedBox),
    );
    expect(sizedBox.width, isNull);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(pressed, isTrue);
  });
}
