part of 'product_bloc.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState({
    required int currentStep,
    required bool isLoading,
    required String? errorMessage,
  }) = _ProductState;

  factory ProductState.initial() => ProductState(
        currentStep: 0,
        isLoading: false,
        errorMessage: null,
      );
}
