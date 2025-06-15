part of 'product_bloc.dart';

@freezed
abstract class ProductState with _$ProductState {
  const factory ProductState({
    required ProductTourStep currentStep,
    required List<TabsDTO>? tabs,
    required bool isLoading,
    required String? errorMessage,
  }) = _ProductState;

  factory ProductState.initial() => const ProductState(
        currentStep: ProductTourStep.noneCompleted,
        tabs: null,
        isLoading: false,
        errorMessage: null,
      );
}
