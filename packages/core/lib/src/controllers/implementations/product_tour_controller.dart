import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

import 'utils/product_tour_step_storage_codec.dart';

@Singleton(as: IProductTourController)
class ProductTourController implements IProductTourController {
  ProductTourController(
    this._appStorageService,
  );

  final IAppStorageService _appStorageService;

  @override
  Future<void> init() async {}

  @override
  Future<ProductTourStep> get currentStep async {
    final storedStep = await _appStorageService.currentStep;
    final isCompleted = await _appStorageService.isCompleted;

    if (isCompleted) {
      return ProductTourStep.noneCompleted;
    }

    if (storedStep < 0) {
      return ProductTourStep.welcomePopup;
    }

    final normalizedStepValue =
        ProductTourStepStorageCodec.normalizeStoredStepToStableValue(
          storedStep,
        );

    if (normalizedStepValue == null) {
      return ProductTourStep.welcomePopup;
    }

    final normalizedStoredStep =
        ProductTourStepStorageCodec.encodeStableStepValue(normalizedStepValue);

    if (storedStep != normalizedStoredStep) {
      await _appStorageService.setCurrentStep(normalizedStoredStep);
    }

    return ProductTourStep.fromValue(normalizedStepValue) ??
        ProductTourStep.welcomePopup;
  }

  @override
  Future<void> nextStep() async {
    final current = await currentStep;
    final nextStep = ProductTourStep.fromValue(current.value + 1);

    if (nextStep != null && nextStep.value >= 0) {
      await _appStorageService.setCurrentStep(
        ProductTourStepStorageCodec.encodeStableStepValue(nextStep.value),
      );
      return;
    }

    if (current == ProductTourStep.thanksPopup) {
      await completeTour();
      return;
    }

    throw Exception('No more steps available in the product tour.');
  }

  @override
  Future<void> previousStep({BuildContext? context}) async {
    final current = await currentStep;
    final previousStep = ProductTourStep.fromValue(current.value - 1);

    if (previousStep != null && previousStep.value >= 0) {
      await _appStorageService.setCurrentStep(
        ProductTourStepStorageCodec.encodeStableStepValue(previousStep.value),
      );
      return;
    }

    throw Exception('No previous step available in the product tour.');
  }

  @override
  Future<void> completeTour() async {
    await _appStorageService.setIsCompleted(true);
  }

  @override
  Future<void> resetTour() async {
    await _appStorageService.resetTour();
  }
}
