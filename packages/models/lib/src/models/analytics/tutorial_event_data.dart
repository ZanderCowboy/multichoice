import 'package:models/src/enums/analytics/export.dart';
import 'package:models/src/enums/app_tips/app_tip.dart';
import 'package:models/src/models/analytics/analytics_event_data.dart';

class TutorialEventData extends AnalyticsEventData {
  const TutorialEventData({
    required this.page,
    required this.action,
    this.tip,
  });

  final AnalyticsPage page;
  final AnalyticsAction action;
  final AppTip? tip;

  @override
  AnalyticsEventName get eventName => AnalyticsEventName.tutorialAction;

  @override
  Map<AnalyticsParamKey, Object?> get parameters => {
    AnalyticsParamKey.page: page.key,
    AnalyticsParamKey.action: action.key,
    if (tip != null) AnalyticsParamKey.tutorialStep: tip!.bitIndex,
  };
}
