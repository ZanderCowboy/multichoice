import 'package:models/src/enums/analytics/export.dart';
import 'package:models/src/models/analytics/analytics_event_data.dart';

class SearchResultOpenedEventData extends AnalyticsEventData {
  const SearchResultOpenedEventData({
    required this.page,
    required this.resultType,
  });

  final AnalyticsPage page;
  final AnalyticsEntity resultType;

  @override
  AnalyticsEventName get eventName => AnalyticsEventName.searchResultOpened;

  @override
  Map<AnalyticsParamKey, Object?> get parameters => {
    AnalyticsParamKey.page: page.key,
    AnalyticsParamKey.resultType: resultType.key,
  };
}
