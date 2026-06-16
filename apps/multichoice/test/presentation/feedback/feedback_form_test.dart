import 'package:core/core.dart';
import 'package:core/src/services/implementations/noop_analytics_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/view/debug/remote_config_debug_notifier.dart';
import 'package:multichoice/presentation/feedback/widgets/feedback_form.dart';
import 'package:provider/provider.dart';

import '../../helpers/export.dart';

void main() {
  late MockFeedbackRepository mockRepository;
  late MockAppStorageService mockAppStorage;
  late MockFirebaseService mockFirebase;
  late MockAppInfoService mockAppInfo;
  late MockCredentialValidationService mockCredentialValidation;
  late FeedbackBloc feedbackBloc;
  late RemoteConfigDebugNotifier remoteConfigDebugNotifier;

  setUp(() {
    mockRepository = MockFeedbackRepository();
    mockAppStorage = MockAppStorageService();
    mockFirebase = MockFirebaseService();
    mockAppInfo = MockAppInfoService();
    mockCredentialValidation = MockCredentialValidationService();

    when(
      mockAppStorage.canSubmitMoreFeedbackToday(),
    ).thenAnswer((_) async => true);
    when(
      mockAppStorage.recordFeedbackSubmissionForToday(),
    ).thenAnswer((_) async {});
    when(mockFirebase.isEnabled(any)).thenReturn(false);
    when(mockAppInfo.getAppVersion()).thenAnswer((_) async => '1.0.0');
    when(mockCredentialValidation.validateOptionalEmail(any)).thenReturn(null);

    if (coreSl.isRegistered<IFirebaseService>()) {
      // ignore: discarded_futures
      coreSl.unregister<IFirebaseService>();
    }
    if (coreSl.isRegistered<IAppInfoService>()) {
      // ignore: discarded_futures
      coreSl.unregister<IAppInfoService>();
    }
    if (coreSl.isRegistered<ICredentialValidationService>()) {
      // ignore: discarded_futures
      coreSl.unregister<ICredentialValidationService>();
    }

    coreSl
      ..registerSingleton<IFirebaseService>(mockFirebase)
      ..registerSingleton<IAppInfoService>(mockAppInfo)
      ..registerSingleton<ICredentialValidationService>(
        mockCredentialValidation,
      );

    feedbackBloc = FeedbackBloc(
      mockRepository,
      const NoopAnalyticsService(),
      mockAppStorage,
    );
    remoteConfigDebugNotifier = RemoteConfigDebugNotifier();
  });

  tearDown(() async {
    await feedbackBloc.close();
    remoteConfigDebugNotifier.dispose();
    if (coreSl.isRegistered<IFirebaseService>()) {
      coreSl.unregister<IFirebaseService>();
    }
    if (coreSl.isRegistered<IAppInfoService>()) {
      coreSl.unregister<IAppInfoService>();
    }
    if (coreSl.isRegistered<ICredentialValidationService>()) {
      coreSl.unregister<ICredentialValidationService>();
    }
  });

  testWidgets('clears message and email after successful submit', (
    tester,
  ) async {
    when(
      mockRepository.submitFeedback(any, imageFiles: anyNamed('imageFiles')),
    ).thenAnswer((_) async => const Right(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<RemoteConfigDebugNotifier>.value(
            value: remoteConfigDebugNotifier,
          ),
        ],
        child: widgetWrapper(
          child: BlocProvider<FeedbackBloc>.value(
            value: feedbackBloc,
            child: const FeedbackForm(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Great app',
    );

    await tester.runAsync(() async {
      feedbackBloc.add(
        FeedbackEvent.submit(
          FeedbackDTO(
            id: '1',
            message: 'Great app',
            userEmail: 'user@example.com',
            rating: 4,
            deviceInfo: 'test',
            appVersion: '1.0.0',
            timestamp: DateTime(2024),
            category: 'General Feedback',
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump();

    final emailField = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    final messageField = tester.widget<TextFormField>(
      find.byType(TextFormField).at(1),
    );

    expect(messageField.controller?.text, isEmpty);
    expect(emailField.controller?.text, isEmpty);
    expect(feedbackBloc.state.feedback.rating, 0);
  });
}
