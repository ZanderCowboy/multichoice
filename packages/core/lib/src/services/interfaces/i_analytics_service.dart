import 'package:models/models.dart';

abstract class IAnalyticsService {
  Future<void> logEvent(AnalyticsEventData eventData);

  Future<void> logScreenView(ScreenViewEventData eventData);

  Future<void> setUserId(String userId);

  Future<void> setUserProperty(
    AnalyticsUserProperty property,
    String value,
  );

  Future<void> setUserProperties(
    Map<AnalyticsUserProperty, String> properties,
  );
}
