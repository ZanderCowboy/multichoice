import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Light haptic feedback when entering home edit mode (mobile only).
Future<void> triggerEditModeHaptic() async {
  if (kIsWeb) return;

  final platform = defaultTargetPlatform;
  if (platform != TargetPlatform.android && platform != TargetPlatform.iOS) {
    return;
  }

  try {
    if (platform == TargetPlatform.android) {
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
