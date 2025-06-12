part of 'feedback_bloc.dart';

@freezed
class FeedbackEvent with _$FeedbackEvent {
  const factory FeedbackEvent.submit(FeedbackDTO feedback) = SubmitFeedback;
  const factory FeedbackEvent.reset() = ResetFeedback;
  const factory FeedbackEvent.fieldChanged({
    required FeedbackField field,
    required dynamic value,
  }) = FeedbackFieldChanged;
}
