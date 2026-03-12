part of '../home_page.dart';

Future<void> _triggerEditModeHaptic() async {
  // Haptics are only available on mobile platforms with supported hardware.
  if (kIsWeb) return;

  final platform = defaultTargetPlatform;
  if (platform != TargetPlatform.android && platform != TargetPlatform.iOS) {
    return;
  }

  try {
    if (platform == TargetPlatform.android) {
      // Android impact haptics can be too subtle; long-press vibration is
      // stronger and more consistently perceptible across devices.
      await HapticFeedback.vibrate();
    } else {
      await HapticFeedback.mediumImpact();
    }
  } on PlatformException {
    // Ignore unsupported devices or disabled system haptics.
  } on MissingPluginException {
    // Ignore missing platform implementations (for example desktop targets).
  }
}
