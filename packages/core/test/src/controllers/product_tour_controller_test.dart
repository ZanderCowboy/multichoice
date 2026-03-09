import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';
import 'package:core/src/controllers/implementations/product_tour_controller.dart';

import '../../mocks.mocks.dart';

void main() {
  const stableStepOffset = 1000;
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

      test(
        'should return welcomePopup when current step is negative',
        () async {
          when(
            mockAppStorageService.isCompleted,
          ).thenAnswer((_) async => false);
          when(mockAppStorageService.currentStep).thenAnswer((_) async => -1);

          final result = await controller.currentStep;

          expect(result, equals(ProductTourStep.welcomePopup));
        },
      );

      test('should return correct step based on stored stable value', () async {
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);
        when(mockAppStorageService.currentStep).thenAnswer(
          (_) async => stableStepOffset + ProductTourStep.showCollection.value,
        );

        final result = await controller.currentStep;

        expect(result, equals(ProductTourStep.showCollection));
      });

      test(
        'should migrate legacy stored index when step was shifted by new insertion',
        () async {
          when(
            mockAppStorageService.isCompleted,
          ).thenAnswer((_) async => false);
          // Legacy index for showSettings before showEditAndSearch was inserted.
          when(mockAppStorageService.currentStep).thenAnswer((_) async => 8);

          final result = await controller.currentStep;

          expect(result, equals(ProductTourStep.showSettings));
          verify(
            mockAppStorageService.setCurrentStep(
              stableStepOffset + ProductTourStep.showSettings.value,
            ),
          ).called(1);
        },
      );

      test('should encode non-shifted legacy index on read', () async {
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);
        when(mockAppStorageService.currentStep).thenAnswer((_) async => 3);

        final result = await controller.currentStep;

        expect(result, equals(ProductTourStep.addNewCollection));
        verify(
          mockAppStorageService.setCurrentStep(
            stableStepOffset + ProductTourStep.addNewCollection.value,
          ),
        ).called(1);
      });
    });

    group('nextStep', () {
      test('should move to next step when not at last step', () async {
        when(mockAppStorageService.currentStep).thenAnswer(
          (_) async => stableStepOffset,
        );
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);

        await controller.nextStep();

        verify(
          mockAppStorageService.setCurrentStep(stableStepOffset + 1),
        ).called(1);
      });

      test('should move to thanks popup when at close settings', () async {
        when(
          mockAppStorageService.currentStep,
        ).thenAnswer((_) async => stableStepOffset + 13);
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);

        await controller.nextStep();

        verify(
          mockAppStorageService.setCurrentStep(stableStepOffset + 14),
        ).called(1);
      });

      test('should complete tour when at thanks popup', () async {
        when(
          mockAppStorageService.currentStep,
        ).thenAnswer((_) async => stableStepOffset + 14);
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);

        await controller.nextStep();

        verify(mockAppStorageService.setIsCompleted(true)).called(1);
      });
    });

    group('previousStep', () {
      test('should move to previous step when not at first step', () async {
        when(mockAppStorageService.currentStep).thenAnswer(
          (_) async => stableStepOffset + 1,
        );
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);

        await controller.previousStep();

        verify(
          mockAppStorageService.setCurrentStep(stableStepOffset),
        ).called(1);
      });

      test('should throw exception when at first step', () async {
        when(
          mockAppStorageService.currentStep,
        ).thenAnswer((_) async => stableStepOffset);
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
