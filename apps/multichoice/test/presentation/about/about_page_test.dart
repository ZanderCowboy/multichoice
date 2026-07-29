import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/about/about_page.dart';

import '../../helpers/export.dart';

void main() {
  testWidgets('AboutPage renders base UI', (tester) async {
    await tester.pumpWidget(
      widgetWrapper(
        child: const AboutPage(),
      ),
    );

    expect(find.text('Multichoice'), findsOneWidget);
  });
}
