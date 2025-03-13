import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/app/extensions/extension_getters.dart';

void main() {
  testWidgets('ThemeGetter extension returns the correct ThemeData',
      (WidgetTester tester) async {
    final testWidget = MaterialApp(
      theme: ThemeData.light(),
      home: Builder(
        builder: (BuildContext context) {
          final themeData = context.theme;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Theme Test',
                style: TextStyle(color: themeData.primaryColor),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpWidget(testWidget);

    final BuildContext context = tester.element(find.byType(Scaffold));
    final currentTheme = Theme.of(context);

    expect(currentTheme, equals(context.theme));
  });
}
