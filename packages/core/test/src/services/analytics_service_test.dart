import 'package:core/src/services/implementations/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockFirebaseAnalytics mockAnalytics;
  late FirebaseAnalyticsService analyticsService;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    analyticsService = FirebaseAnalyticsService(analytics: mockAnalytics);
  });

  group('FirebaseAnalyticsService - logEvent', () {
    test(
      'should call FirebaseAnalytics.logEvent with correct parameters',
      () async {
        final eventData = CrudEventData(
          page: AnalyticsPage.home,
          entity: AnalyticsEntity.tab,
          action: AnalyticsAction.create,
          tabId: 1,
        );

        when(
          mockAnalytics.logEvent(
            name: anyNamed('name'),
            parameters: anyNamed('parameters'),
          ),
        ).thenAnswer((_) async {});

        await analyticsService.logEvent(eventData);

        verify(
          mockAnalytics.logEvent(
            name: AnalyticsEventName.crudAction.key,
            parameters: {
              AnalyticsParamKey.page.key: AnalyticsPage.home.key,
              AnalyticsParamKey.entity.key: AnalyticsEntity.tab.key,
              AnalyticsParamKey.action.key: AnalyticsAction.create.key,
              AnalyticsParamKey.tabId.key: 1,
            },
          ),
        ).called(1);
      },
    );

    test('should swallow exceptions from FirebaseAnalytics.logEvent', () async {
      final eventData = CrudEventData(
        page: AnalyticsPage.home,
        entity: AnalyticsEntity.tab,
        action: AnalyticsAction.create,
      );

      when(
        mockAnalytics.logEvent(
          name: anyNamed('name'),
          parameters: anyNamed('parameters'),
        ),
      ).thenThrow(Exception('Analytics error'));

      // Should not throw
      await analyticsService.logEvent(eventData);

      verify(
        mockAnalytics.logEvent(
          name: anyNamed('name'),
          parameters: anyNamed('parameters'),
        ),
      ).called(1);
    });
  });

  group('FirebaseAnalyticsService - logScreenView', () {
    test(
      'should call FirebaseAnalytics.logScreenView with correct screen name',
      () async {
        final eventData = ScreenViewEventData(
          page: AnalyticsPage.home,
        );

        when(
          mockAnalytics.logScreenView(screenName: anyNamed('screenName')),
        ).thenAnswer((_) async {});

        await analyticsService.logScreenView(eventData);

        verify(
          mockAnalytics.logScreenView(
            screenName: AnalyticsPage.home.key,
          ),
        ).called(1);

        verifyNever(
          mockAnalytics.logEvent(
            name: anyNamed('name'),
            parameters: anyNamed('parameters'),
          ),
        );
      },
    );

    test(
      'should log both screen view and ui_action event when previousPage is provided',
      () async {
        final eventData = ScreenViewEventData(
          page: AnalyticsPage.home,
          previousPage: AnalyticsPage.search,
        );

        when(
          mockAnalytics.logScreenView(screenName: anyNamed('screenName')),
        ).thenAnswer((_) async {});

        when(
          mockAnalytics.logEvent(
            name: anyNamed('name'),
            parameters: anyNamed('parameters'),
          ),
        ).thenAnswer((_) async {});

        await analyticsService.logScreenView(eventData);

        verify(
          mockAnalytics.logScreenView(
            screenName: AnalyticsPage.home.key,
          ),
        ).called(1);

        verify(
          mockAnalytics.logEvent(
            name: AnalyticsEventName.uiAction.key,
            parameters: {
              AnalyticsParamKey.action.key: AnalyticsAction.open.key,
              AnalyticsParamKey.page.key: AnalyticsPage.home.key,
              AnalyticsParamKey.previousPage.key: AnalyticsPage.search.key,
            },
          ),
        ).called(1);
      },
    );

    test(
      'should swallow exceptions from FirebaseAnalytics.logScreenView',
      () async {
        final eventData = ScreenViewEventData(
          page: AnalyticsPage.home,
        );

        when(
          mockAnalytics.logScreenView(screenName: anyNamed('screenName')),
        ).thenThrow(Exception('Analytics error'));

        // Should not throw
        await analyticsService.logScreenView(eventData);

        verify(
          mockAnalytics.logScreenView(screenName: anyNamed('screenName')),
        ).called(1);
      },
    );

    test(
      'should swallow exceptions from FirebaseAnalytics.logEvent during screen view',
      () async {
        final eventData = ScreenViewEventData(
          page: AnalyticsPage.home,
          previousPage: AnalyticsPage.search,
        );

        when(
          mockAnalytics.logScreenView(screenName: anyNamed('screenName')),
        ).thenAnswer((_) async {});

        when(
          mockAnalytics.logEvent(
            name: anyNamed('name'),
            parameters: anyNamed('parameters'),
          ),
        ).thenThrow(Exception('Analytics error'));

        // Should not throw
        await analyticsService.logScreenView(eventData);

        verify(
          mockAnalytics.logScreenView(screenName: anyNamed('screenName')),
        ).called(1);
        verify(
          mockAnalytics.logEvent(
            name: anyNamed('name'),
            parameters: anyNamed('parameters'),
          ),
        ).called(1);
      },
    );
  });

  group('FirebaseAnalyticsService - setUserId', () {
    test('should call FirebaseAnalytics.setUserId with correct id', () async {
      when(
        mockAnalytics.setUserId(id: anyNamed('id')),
      ).thenAnswer((_) async {});

      await analyticsService.setUserId('user123');

      verify(
        mockAnalytics.setUserId(id: 'user123'),
      ).called(1);
    });

    test(
      'should swallow exceptions from FirebaseAnalytics.setUserId',
      () async {
        when(
          mockAnalytics.setUserId(id: anyNamed('id')),
        ).thenThrow(Exception('Analytics error'));

        // Should not throw
        await analyticsService.setUserId('user123');

        verify(
          mockAnalytics.setUserId(id: anyNamed('id')),
        ).called(1);
      },
    );
  });

  group('FirebaseAnalyticsService - setUserProperty', () {
    test(
      'should call FirebaseAnalytics.setUserProperty with correct values',
      () async {
        when(
          mockAnalytics.setUserProperty(
            name: anyNamed('name'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});

        await analyticsService.setUserProperty(
          AnalyticsUserProperty.appVersion,
          '1.0.0',
        );

        verify(
          mockAnalytics.setUserProperty(
            name: AnalyticsUserProperty.appVersion.key,
            value: '1.0.0',
          ),
        ).called(1);
      },
    );

    test(
      'should swallow exceptions from FirebaseAnalytics.setUserProperty',
      () async {
        when(
          mockAnalytics.setUserProperty(
            name: anyNamed('name'),
            value: anyNamed('value'),
          ),
        ).thenThrow(Exception('Analytics error'));

        // Should not throw
        await analyticsService.setUserProperty(
          AnalyticsUserProperty.appVersion,
          '1.0.0',
        );

        verify(
          mockAnalytics.setUserProperty(
            name: anyNamed('name'),
            value: anyNamed('value'),
          ),
        ).called(1);
      },
    );
  });

  group('FirebaseAnalyticsService - setUserProperties', () {
    test('should call setUserProperty for each property in the map', () async {
      when(
        mockAnalytics.setUserProperty(
          name: anyNamed('name'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async {});

      final properties = <AnalyticsUserProperty, String>{
        AnalyticsUserProperty.appVersion: '1.0.0',
        AnalyticsUserProperty.platform: 'android',
      };

      await analyticsService.setUserProperties(properties);

      verify(
        mockAnalytics.setUserProperty(
          name: AnalyticsUserProperty.appVersion.key,
          value: '1.0.0',
        ),
      ).called(1);

      verify(
        mockAnalytics.setUserProperty(
          name: AnalyticsUserProperty.platform.key,
          value: 'android',
        ),
      ).called(1);
    });

    test('should continue setting properties even if one throws', () async {
      when(
        mockAnalytics.setUserProperty(
          name: AnalyticsUserProperty.appVersion.key,
          value: anyNamed('value'),
        ),
      ).thenThrow(Exception('Analytics error'));

      when(
        mockAnalytics.setUserProperty(
          name: AnalyticsUserProperty.platform.key,
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async {});

      final properties = <AnalyticsUserProperty, String>{
        AnalyticsUserProperty.appVersion: '1.0.0',
        AnalyticsUserProperty.platform: 'android',
      };

      // Should not throw
      await analyticsService.setUserProperties(properties);

      verify(
        mockAnalytics.setUserProperty(
          name: AnalyticsUserProperty.appVersion.key,
          value: '1.0.0',
        ),
      ).called(1);

      verify(
        mockAnalytics.setUserProperty(
          name: AnalyticsUserProperty.platform.key,
          value: 'android',
        ),
      ).called(1);
    });
  });
}
