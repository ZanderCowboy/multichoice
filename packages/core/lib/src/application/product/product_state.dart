part of 'product_bloc.dart';

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    required ProductTourStep currentStep,
    required bool isLoading,
    required String? errorMessage,
  }) = _ProductState;

  factory ProductState.initial() => ProductState(
        currentStep: ProductTourStep.noneCompleted,
        isLoading: false,
        errorMessage: null,
      );
}
