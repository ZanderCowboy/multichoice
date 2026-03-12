import 'package:models/src/enums/analytics/export.dart';
import 'package:models/src/enums/product_tour/product_tour_step.dart';
import 'package:models/src/models/analytics/analytics_event_data.dart';

class TutorialEventData extends AnalyticsEventData {
  const TutorialEventData({
    required this.page,
    required this.action,
    this.step,
  });

  final AnalyticsPage page;
  final AnalyticsAction action;
  final ProductTourStep? step;

  @override
  AnalyticsEventName get eventName => AnalyticsEventName.tutorialAction;

  @override
  Map<AnalyticsParamKey, Object?> get parameters => {
    AnalyticsParamKey.page: page.key,
    AnalyticsParamKey.action: action.key,
    AnalyticsParamKey.tutorialStep: step?.value,
  };
}
