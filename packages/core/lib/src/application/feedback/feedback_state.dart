part of 'feedback_bloc.dart';

@CopyWith()
class FeedbackState extends Equatable {
  const FeedbackState({
    required this.feedback,
    required this.isLoading,
    required this.isSuccess,
    required this.isError,
    required this.errorMessage,
  });

  factory FeedbackState.initial() => FeedbackState(
    feedback: FeedbackDTO.empty().copyWith(rating: 1),
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
  List<Object?> get props => [
    feedback,
    isLoading,
    isSuccess,
    isError,
    errorMessage,
  ];
}
