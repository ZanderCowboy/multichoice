import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

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
    final currentStep = await _appStorageService.currentStep;
    final isCompleted = await _appStorageService.isCompleted;

    if (isCompleted) {
      return ProductTourStep.noneCompleted;
    }

    if (currentStep < 0) {
      return ProductTourStep.welcomePopup;
    }

    return ProductTourStep.values[currentStep];
  }

  @override
  Future<void> nextStep() async {
    final current = await currentStep;
    final nextStepIndex = current.index + 1;

    if (nextStepIndex < ProductTourStep.values.length - 2) {
      await _appStorageService.setCurrentStep(nextStepIndex);
    } else {
      if (nextStepIndex == ProductTourStep.values.length - 2) {
        await completeTour();
      } else {
        throw Exception('No more steps available in the product tour.');
      }
    }
  }

  @override
  Future<void> previousStep({BuildContext? context}) async {
    final current = await currentStep;
    final previousStepIndex = current.index - 1;

    if (previousStepIndex >= 0) {
      await _appStorageService.setCurrentStep(previousStepIndex);
    } else {
      throw Exception('No previous step available in the product tour.');
    }
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
