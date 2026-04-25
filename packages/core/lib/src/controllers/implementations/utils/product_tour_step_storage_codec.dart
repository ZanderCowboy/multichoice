import 'package:models/models.dart';

class ProductTourStepStorageCodec {
  const ProductTourStepStorageCodec._();

  static const int stableStepOffset = 1000;

  static int? normalizeStoredStepToStableValue(int storedStep) {
    if (storedStep >= stableStepOffset) {
      final stableValue = storedStep - stableStepOffset;
      final step = ProductTourStep.fromValue(stableValue);
      return step != null && step.value >= 0 ? stableValue : null;
    }

    final legacyStepValue = _migrateLegacyIndex(storedStep);
    final step = ProductTourStep.fromValue(legacyStepValue);
    return step != null && step.value >= 0 ? legacyStepValue : null;
  }

  static int encodeStableStepValue(int stableValue) {
    return stableValue + stableStepOffset;
  }

  static int _migrateLegacyIndex(int legacyIndex) {
    if (legacyIndex >= ProductTourStep.showEditAndSearch.value &&
        legacyIndex <= ProductTourStep.closeSettings.value) {
      return legacyIndex + 1;
    }

    return legacyIndex;
  }
}
