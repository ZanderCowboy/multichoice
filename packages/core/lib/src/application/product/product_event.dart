part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.onGetCurrentStep() = OnGetCurrentStep;
  const factory ProductEvent.updateCurrentStep() = OnUpdateCurrentStep;
}
