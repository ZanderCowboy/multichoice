import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: IAppStorageService)
class AppStorageService implements IAppStorageService {
  final _sharedPreferences = coreSl<SharedPreferences>();

  @override
  Future<bool> get isDarkMode async {
    final isDarkMode = _sharedPreferences.getBool(StorageKeys.isDarkMode.name);
    return isDarkMode ?? false;
  }

  @override
  Future<void> setIsDarkMode(bool isDarkMode) async {
    await _sharedPreferences.setBool(
      StorageKeys.isDarkMode.name,
      isDarkMode,
    );
  }

  @override
  Future<int> get currentStep async {
    final currentStep =
        _sharedPreferences.getInt(StorageKeys.currentStep.name) ?? -1;
    return currentStep;
  }

  @override
  Future<void> setCurrentStep(int step) async {
    await _sharedPreferences.setInt(
      StorageKeys.currentStep.name,
      step,
    );
  }

  @override
  Future<bool> get isCompleted async {
    final isCompleted =
        _sharedPreferences.getBool(StorageKeys.isCompleted.name);
    return isCompleted ?? false;
  }

  @override
  Future<void> setIsCompleted(bool isCompleted) async {
    await _sharedPreferences.setBool(
      StorageKeys.isCompleted.name,
      isCompleted,
    );
  }

  @override
  Future<void> resetTour() async {
    await setCurrentStep(-1);
    await setIsCompleted(false);
  }

  @override
  Future<bool> get isLayoutVertical async {
    final isVertical =
        _sharedPreferences.getBool(StorageKeys.isLayoutVertical.name);
    return isVertical ?? false;
  }

  @override
  Future<void> setIsLayoutVertical(bool isVertical) async {
    await _sharedPreferences.setBool(
      StorageKeys.isLayoutVertical.name,
      isVertical,
    );
  }

  @override
  Future<bool> get isExistingUser async {
    final isExisting =
        _sharedPreferences.getBool(StorageKeys.isExistingUser.name);
    return isExisting ?? false;
  }

  @override
  Future<void> setIsExistingUser(bool isExisting) async {
    await _sharedPreferences.setBool(
      StorageKeys.isExistingUser.name,
      isExisting,
    );
  }

  @override
  Future<bool> get isPermissionsChecked async {
    final isChecked =
        _sharedPreferences.getBool(StorageKeys.isPermissionsChecked.name);
    return isChecked ?? false;
  }

  @override
  Future<void> setIsPermissionsChecked(bool isChecked) async {
    await _sharedPreferences.setBool(
      StorageKeys.isPermissionsChecked.name,
      isChecked,
    );
  }

  @override
  Future<void> clearAllData() async {
    if (!kDebugMode) return;

    await resetTour();
    await setIsDarkMode(false);
    await setIsLayoutVertical(false);
    await setIsExistingUser(false);
    await setIsPermissionsChecked(false);
  }
}
