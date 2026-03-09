import 'package:core/src/services/interfaces/i_analytics_service.dart';
import 'package:models/models.dart';

class NoopAnalyticsService implements IAnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> logEvent(AnalyticsEventData eventData) async {}

  @override
  Future<void> logScreenView(ScreenViewEventData eventData) async {}

  @override
  Future<void> setUserId(String userId) async {}

  @override
  Future<void> setUserProperty(
    AnalyticsUserProperty property,
    String value,
  ) async {}

  @override
  Future<void> setUserProperties(
    Map<AnalyticsUserProperty, String> properties,
  ) async {}
}
