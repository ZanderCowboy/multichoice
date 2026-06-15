import 'package:models/models.dart';

abstract class IAppTipsController {
  Future<void> init();

  /// The next tip to show, or `null` when all tips are dismissed or skipped.
  Future<AppTip?> get activeTip;

  Future<void> dismissTip(AppTip tip);

  Future<void> completeTips();

  Future<void> resetTips();
}
