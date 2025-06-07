import 'package:models/models.dart';

abstract class IProductTourController {
  Future<void> init();
  Future<ProductTourStep> get currentStep;
  Future<void> nextStep();
  Future<void> previousStep();
  Future<void> completeTour();

  /// Calls the [IAppStorageService] to reset the tour.
  /// Sets the [currentStep] to [ProductTourStep.reset].
  /// Sets the [isCompleted] to [false].
  Future<void> resetTour();
}
