part of 'product_bloc.dart';

@CopyWith()
class ProductState {
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductState &&
        other.currentStep == currentStep &&
        _listEquals(other.tabs, tabs) &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    currentStep,
    Object.hashAll(tabs ?? const <TabsDTO>[]),
    isLoading,
    errorMessage,
  );
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null || a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
