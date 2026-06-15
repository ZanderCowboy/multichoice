import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';
import 'package:core/src/controllers/implementations/app_tips_controller.dart';

import '../../mocks.mocks.dart';

void main() {
  late AppTipsController controller;
  late MockAppStorageService mockAppStorageService;

  setUp(() {
    mockAppStorageService = MockAppStorageService();
    controller = AppTipsController(mockAppStorageService);
  });

  group('AppTipsController', () {
    group('activeTip', () {
      test('returns null when tips are completed', () async {
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => true);

        final result = await controller.activeTip;

        expect(result, isNull);
      });

      test('returns first undismissed tip from stored mask', () async {
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);
        when(
          mockAppStorageService.dismissedAppTipsMask,
        ).thenAnswer((_) async => AppTip.collections.mask);

        final result = await controller.activeTip;

        expect(result, AppTip.addCollection);
      });

      test('migrates legacy tour progress when mask is empty', () async {
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);
        when(mockAppStorageService.dismissedAppTipsMask).thenAnswer((_) async => 0);
        when(mockAppStorageService.currentStep).thenAnswer((_) async => 4);

        final result = await controller.activeTip;

        expect(result, AppTip.entryActions);
        verify(
          mockAppStorageService.setDismissedAppTipsMask(
            AppTip.collections.mask |
                AppTip.addCollection.mask |
                AppTip.addEntry.mask,
          ),
        ).called(1);
      });
    });

    group('dismissTip', () {
      test('marks tip dismissed and completes when last tip is dismissed', () async {
        when(mockAppStorageService.isCompleted).thenAnswer((_) async => false);
        when(mockAppStorageService.dismissedAppTipsMask).thenAnswer(
          (_) async =>
              AppTip.allDismissedMask & ~AppTip.drawer.mask,
        );

        await controller.dismissTip(AppTip.drawer);

        verify(
          mockAppStorageService.setDismissedAppTipsMask(AppTip.allDismissedMask),
        ).called(greaterThanOrEqualTo(1));
        verify(mockAppStorageService.setIsCompleted(true)).called(1);
      });
    });

    group('resetTips', () {
      test('delegates to storage reset', () async {
        await controller.resetTips();

        verify(mockAppStorageService.resetTour()).called(1);
      });
    });
  });
}
