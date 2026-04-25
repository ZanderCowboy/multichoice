import 'package:models/src/enums/analytics/export.dart';
import 'package:models/src/models/analytics/analytics_event_data.dart';

class UiActionEventData extends AnalyticsEventData {
  const UiActionEventData({
    required this.page,
    required this.button,
    required this.action,
    this.source,
  });

  final AnalyticsPage page;
  final AnalyticsButton button;
  final AnalyticsAction action;
  final String? source;

  @override
  AnalyticsEventName get eventName => AnalyticsEventName.uiAction;

  @override
  Map<AnalyticsParamKey, Object?> get parameters => {
    AnalyticsParamKey.page: page.key,
    AnalyticsParamKey.button: button.key,
    AnalyticsParamKey.action: action.key,
    AnalyticsParamKey.source: source,
  };
}
