import 'package:models/models.dart';

class AppTipsStorageCodec {
  const AppTipsStorageCodec._();

  static const int stableStepOffset = 1000;

  /// Maps legacy linear tour progress to dismissed tip bits.
  static int migrateLegacyTourProgress(int storedStep) {
    final stableValue = storedStep >= stableStepOffset
        ? storedStep - stableStepOffset
        : storedStep;

    if (stableValue < 0) {
      return 0;
    }

    if (stableValue >= 14) {
      return AppTip.allDismissedMask;
    }

    if (stableValue >= 8) {
      return _maskThrough(AppTip.editAndSearch);
    }

    if (stableValue >= 6) {
      return _maskThrough(AppTip.entryActions);
    }

    if (stableValue >= 4) {
      return _maskThrough(AppTip.addEntry);
    }

    if (stableValue >= 3) {
      return _maskThrough(AppTip.addCollection);
    }

    if (stableValue >= 1) {
      return _maskThrough(AppTip.collections);
    }

    return 0;
  }

  static int _maskThrough(AppTip tip) {
    var mask = 0;
    for (final current in AppTip.orderedTips) {
      mask |= current.mask;
      if (current == tip) {
        break;
      }
    }

    return mask;
  }
}
