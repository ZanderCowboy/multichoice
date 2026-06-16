import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AsyncOutlinedButton', () {
    testWidgets('shows icon and label when idle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncOutlinedButton(
              onPressed: () {},
              label: const Text('Continue'),
            ),
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
      expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
    });

    testWidgets('shows loader in icon slot when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncOutlinedButton(
              onPressed: () {},
              label: const Text('Continue'),
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows success label only when set', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncOutlinedButton(
              onPressed: () {},
              label: const Text('Continue'),
              successLabel: 'Coming soon',
            ),
          ),
        ),
      );

      expect(find.text('Coming soon'), findsOneWidget);
      expect(find.text('Continue'), findsNothing);
    });
  });
}
