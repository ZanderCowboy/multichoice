part of 'feedback_bloc.dart';

@CopyWith()
class FeedbackState extends Equatable {
  const FeedbackState({
    required this.feedback,
    required this.isLoading,
    required this.isSuccess,
    required this.isError,
    required this.errorMessage,
    required this.imageFiles,
  });

  factory FeedbackState.initial() => FeedbackState(
    feedback: FeedbackDTO.empty(),
    isLoading: false,
    isSuccess: false,
    isError: false,
    errorMessage: null,
    imageFiles: const [],
  );

  final FeedbackDTO feedback;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String? errorMessage;
  final List<PlatformFile> imageFiles;

  @override
  List<Object?> get props => [
    feedback,
    isLoading,
    isSuccess,
    isError,
    errorMessage,
    imageFiles,
  ];
}
