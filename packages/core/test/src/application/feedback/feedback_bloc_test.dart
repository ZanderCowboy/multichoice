import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/src/repositories/implementation/feedback/feedback_repository.dart';
import 'package:core/src/services/implementations/noop_analytics_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late FeedbackBloc feedbackBloc;
  late MockFeedbackRepository mockRepository;
  late MockAppStorageService mockAppStorage;
  final fixedTimestamp = DateTime(2024, 1, 1);

  setUp(() {
    mockRepository = MockFeedbackRepository();
    mockAppStorage = MockAppStorageService();
    when(mockAppStorage.canSubmitMoreFeedbackToday()).thenAnswer((_) async => true);
    feedbackBloc = FeedbackBloc(
      mockRepository,
      const NoopAnalyticsService(),
      mockAppStorage,
    );
  });

  tearDown(() {
    feedbackBloc.close();
  });

  group('FeedbackBloc', () {
    final testFeedback = FeedbackDTO(
      id: '1',
      message: 'Test feedback',
      rating: 5,
      deviceInfo: 'Test Device',
      appVersion: '1.0.0',
      timestamp: fixedTimestamp,
      userId: 'user1',
      userEmail: 'test@example.com',
      category: 'General Feedback',
    );

    test('initial state is correct', () {
      final initialState = feedbackBloc.state;
      expect(initialState.isLoading, false);
      expect(initialState.isSuccess, false);
      expect(initialState.isError, false);
      expect(initialState.errorMessage, null);
      expect(initialState.feedback.id, '');
      expect(initialState.feedback.message, '');
      expect(initialState.feedback.rating, 1);
      expect(initialState.feedback.deviceInfo, '');
      expect(initialState.feedback.appVersion, '');
      expect(initialState.feedback.userId, null);
      expect(initialState.feedback.userEmail, null);
      expect(initialState.feedback.category, null);
      expect(initialState.feedback.status, 'pending');
    });

    blocTest<FeedbackBloc, FeedbackState>(
      'emits [loading, success] when feedback is submitted successfully',
      build: () {
        when(
          mockRepository.submitFeedback(testFeedback),
        ).thenAnswer((_) async => const Right(null));
        return feedbackBloc;
      },
      act: (bloc) => bloc.add(FeedbackEvent.submit(testFeedback)),
      expect: () => [
        isA<FeedbackState>()
            .having(
              (state) => state.isLoading,
              'isLoading',
              true,
            )
            .having(
              (state) => state.feedback,
              'feedback',
              testFeedback,
            ),
        isA<FeedbackState>()
            .having(
              (state) => state.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.isSuccess,
              'isSuccess',
              true,
            )
            .having(
              (state) => state.feedback,
              'feedback',
              testFeedback,
            ),
      ],
      verify: (_) {
        verify(mockRepository.submitFeedback(testFeedback)).called(1);
        verify(mockAppStorage.recordFeedbackSubmissionForToday()).called(1);
      },
    );

    blocTest<FeedbackBloc, FeedbackState>(
      'emits error when rating is below one without calling repository',
      build: () => feedbackBloc,
      act: (bloc) => bloc.add(
        FeedbackEvent.submit(testFeedback.copyWith(rating: 0)),
      ),
      expect: () => [
        isA<FeedbackState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Please choose a rating from 1 to 5 stars.',
            )
            .having((s) => s.isLoading, 'isLoading', false),
      ],
      verify: (_) {
        verifyNever(mockRepository.submitFeedback(any));
        verifyNever(mockAppStorage.recordFeedbackSubmissionForToday());
      },
    );

    blocTest<FeedbackBloc, FeedbackState>(
      'emits error when daily feedback cap is reached',
      build: () {
        when(
          mockAppStorage.canSubmitMoreFeedbackToday(),
        ).thenAnswer((_) async => false);
        return feedbackBloc;
      },
      act: (bloc) => bloc.add(FeedbackEvent.submit(testFeedback)),
      expect: () => [
        isA<FeedbackState>()
            .having((s) => s.isError, 'isError', true)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'You can submit up to 5 feedback reports per day. Try again tomorrow.',
            )
            .having((s) => s.isLoading, 'isLoading', false),
      ],
      verify: (_) {
        verifyNever(mockRepository.submitFeedback(any));
        verifyNever(mockAppStorage.recordFeedbackSubmissionForToday());
      },
    );

    blocTest<FeedbackBloc, FeedbackState>(
      'emits [loading, error] when feedback submission fails',
      build: () {
        when(
          mockRepository.submitFeedback(testFeedback),
        ).thenAnswer((_) async => Left(FeedbackException('Failed to submit')));
        return feedbackBloc;
      },
      act: (bloc) => bloc.add(FeedbackEvent.submit(testFeedback)),
      expect: () => [
        isA<FeedbackState>()
            .having(
              (state) => state.isLoading,
              'isLoading',
              true,
            )
            .having(
              (state) => state.feedback,
              'feedback',
              testFeedback,
            ),
        isA<FeedbackState>()
            .having(
              (state) => state.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.isError,
              'isError',
              true,
            )
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              'Failed to submit',
            )
            .having(
              (state) => state.feedback,
              'feedback',
              testFeedback,
            ),
      ],
      verify: (_) {
        verify(mockRepository.submitFeedback(testFeedback)).called(1);
        verifyNever(mockAppStorage.recordFeedbackSubmissionForToday());
      },
    );

    blocTest<FeedbackBloc, FeedbackState>(
      'emits initial state when reset is called',
      build: () => feedbackBloc,
      act: (bloc) => bloc.add(const FeedbackEvent.reset()),
      expect: () => [
        isA<FeedbackState>()
            .having(
              (state) => state.isLoading,
              'isLoading',
              false,
            )
            .having(
              (state) => state.isSuccess,
              'isSuccess',
              false,
            )
            .having(
              (state) => state.isError,
              'isError',
              false,
            )
            .having(
              (state) => state.errorMessage,
              'errorMessage',
              null,
            ),
      ],
    );

    group('fieldChanged event', () {
      blocTest<FeedbackBloc, FeedbackState>(
        'updates category field correctly',
        build: () => feedbackBloc,
        act: (bloc) => bloc.add(
          const FeedbackEvent.fieldChanged(
            field: FeedbackField.category,
            value: 'Bug Report',
          ),
        ),
        expect: () => [
          isA<FeedbackState>().having(
            (state) => state.feedback.category,
            'category',
            'Bug Report',
          ),
        ],
      );

      blocTest<FeedbackBloc, FeedbackState>(
        'updates email field correctly',
        build: () => feedbackBloc,
        act: (bloc) => bloc.add(
          const FeedbackEvent.fieldChanged(
            field: FeedbackField.email,
            value: 'new@example.com',
          ),
        ),
        expect: () => [
          isA<FeedbackState>().having(
            (state) => state.feedback.userEmail,
            'userEmail',
            'new@example.com',
          ),
        ],
      );

      blocTest<FeedbackBloc, FeedbackState>(
        'updates message field correctly',
        build: () => feedbackBloc,
        act: (bloc) => bloc.add(
          const FeedbackEvent.fieldChanged(
            field: FeedbackField.message,
            value: 'New message',
          ),
        ),
        expect: () => [
          isA<FeedbackState>().having(
            (state) => state.feedback.message,
            'message',
            'New message',
          ),
        ],
      );

      blocTest<FeedbackBloc, FeedbackState>(
        'updates rating field correctly',
        build: () => feedbackBloc,
        act: (bloc) => bloc.add(
          const FeedbackEvent.fieldChanged(
            field: FeedbackField.rating,
            value: 4,
          ),
        ),
        expect: () => [
          isA<FeedbackState>().having(
            (state) => state.feedback.rating,
            'rating',
            4,
          ),
        ],
      );

      blocTest<FeedbackBloc, FeedbackState>(
        'ignores null values',
        build: () => feedbackBloc,
        act: (bloc) => bloc.add(
          const FeedbackEvent.fieldChanged(
            field: FeedbackField.category,
            value: null,
          ),
        ),
        expect: () => <FeedbackState>[],
      );
    });
  });
}
