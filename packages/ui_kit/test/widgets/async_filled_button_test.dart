import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AsyncFilledButton', () {
    testWidgets('shows label when idle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncFilledButton(
              onPressed: () {},
              label: const Text('Submit'),
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('shows loader when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncFilledButton(
              onPressed: () {},
              label: const Text('Submit'),
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('shows success label and disables tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncFilledButton(
              onPressed: () => tapped = true,
              label: const Text('Submit'),
              successLabel: 'Done',
            ),
          ),
        ),
      );

      expect(find.text('Done'), findsOneWidget);
      await tester.tap(find.byType(FilledButton));
      expect(tapped, isFalse);
    });

    testWidgets('flexSuccessLabel wraps long success text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncFilledButton(
              onPressed: () {},
              label: const Text('Submit'),
              flexSuccessLabel: true,
              successLabel: 'A very long success message that might overflow',
              successIcon: const Icon(Icons.check, size: 20),
            ),
          ),
        ),
      );

      expect(find.byType(Flexible), findsOneWidget);
    });
  });
}
