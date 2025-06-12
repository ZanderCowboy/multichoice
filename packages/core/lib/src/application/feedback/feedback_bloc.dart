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
          emit(state.copyWith(
            isLoading: true,
            isSuccess: false,
            isError: false,
            errorMessage: null,
          ));

          try {
            await repository.submitFeedback(e.feedback);
            emit(state.copyWith(
              isLoading: false,
              isSuccess: true,
              isError: false,
              errorMessage: null,
            ));
          } catch (err) {
            emit(state.copyWith(
              isLoading: false,
              isSuccess: false,
              isError: true,
              errorMessage: err.toString(),
            ));
          }
        },
        reset: (e) async {
          emit(FeedbackState.initial());
        },
        fieldChanged: (e) async {
          if (e.value != null) {
            final updatedFeedback = state.feedback.copyWith(
              category: e.field == FeedbackField.category
                  ? e.value as String?
                  : state.feedback.category,
              userEmail: e.field == FeedbackField.email
                  ? e.value as String?
                  : state.feedback.userEmail,
              message: e.field == FeedbackField.message
                  ? e.value as String
                  : state.feedback.message,
              rating: e.field == FeedbackField.rating
                  ? e.value as int
                  : state.feedback.rating,
            );

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
}

enum FeedbackField {
  category,
  email,
  message,
  rating,
}
