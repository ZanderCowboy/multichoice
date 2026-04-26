part of 'export.dart';

class AboutDeveloperModeUnlockResult {
  const AboutDeveloperModeUnlockResult({
    required this.didEnable,
    required this.isFirstTapInSequence,
    required this.remainingTaps,
  });

  final bool didEnable;
  final bool isFirstTapInSequence;
  final int remainingTaps;

  bool get shouldShowCountdown =>
      !didEnable && !isFirstTapInSequence && remainingTaps > 0;
}

class AboutDeveloperModeUnlocker {
  AboutDeveloperModeUnlocker({
    this.requiredTaps = 7,
    this.window = const Duration(seconds: 3),
  });

  final int requiredTaps;
  final Duration window;

  bool _enabled = false;
  int _tapCount = 0;
  DateTime? _firstTapAt;

  bool get isEnabled => _enabled;

  /// Returns the current unlock progress for this tap.
  AboutDeveloperModeUnlockResult registerTap(DateTime now) {
    if (_enabled) {
      return const AboutDeveloperModeUnlockResult(
        didEnable: false,
        isFirstTapInSequence: false,
        remainingTaps: 0,
      );
    }

    final firstTapAt = _firstTapAt;
    if (firstTapAt == null || now.difference(firstTapAt) > window) {
      _firstTapAt = now;
      _tapCount = 1;
      return AboutDeveloperModeUnlockResult(
        didEnable: false,
        isFirstTapInSequence: true,
        remainingTaps: requiredTaps - _tapCount,
      );
    }

    _tapCount += 1;
    if (_tapCount >= requiredTaps) {
      _enabled = true;
      return const AboutDeveloperModeUnlockResult(
        didEnable: true,
        isFirstTapInSequence: false,
        remainingTaps: 0,
      );
    }

    return AboutDeveloperModeUnlockResult(
      didEnable: false,
      isFirstTapInSequence: false,
      remainingTaps: requiredTaps - _tapCount,
    );
  }

  void reset() {
    _enabled = false;
    _tapCount = 0;
    _firstTapAt = null;
  }
}

// EOF
