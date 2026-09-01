import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/src/widgets/board_view/scroll/scroll_controller_utils.dart';

void main() {
  testWidgets('primaryScrollPosition returns the attached position', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ListView.builder(
          controller: controller,
          itemCount: 1,
          itemBuilder: (context, index) => const SizedBox(height: 100),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final position = primaryScrollPosition(controller);
    expect(position, isNotNull);
    expect(controller.positions.length, 1);
    expect(primaryScrollPosition(controller), same(position));
  });

  test('primaryScrollPosition returns null when controller has no clients', () {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    expect(primaryScrollPosition(controller), isNull);
  });
}
