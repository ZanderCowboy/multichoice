import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/app/extensions/extension_getters.dart';

void main() {
  testWidgets('ThemeGetter extension returns the correct ThemeData',
      (WidgetTester tester) async {
    // Define a widget that uses the extension
    final testWidget = MaterialApp(
      theme: ThemeData.light(),
      home: Builder(
        builder: (BuildContext context) {
          // Retrieve the ThemeData using the extension
          final themeData = context.theme;

          // Create a simple widget to verify the theme
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

    // Pump the widget into the widget tree
    await tester.pumpWidget(testWidget);

    // Retrieve the current ThemeData
    final BuildContext context = tester.element(find.byType(Scaffold));
    final currentTheme = Theme.of(context);

    // Verify that the extension returns the correct ThemeData
    expect(currentTheme, equals(context.theme));
  });
}
