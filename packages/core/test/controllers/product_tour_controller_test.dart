import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';
import 'package:core/src/controllers/implementations/product_tour_controller.dart';

import '../mocks.mocks.dart';

void main() {
  late ProductTourController controller;
  late MockAppStorageService mockAppStorageService;

  setUp(() {
    mockAppStorageService = MockAppStorageService();
    controller = ProductTourController(mockAppStorageService);
  });

  group('ProductTourController', () {
    group('currentStep', () {
      test('should return noneCompleted when tour is completed', () async {
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => true);
        when(mockAppStorageService.currentStep).thenAnswer((_) async => 0);

        final result = await controller.currentStep;

        expect(result, equals(ProductTourStep.noneCompleted));
      });

      test('should return welcomePopup when current step is negative',
          () async {
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);
        when(mockAppStorageService.currentStep).thenAnswer((_) async => -1);

        final result = await controller.currentStep;

        expect(result, equals(ProductTourStep.welcomePopup));
      });

      test('should return correct step based on current step index', () async {
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);
        when(mockAppStorageService.currentStep).thenAnswer((_) async => 1);

        final result = await controller.currentStep;

        expect(result, equals(ProductTourStep.values[1]));
      });
    });

    group('nextStep', () {
      test('should move to next step when not at last step', () async {
        when(mockAppStorageService.currentStep).thenAnswer((_) async => 0);
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);

        await controller.nextStep();

        verify(mockAppStorageService.setCurrentStep(1)).called(1);
      });

      test('should complete tour when at second to last step', () async {
        when(mockAppStorageService.currentStep)
            .thenAnswer((_) async => ProductTourStep.values.length - 3);
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);

        await controller.nextStep();

        verify(mockAppStorageService.setIsCompleted(true)).called(1);
      });

      test('should throw exception when at last step', () async {
        when(mockAppStorageService.currentStep)
            .thenAnswer((_) async => ProductTourStep.values.length - 2);
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);

        expect(() => controller.nextStep(), throwsException);
      });
    });

    group('previousStep', () {
      test('should move to previous step when not at first step', () async {
        when(mockAppStorageService.currentStep).thenAnswer((_) async => 1);
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);

        await controller.previousStep();

        verify(mockAppStorageService.setCurrentStep(0)).called(1);
      });

      test('should throw exception when at first step', () async {
        when(mockAppStorageService.currentStep).thenAnswer((_) async => 0);
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);

        expect(() => controller.previousStep(), throwsException);
      });
    });

    group('completeTour', () {
      test('should set isCompleted to true', () async {
        await controller.completeTour();

        verify(mockAppStorageService.setIsCompleted(true)).called(1);
      });
    });

    group('resetTour', () {
      test('should reset tour state', () async {
        await controller.resetTour();

        verify(mockAppStorageService.resetTour()).called(1);
      });
    });
  });
}
