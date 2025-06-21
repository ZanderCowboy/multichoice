part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.init() = OnInit;
  const factory ProductEvent.nextStep() = OnNextStep;
  const factory ProductEvent.previousStep() = OnPreviousStep;
  const factory ProductEvent.skipTour() = OnSkipTour;
  const factory ProductEvent.resetTour() = OnResetTour;
  const factory ProductEvent.onLoadData() = OnLoadData;
  const factory ProductEvent.onClearData() = OnClearData;
}
