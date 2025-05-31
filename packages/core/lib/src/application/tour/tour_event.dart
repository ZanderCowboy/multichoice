part of 'tour_bloc.dart';

@freezed
class TourEvent with _$TourEvent {
  const factory TourEvent.initialize() = _Initialize;
  const factory TourEvent.nextStep() = _NextStep;
  const factory TourEvent.previousStep() = _PreviousStep;
  const factory TourEvent.skipTour() = _SkipTour;
  const factory TourEvent.completeTour() = _CompleteTour;
  const factory TourEvent.resetTour() = _ResetTour;
} 