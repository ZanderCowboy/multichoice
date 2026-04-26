import 'package:models/src/enums/analytics/export.dart';
import 'package:models/src/models/analytics/analytics_event_data.dart';

class FeedbackEventData extends AnalyticsEventData {
  const FeedbackEventData({
    required this.page,
    required this.action,
    this.rating,
    this.category,
    this.errorMessage,
  });

  final AnalyticsPage page;
  final AnalyticsAction action;
  final int? rating;
  final String? category;
  final String? errorMessage;

  @override
  AnalyticsEventName get eventName => AnalyticsEventName.feedbackAction;

  @override
  Map<AnalyticsParamKey, Object?> get parameters => {
    AnalyticsParamKey.page: page.key,
    AnalyticsParamKey.action: action.key,
    AnalyticsParamKey.rating: rating,
    AnalyticsParamKey.category: category,
    AnalyticsParamKey.errorMessage: errorMessage,
  };
}
