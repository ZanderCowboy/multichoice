part of 'export.dart';

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

  /// Returns true when this tap transitions into enabled.
  bool registerTap(DateTime now) {
    if (_enabled) return false;

    final firstTapAt = _firstTapAt;
    if (firstTapAt == null || now.difference(firstTapAt) > window) {
      _firstTapAt = now;
      _tapCount = 1;
      return false;
    }

    _tapCount += 1;
    if (_tapCount >= requiredTaps) {
      _enabled = true;
      return true;
    }

    return false;
  }

  void reset() {
    _enabled = false;
    _tapCount = 0;
    _firstTapAt = null;
  }
}

// EOF
