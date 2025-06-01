import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'tour_bloc.freezed.dart';
part 'tour_event.dart';
part 'tour_state.dart';

@Injectable()
class TourBloc extends Bloc<TourEvent, TourState> {
  TourBloc(this._tourService) : super(TourState.initial()) {
    on<TourEvent>((event, emit) async {
      await event.map(
        initialize: (_) async {
          emit(state.copyWith(isLoading: true));

          try {
            final progress = await _tourService.getTourProgress();
            final lastStep = progress['lastStep'] as int?;
            final isSkipped = progress['isSkipped'] as bool;

            emit(state.copyWith(
              isLoading: false,
              lastStep: null,
              isSkipped: isSkipped,
              currentStep: null ?? 0,
            ));
          } catch (e) {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: 'Failed to initialize tour: $e',
                currentStep: 0,
              ),
            );
          }
        },
        nextStep: (_) async {
          final nextStep = (state.currentStep ?? -1) + 1;

          emit(
            state.copyWith(
              currentStep: nextStep,
              lastStep: nextStep,
            ),
          );

          await _tourService.saveTourProgress(nextStep, state.isSkipped);
        },
        previousStep: (_) async {
          if (state.currentStep != null && state.currentStep! > 0) {
            final prevStep = state.currentStep! - 1;
            emit(
              state.copyWith(
                currentStep: prevStep,
                lastStep: prevStep,
              ),
            );

            await _tourService.saveTourProgress(prevStep, state.isSkipped);
          }
        },
        skipTour: (_) async {
          emit(
            state.copyWith(
              isSkipped: true,
              isTourComplete: true,
            ),
          );

          await _tourService.saveTourProgress(null, true);
        },
        completeTour: (_) async {
          emit(
            state.copyWith(
              isTourComplete: true,
            ),
          );

          await _tourService.saveTourProgress(state.currentStep, false);
        },
        resetTour: (_) async {
          await _tourService.resetTourProgress();
          emit(TourState.initial());
        },
      );
    });
  }

  final ITourService _tourService;
}
