
part of 'tour_bloc.dart';

@freezed
class TourState with _$TourState {
  const factory TourState({
    @Default(false) bool isLoading,
    @Default(false) bool isSkipped,
    int? currentStep,
    int? lastStep,
    @Default(false) bool isTourComplete,
    String? errorMessage,
  }) = _TourState;

  factory TourState.initial() => const TourState();
} 