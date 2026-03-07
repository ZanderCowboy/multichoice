import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.g.dart';

@Injectable()
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final IFeedbackRepository repository;

  FeedbackBloc(this.repository) : super(FeedbackState.initial()) {
    on<FeedbackEvent>((event, emit) async {
      switch (event) {
        case SubmitFeedback(:final feedback):
          emit(
            state.copyWith(
              feedback: feedback,
              isLoading: true,
              isSuccess: false,
              isError: false,
              errorMessage: null,
            ),
          );

          final result = await repository.submitFeedback(feedback);

          result.fold(
            (error) => emit(
              state.copyWith(
                feedback: feedback,
                isLoading: false,
                isSuccess: false,
                isError: true,
                errorMessage: error.message,
              ),
            ),
            (_) => emit(
              state.copyWith(
                feedback: feedback,
                isLoading: false,
                isSuccess: true,
                isError: false,
                errorMessage: null,
              ),
            ),
          );
        case ResetFeedback():
          emit(FeedbackState.initial());
        case FeedbackFieldChanged(:final field, :final value):
          if (value != null) {
            final updatedFeedback = _updateFeedbackField(field, value);

            emit(
              state.copyWith(
                feedback: updatedFeedback,
                isLoading: false,
                isSuccess: false,
                isError: false,
                errorMessage: null,
              ),
            );
          }
      }
    });
  }

  FeedbackDTO _updateFeedbackField(FeedbackField field, Object? value) {
    return state.feedback.copyWith(
      category: field == FeedbackField.category
          ? value as String?
          : state.feedback.category,
      userEmail: field == FeedbackField.email
          ? value as String?
          : state.feedback.userEmail,
      message: field == FeedbackField.message
          ? value as String
          : state.feedback.message,
      rating: field == FeedbackField.rating
          ? value as int
          : state.feedback.rating,
    );
  }
}
