import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:core/src/controllers/implementations/utils/app_tips_storage_codec.dart';

void main() {
  group('AppTipsStorageCodec', () {
    test('returns zero for legacy welcome state', () {
      expect(AppTipsStorageCodec.migrateLegacyTourProgress(-1), 0);
    });

    test('maps legacy collection step to collections tip dismissed', () {
      expect(
        AppTipsStorageCodec.migrateLegacyTourProgress(1),
        AppTip.collections.mask,
      );
    });

    test('maps legacy thanks popup to all tips dismissed', () {
      expect(
        AppTipsStorageCodec.migrateLegacyTourProgress(14),
        AppTip.allDismissedMask,
      );
    });
  });
}
