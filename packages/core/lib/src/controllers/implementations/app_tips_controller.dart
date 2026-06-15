import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

import 'utils/app_tips_storage_codec.dart';

@Singleton(as: IAppTipsController)
class AppTipsController implements IAppTipsController {
  AppTipsController(
    this._appStorageService,
  );

  final IAppStorageService _appStorageService;

  @override
  Future<void> init() async {}

  @override
  Future<AppTip?> get activeTip async {
    if (await _appStorageService.isCompleted) {
      return null;
    }

    final mask = await _resolvedDismissedMask();
    return AppTip.firstUndismissed(mask);
  }

  @override
  Future<void> dismissTip(AppTip tip) async {
    final mask = await _resolvedDismissedMask();
    final updatedMask = mask | tip.mask;
    await _appStorageService.setDismissedAppTipsMask(updatedMask);

    if (AppTip.firstUndismissed(updatedMask) == null) {
      await completeTips();
    }
  }

  @override
  Future<void> completeTips() async {
    await _appStorageService.setDismissedAppTipsMask(AppTip.allDismissedMask);
    await _appStorageService.setIsCompleted(true);
  }

  @override
  Future<void> resetTips() async {
    await _appStorageService.resetTour();
  }

  Future<int> _resolvedDismissedMask() async {
    final storedMask = await _appStorageService.dismissedAppTipsMask;
    if (storedMask != 0) {
      return storedMask;
    }

    final legacyStep = await _appStorageService.currentStep;
    final migratedMask = AppTipsStorageCodec.migrateLegacyTourProgress(legacyStep);
    if (migratedMask != 0) {
      await _appStorageService.setDismissedAppTipsMask(migratedMask);
    }

    return migratedMask;
  }
}
