import 'package:models/src/enums/analytics/export.dart';
import 'package:models/src/models/analytics/analytics_event_data.dart';

class SearchEventData extends AnalyticsEventData {
  const SearchEventData({
    required this.page,
    required this.action,
    required this.queryLength,
    this.resultCount,
  });

  final AnalyticsPage page;
  final AnalyticsAction action;
  final int queryLength;
  final int? resultCount;

  @override
  AnalyticsEventName get eventName => AnalyticsEventName.search;

  @override
  Map<AnalyticsParamKey, Object?> get parameters => {
    AnalyticsParamKey.page: page.key,
    AnalyticsParamKey.action: action.key,
    AnalyticsParamKey.queryLength: queryLength,
    AnalyticsParamKey.resultCount: resultCount,
  };
}
