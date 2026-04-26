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

      final firstTap = unlocker.registerTap(t0);
      expect(firstTap.didEnable, isFalse);
      expect(firstTap.isFirstTapInSequence, isTrue);
      expect(firstTap.remainingTaps, 2);
      expect(firstTap.shouldShowCountdown, isFalse);

      final secondTap = unlocker.registerTap(
        t0.add(const Duration(milliseconds: 100)),
      );
      expect(secondTap.didEnable, isFalse);
      expect(secondTap.isFirstTapInSequence, isFalse);
      expect(secondTap.remainingTaps, 1);
      expect(secondTap.shouldShowCountdown, isTrue);

      final thirdTap = unlocker.registerTap(
        t0.add(const Duration(milliseconds: 200)),
      );
      expect(thirdTap.didEnable, isTrue);
      expect(thirdTap.remainingTaps, 0);
      expect(unlocker.isEnabled, isTrue);
    });

    test('does not enable when taps are outside the window', () {
      final unlocker = AboutDeveloperModeUnlocker(
        requiredTaps: 2,
        window: const Duration(milliseconds: 50),
      );

      final t0 = DateTime(2026);
      expect(unlocker.registerTap(t0).isFirstTapInSequence, isTrue);
      final nextTap = unlocker.registerTap(
        t0.add(const Duration(milliseconds: 60)),
      );
      expect(
        nextTap.isFirstTapInSequence,
        isTrue,
      );
      expect(unlocker.isEnabled, isFalse);
    });
  });
}

// EOF
