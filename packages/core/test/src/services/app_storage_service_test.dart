import 'package:core/src/services/implementations/app_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mocks.mocks.dart';

void main() {
  late AppStorageService appStorageService;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    GetIt.I.registerSingleton<SharedPreferences>(mockSharedPreferences);
    appStorageService = AppStorageService();
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('AppStorageService - Dark Mode', () {
    test('should return false when isDarkMode is not set', () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(null);

      final result = await appStorageService.isDarkMode;

      expect(result, false);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should return true when isDarkMode is set to true', () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(true);

      final result = await appStorageService.isDarkMode;

      expect(result, true);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should set isDarkMode to true', () async {
      when(mockSharedPreferences.setBool(any, any))
          .thenAnswer((_) async => true);

      await appStorageService.setIsDarkMode(true);

      verify(mockSharedPreferences.setBool(any, true)).called(1);
    });
  });

  group('AppStorageService - Tour Steps', () {
    test('should return -1 when currentStep is not set', () async {
      when(mockSharedPreferences.getInt(any)).thenReturn(null);

      final result = await appStorageService.currentStep;

      expect(result, -1);
      verify(mockSharedPreferences.getInt(any)).called(1);
    });

    test('should return 1 when currentStep is set to 1', () async {
      when(mockSharedPreferences.getInt(any)).thenReturn(1);

      final result = await appStorageService.currentStep;

      expect(result, 1);
      verify(mockSharedPreferences.getInt(any)).called(1);
    });

    test('should set currentStep to 2', () async {
      when(mockSharedPreferences.setInt(any, any))
          .thenAnswer((_) async => true);

      await appStorageService.setCurrentStep(2);

      verify(mockSharedPreferences.setInt(any, 2)).called(1);
    });
  });

  group('AppStorageService - Tour Completion', () {
    test('should return false when isCompleted is not set', () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(null);

      final result = await appStorageService.isCompleted;

      expect(result, false);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should return true when isCompleted is set to true', () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(true);

      final result = await appStorageService.isCompleted;

      expect(result, true);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should set isCompleted to true', () async {
      when(mockSharedPreferences.setBool(any, any))
          .thenAnswer((_) async => true);

      await appStorageService.setIsCompleted(true);

      verify(mockSharedPreferences.setBool(any, true)).called(1);
    });
  });

  group('AppStorageService - Layout', () {
    test('should return false when isLayoutVertical is not set', () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(null);

      final result = await appStorageService.isLayoutVertical;

      expect(result, false);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should return true when isLayoutVertical is set to true', () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(true);

      final result = await appStorageService.isLayoutVertical;

      expect(result, true);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should set isLayoutVertical to true', () async {
      when(mockSharedPreferences.setBool(any, any))
          .thenAnswer((_) async => true);

      await appStorageService.setIsLayoutVertical(true);

      verify(mockSharedPreferences.setBool(any, true)).called(1);
    });
  });

  group('AppStorageService - User Status', () {
    test('should return false when isExistingUser is not set', () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(null);

      final result = await appStorageService.isExistingUser;

      expect(result, false);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should return true when isExistingUser is set to true', () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(true);

      final result = await appStorageService.isExistingUser;

      expect(result, true);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should set isExistingUser to true', () async {
      when(mockSharedPreferences.setBool(any, any))
          .thenAnswer((_) async => true);

      await appStorageService.setIsExistingUser(true);

      verify(mockSharedPreferences.setBool(any, true)).called(1);
    });
  });

  group('AppStorageService - Permissions', () {
    test('should return false when isPermissionsChecked is not set', () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(null);

      final result = await appStorageService.isPermissionsChecked;

      expect(result, false);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should return true when isPermissionsChecked is set to true',
        () async {
      when(mockSharedPreferences.getBool(any)).thenReturn(true);

      final result = await appStorageService.isPermissionsChecked;

      expect(result, true);
      verify(mockSharedPreferences.getBool(any)).called(1);
    });

    test('should set isPermissionsChecked to true', () async {
      when(mockSharedPreferences.setBool(any, any))
          .thenAnswer((_) async => true);

      await appStorageService.setIsPermissionsChecked(true);

      verify(mockSharedPreferences.setBool(any, true)).called(1);
    });
  });

  group('AppStorageService - Reset Tour', () {
    test('should reset tour steps and completion status', () async {
      when(mockSharedPreferences.setInt(any, any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.setBool(any, any))
          .thenAnswer((_) async => true);

      await appStorageService.resetTour();

      verify(mockSharedPreferences.setInt(any, -1)).called(1);
      verify(mockSharedPreferences.setBool(any, false)).called(1);
    });
  });

  group('AppStorageService - Clear All Data', () {
    test('should clear all data in debug mode', () async {
      when(mockSharedPreferences.setBool(any, any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.setInt(any, any))
          .thenAnswer((_) async => true);

      await appStorageService.clearAllData();

      verify(mockSharedPreferences.setInt(any, -1)).called(1);
      verify(mockSharedPreferences.setBool(any, false)).called(5);
    });
  });
}
