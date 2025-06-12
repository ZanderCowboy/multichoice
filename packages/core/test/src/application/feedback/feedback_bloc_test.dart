import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late FeedbackBloc feedbackBloc;
  late MockFeedbackRepository mockRepository;

  setUp(() {
    mockRepository = MockFeedbackRepository();
    feedbackBloc = FeedbackBloc(mockRepository);
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
      timestamp: DateTime.now(),
      userId: 'user1',
      userEmail: 'test@example.com',
      category: 'General Feedback',
    );

    test('initial state is correct', () {
      expect(feedbackBloc.state, equals(FeedbackState.initial()));
    });

    blocTest<FeedbackBloc, FeedbackState>(
      'emits [loading, success] when feedback is submitted successfully',
      build: () {
        when(mockRepository.submitFeedback(testFeedback))
            .thenAnswer((_) async => {});
        return feedbackBloc;
      },
      act: (bloc) => bloc.add(FeedbackEvent.submit(testFeedback)),
      expect: () => [
        FeedbackState(
          feedback: testFeedback,
          isLoading: true,
          isSuccess: false,
          isError: false,
          errorMessage: null,
        ),
        FeedbackState(
          feedback: testFeedback,
          isLoading: false,
          isSuccess: true,
          isError: false,
          errorMessage: null,
        ),
      ],
      verify: (_) {
        verify(mockRepository.submitFeedback(testFeedback)).called(1);
      },
    );

    blocTest<FeedbackBloc, FeedbackState>(
      'emits [loading, error] when feedback submission fails',
      build: () {
        when(mockRepository.submitFeedback(testFeedback))
            .thenThrow(Exception('Failed to submit'));
        return feedbackBloc;
      },
      act: (bloc) => bloc.add(FeedbackEvent.submit(testFeedback)),
      expect: () => [
        FeedbackState(
          feedback: testFeedback,
          isLoading: true,
          isSuccess: false,
          isError: false,
          errorMessage: null,
        ),
        FeedbackState(
          feedback: testFeedback,
          isLoading: false,
          isSuccess: false,
          isError: true,
          errorMessage: 'Exception: Failed to submit',
        ),
      ],
      verify: (_) {
        verify(mockRepository.submitFeedback(testFeedback)).called(1);
      },
    );

    blocTest<FeedbackBloc, FeedbackState>(
      'emits initial state when reset is called',
      build: () => feedbackBloc,
      act: (bloc) => bloc.add(const FeedbackEvent.reset()),
      expect: () => [FeedbackState.initial()],
    );
  });
}
