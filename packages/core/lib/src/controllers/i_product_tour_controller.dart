import 'package:models/models.dart';

abstract class IProductTourController {
  Future<void> init();
  Future<ProductTourStep> get currentStep;
  Future<void> nextStep();
  Future<void> previousStep();
  Future<void> completeTour();
  Future<void> resetTour();
}
