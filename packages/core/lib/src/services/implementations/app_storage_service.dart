import 'package:core/core.dart';
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
    final isVertical = _sharedPreferences.getBool(StorageKeys.isLayoutVertical.name);
    return isVertical ?? false;
  }

  @override
  Future<void> setIsLayoutVertical(bool isVertical) async {
    await _sharedPreferences.setBool(
      StorageKeys.isLayoutVertical.name,
      isVertical,
    );
  }
}
