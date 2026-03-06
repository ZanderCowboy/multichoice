part of 'feedback_bloc.dart';

@CopyWith()
class FeedbackState {
  const FeedbackState({
    required this.feedback,
    required this.isLoading,
    required this.isSuccess,
    required this.isError,
    required this.errorMessage,
  });

  factory FeedbackState.initial() => FeedbackState(
    feedback: FeedbackDTO.empty(),
    isLoading: false,
    isSuccess: false,
    isError: false,
    errorMessage: null,
  );

  final FeedbackDTO feedback;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String? errorMessage;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackState &&
        other.feedback == feedback &&
        other.isLoading == isLoading &&
        other.isSuccess == isSuccess &&
        other.isError == isError &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>
      Object.hash(feedback, isLoading, isSuccess, isError, errorMessage);
}
