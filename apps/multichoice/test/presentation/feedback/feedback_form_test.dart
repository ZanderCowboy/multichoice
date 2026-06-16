import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/view/debug/remote_config_debug_notifier.dart';
import 'package:multichoice/i18n/strings.g.dart';
import 'package:multichoice/presentation/feedback/widgets/feedback_form.dart';
import 'package:provider/provider.dart';

import '../../helpers/export.dart';

void main() {
  late MockFeedbackBloc mockFeedbackBloc;
  late MockFirebaseService mockFirebase;
  late MockAppInfoService mockAppInfo;
  late MockCredentialValidationService mockCredentialValidation;
  late RemoteConfigDebugNotifier remoteConfigDebugNotifier;
  late StreamController<FeedbackState> stateController;
  late FeedbackState currentState;

  void emitState(FeedbackState state) {
    currentState = state;
    stateController.add(state);
  }

  FeedbackDTO updateFeedbackField(
    FeedbackDTO feedback,
    FeedbackField field,
    Object? value,
  ) {
    return feedback.copyWith(
      category: field == FeedbackField.category
          ? value as String?
          : feedback.category,
      userEmail: field == FeedbackField.email
          ? value as String?
          : feedback.userEmail,
      message: field == FeedbackField.message
          ? value! as String
          : feedback.message,
      rating: field == FeedbackField.rating ? value! as int : feedback.rating,
    );
  }

  void stubFeedbackBloc() {
    currentState = FeedbackState.initial();
    stateController = StreamController<FeedbackState>.broadcast();
    emitState(currentState);

    when(mockFeedbackBloc.state).thenAnswer((_) => currentState);
    when(mockFeedbackBloc.stream).thenAnswer((_) => stateController.stream);
    when(mockFeedbackBloc.isClosed).thenReturn(false);
    when(mockFeedbackBloc.close()).thenAnswer((_) async {
      await stateController.close();
    });

    when(mockFeedbackBloc.add(any)).thenAnswer((invocation) {
      final event = invocation.positionalArguments[0] as FeedbackEvent;
      switch (event) {
        case SubmitFeedback(:final feedback):
          emitState(
            currentState.copyWith(
              isLoading: true,
              isSuccess: false,
              feedback: feedback,
            ),
          );
          emitState(
            currentState.copyWith(
              isLoading: false,
              isSuccess: true,
              feedback: feedback,
            ),
          );
        case ResetFeedback():
          currentState = FeedbackState.initial();
          emitState(currentState);
        case FeedbackFieldChanged(:final field, :final value):
          if (value != null) {
            emitState(
              currentState.copyWith(
                feedback: updateFeedbackField(
                  currentState.feedback,
                  field,
                  value,
                ),
              ),
            );
          }
        case FeedbackImageAdded():
        case FeedbackImageRemoved():
          break;
      }
    });
  }

  setUp(() {
    mockFeedbackBloc = MockFeedbackBloc();
    mockFirebase = MockFirebaseService();
    mockAppInfo = MockAppInfoService();
    mockCredentialValidation = MockCredentialValidationService();
    remoteConfigDebugNotifier = RemoteConfigDebugNotifier();

    when(mockFirebase.isEnabled(any)).thenReturn(false);
    when(mockAppInfo.getAppVersion()).thenAnswer((_) async => '1.0.0');
    when(mockCredentialValidation.validateOptionalEmail(any)).thenReturn(null);

    coreSl
      ..pushNewScope()
      ..registerSingleton<IFirebaseService>(mockFirebase)
      ..registerSingleton<IAppInfoService>(mockAppInfo)
      ..registerSingleton<ICredentialValidationService>(
        mockCredentialValidation,
      );

    stubFeedbackBloc();
  });

  tearDown(() async {
    remoteConfigDebugNotifier.dispose();
    if (!stateController.isClosed) {
      await stateController.close();
    }
    await coreSl.popScope();
  });

  testWidgets('clears message and email after successful submit', (
    tester,
  ) async {
    final t = LocaleSettings.instance.currentTranslations;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<RemoteConfigDebugNotifier>.value(
            value: remoteConfigDebugNotifier,
          ),
        ],
        child: widgetWrapper(
          child: BlocProvider<FeedbackBloc>.value(
            value: mockFeedbackBloc,
            child: const FeedbackForm(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(t.feedback.categories.generalFeedback).last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).first,
      'user@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Great app',
    );

    await tester.tap(find.byIcon(Icons.star_border).at(3));
    await tester.pump();

    await tester.tap(find.text(t.feedback.submitFeedback));
    await tester.pumpAndSettle();

    final emailField = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    final messageField = tester.widget<TextFormField>(
      find.byType(TextFormField).at(1),
    );

    expect(messageField.controller?.text, isEmpty);
    expect(emailField.controller?.text, isEmpty);
    expect(currentState.feedback.rating, 0);
  });
}
