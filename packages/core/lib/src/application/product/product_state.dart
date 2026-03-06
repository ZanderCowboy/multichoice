part of 'product_bloc.dart';

@CopyWith()
class ProductState extends Equatable {
  const ProductState({
    required this.currentStep,
    required this.tabs,
    required this.isLoading,
    required this.errorMessage,
  });

  factory ProductState.initial() => const ProductState(
    currentStep: ProductTourStep.noneCompleted,
    tabs: null,
    isLoading: false,
    errorMessage: null,
  );

  final ProductTourStep currentStep;
  final List<TabsDTO>? tabs;
  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [currentStep, tabs, isLoading, errorMessage];
}
