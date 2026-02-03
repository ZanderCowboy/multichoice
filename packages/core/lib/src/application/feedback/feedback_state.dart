part of 'feedback_bloc.dart';

@freezed
abstract class FeedbackState with _$FeedbackState {
  const factory FeedbackState({
    required FeedbackDTO feedback,
    required bool isLoading,
    required bool isSuccess,
    required bool isError,
    required String? errorMessage,
  }) = _FeedbackState;

  factory FeedbackState.initial() => FeedbackState(
    feedback: FeedbackDTO.empty(),
    isLoading: false,
    isSuccess: false,
    isError: false,
    errorMessage: null,
  );
}
