part of 'feedback_bloc.dart';

sealed class FeedbackEvent {
  const FeedbackEvent();

  const factory FeedbackEvent.submit(FeedbackDTO feedback) = SubmitFeedback;
  const factory FeedbackEvent.reset() = ResetFeedback;
  const factory FeedbackEvent.fieldChanged({
    required FeedbackField field,
    required Object? value,
  }) = FeedbackFieldChanged;
  const factory FeedbackEvent.imageAdded(PlatformFile file) = FeedbackImageAdded;
  const factory FeedbackEvent.imageRemoved(int index) = FeedbackImageRemoved;
}

final class SubmitFeedback extends FeedbackEvent {
  const SubmitFeedback(this.feedback);

  final FeedbackDTO feedback;
}

final class ResetFeedback extends FeedbackEvent {
  const ResetFeedback();
}

final class FeedbackFieldChanged extends FeedbackEvent {
  const FeedbackFieldChanged({
    required this.field,
    required this.value,
  });

  final FeedbackField field;
  final Object? value;
}

final class FeedbackImageAdded extends FeedbackEvent {
  const FeedbackImageAdded(this.file);

  final PlatformFile file;
}

final class FeedbackImageRemoved extends FeedbackEvent {
  const FeedbackImageRemoved(this.index);

  final int index;
}
