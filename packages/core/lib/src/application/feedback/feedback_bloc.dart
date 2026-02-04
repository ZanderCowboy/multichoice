import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.freezed.dart';

@Injectable()
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final IFeedbackRepository repository;

  FeedbackBloc(this.repository) : super(FeedbackState.initial()) {
    on<FeedbackEvent>((event, emit) async {
      await event.map(
        submit: (e) async {
          emit(
            state.copyWith(
              feedback: e.feedback,
              isLoading: true,
              isSuccess: false,
              isError: false,
              errorMessage: null,
            ),
          );

          final result = await repository.submitFeedback(e.feedback);

          result.fold(
            (error) => emit(state.copyWith(
              feedback: e.feedback,
              isLoading: false,
              isSuccess: false,
              isError: true,
              errorMessage: error.message,
            )),
            (_) => emit(state.copyWith(
              feedback: e.feedback,
              isLoading: false,
              isSuccess: true,
              isError: false,
              errorMessage: null,
            )),
          );
        },
        reset: (e) async {
          emit(FeedbackState.initial());
        },
        fieldChanged: (e) async {
          if (e.value != null) {
            final updatedFeedback = _updateFeedbackField(e.field, e.value);

            emit(state.copyWith(
              feedback: updatedFeedback,
              isLoading: false,
              isSuccess: false,
              isError: false,
              errorMessage: null,
            ));
          }
        },
      );
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
      rating:
          field == FeedbackField.rating ? value as int : state.feedback.rating,
    );
  }
}
