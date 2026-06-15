part of 'product_bloc.dart';

@CopyWith()
class ProductState extends Equatable {
  const ProductState({
    required this.activeTip,
    required this.isLoading,
    required this.errorMessage,
  });

  factory ProductState.initial() => const ProductState(
    activeTip: null,
    isLoading: false,
    errorMessage: null,
  );

  final AppTip? activeTip;
  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [activeTip, isLoading, errorMessage];
}
