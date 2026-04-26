import 'dart:developer';

import 'package:core/src/services/interfaces/i_analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

@LazySingleton(as: IAnalyticsService)
class FirebaseAnalyticsService implements IAnalyticsService {
  FirebaseAnalyticsService({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent(AnalyticsEventData eventData) async {
    try {
      await _analytics.logEvent(
        name: eventData.eventName.key,
        parameters: eventData.toFirebaseParameters(),
      );
    } catch (e) {
      log('Failed to log analytics event ${eventData.eventName.key}: $e');
    }
  }

  @override
  Future<void> logScreenView(ScreenViewEventData eventData) async {
    try {
      await _analytics.logScreenView(
        screenName: eventData.page.key,
      );

      if (eventData.previousPage != null) {
        await _analytics.logEvent(
          name: AnalyticsEventName.uiAction.key,
          parameters: {
            AnalyticsParamKey.action.key: AnalyticsAction.open.key,
            AnalyticsParamKey.page.key: eventData.page.key,
            AnalyticsParamKey.previousPage.key: eventData.previousPage!.key,
          },
        );
      }
    } catch (e) {
      log('Failed to log screen view ${eventData.page.key}: $e');
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      log('Failed to set analytics user id: $e');
    }
  }

  @override
  Future<void> setUserProperty(
    AnalyticsUserProperty property,
    String value,
  ) async {
    try {
      await _analytics.setUserProperty(
        name: property.key,
        value: value,
      );
    } catch (e) {
      log('Failed to set analytics user property ${property.key}: $e');
    }
  }

  @override
  Future<void> setUserProperties(
    Map<AnalyticsUserProperty, String> properties,
  ) async {
    for (final entry in properties.entries) {
      await setUserProperty(entry.key, entry.value);
    }
  }
}
