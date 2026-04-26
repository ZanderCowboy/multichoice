import 'package:flutter_test/flutter_test.dart';
import 'package:multichoice/presentation/drawer/widgets/export.dart';

void main() {
  group('AboutDeveloperModeUnlocker', () {
    test('enables after required taps within window', () {
      final unlocker = AboutDeveloperModeUnlocker(
        requiredTaps: 3,
        window: const Duration(seconds: 2),
      );

      final t0 = DateTime(2026);
      expect(unlocker.isEnabled, isFalse);
      expect(unlocker.registerTap(t0), isFalse);
      expect(unlocker.registerTap(t0.add(const Duration(milliseconds: 100))), isFalse);
      expect(unlocker.registerTap(t0.add(const Duration(milliseconds: 200))), isTrue);
      expect(unlocker.isEnabled, isTrue);
    });

    test('does not enable when taps are outside the window', () {
      final unlocker = AboutDeveloperModeUnlocker(
        requiredTaps: 2,
        window: const Duration(milliseconds: 50),
      );

      final t0 = DateTime(2026);
      expect(unlocker.registerTap(t0), isFalse);
      expect(unlocker.registerTap(t0.add(const Duration(milliseconds: 60))), isFalse);
      expect(unlocker.isEnabled, isFalse);
    });
  });
}

// EOF
