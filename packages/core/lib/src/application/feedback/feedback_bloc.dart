import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';
import 'package:file_picker/file_picker.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.g.dart';

@Injectable()
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final IFeedbackRepository _feedbackRepository;
  final IAnalyticsService _analyticsService;
  final IAppStorageService _appStorageService;

  FeedbackBloc(
    this._feedbackRepository,
    this._analyticsService,
    this._appStorageService,
  ) : super(FeedbackState.initial()) {
    on<FeedbackEvent>((event, emit) async {
      switch (event) {
        case SubmitFeedback(:final feedback):
          if (feedback.rating < 1) {
            emit(
              state.copyWith(
                feedback: feedback,
                isLoading: false,
                isSuccess: false,
                isError: true,
                errorMessage: 'Please choose a rating from 1 to 5 stars.',
              ),
            );
            return;
          }
          if (!await _appStorageService.canSubmitMoreFeedbackToday()) {
            emit(
              state.copyWith(
                feedback: feedback,
                isLoading: false,
                isSuccess: false,
                isError: true,
                errorMessage:
                    'You can submit up to 5 feedback reports per day. Try again tomorrow.',
              ),
            );
            return;
          }
          emit(
            state.copyWith(
              feedback: feedback,
              isLoading: true,
              isSuccess: false,
              isError: false,
              errorMessage: null,
            ),
          );
          await _analyticsService.logEvent(
            FeedbackEventData(
              page: AnalyticsPage.feedback,
              action: AnalyticsAction.submit,
              category: feedback.category,
              rating: feedback.rating,
            ),
          );

          final result = await _feedbackRepository.submitFeedback(
            feedback,
            imageFiles: state.imageFiles,
          );

          await result.fold(
            (error) async {
              await _analyticsService.logEvent(
                FeedbackEventData(
                  page: AnalyticsPage.feedback,
                  action: AnalyticsAction.failure,
                  category: feedback.category,
                  rating: feedback.rating,
                  errorMessage: error.message,
                ),
              );

              emit(
                state.copyWith(
                  feedback: feedback,
                  isLoading: false,
                  isSuccess: false,
                  isError: true,
                  errorMessage: error.message,
                ),
              );
            },
            (_) async {
              await _analyticsService.logEvent(
                FeedbackEventData(
                  page: AnalyticsPage.feedback,
                  action: AnalyticsAction.success,
                  category: feedback.category,
                  rating: feedback.rating,
                ),
              );

              await _appStorageService.recordFeedbackSubmissionForToday();

              emit(
                state.copyWith(
                  feedback: feedback,
                  isLoading: false,
                  isSuccess: true,
                  isError: false,
                  errorMessage: null,
                ),
              );
            },
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
        case FeedbackImageAdded(:final file):
          emit(
            state.copyWith(
              imageFiles: [...state.imageFiles, file],
              isLoading: false,
              isSuccess: false,
              isError: false,
              errorMessage: null,
            ),
          );
        case FeedbackImageRemoved(:final index):
          final updatedFiles = List<PlatformFile>.from(state.imageFiles)
            ..removeAt(index);
          emit(
            state.copyWith(
              imageFiles: updatedFiles,
              isLoading: false,
              isSuccess: false,
              isError: false,
              errorMessage: null,
            ),
          );
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
