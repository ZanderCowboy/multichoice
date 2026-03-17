part of 'product_bloc.dart';

sealed class ProductEvent {
  const ProductEvent();

  const factory ProductEvent.init() = OnInit;
  const factory ProductEvent.nextStep() = OnNextStep;
  const factory ProductEvent.previousStep() = OnPreviousStep;
  const factory ProductEvent.skipTour() = OnSkipTour;
  const factory ProductEvent.resetTour() = OnResetTour;
  const factory ProductEvent.onLoadData() = OnLoadData;
  const factory ProductEvent.onClearData() = OnClearData;
}

final class OnInit extends ProductEvent {
  const OnInit();
}

final class OnNextStep extends ProductEvent {
  const OnNextStep();
}

final class OnPreviousStep extends ProductEvent {
  const OnPreviousStep();
}

final class OnSkipTour extends ProductEvent {
  const OnSkipTour();
}

final class OnResetTour extends ProductEvent {
  const OnResetTour();
}

final class OnLoadData extends ProductEvent {
  const OnLoadData();
}

final class OnClearData extends ProductEvent {
  const OnClearData();
}
