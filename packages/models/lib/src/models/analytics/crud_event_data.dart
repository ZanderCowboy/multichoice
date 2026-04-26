import 'package:models/src/enums/analytics/export.dart';
import 'package:models/src/models/analytics/analytics_event_data.dart';

class CrudEventData extends AnalyticsEventData {
  const CrudEventData({
    required this.page,
    required this.entity,
    required this.action,
    this.tabId,
    this.entryId,
    this.itemCount,
  });

  final AnalyticsPage page;
  final AnalyticsEntity entity;
  final AnalyticsAction action;
  final int? tabId;
  final int? entryId;
  final int? itemCount;

  @override
  AnalyticsEventName get eventName => AnalyticsEventName.crudAction;

  @override
  Map<AnalyticsParamKey, Object?> get parameters => {
    AnalyticsParamKey.page: page.key,
    AnalyticsParamKey.entity: entity.key,
    AnalyticsParamKey.action: action.key,
    AnalyticsParamKey.tabId: tabId,
    AnalyticsParamKey.entryId: entryId,
    AnalyticsParamKey.itemCount: itemCount,
  };
}
