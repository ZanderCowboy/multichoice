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
    final isDarkMode = _sharedPreferences.getBool(StorageKeys.isDarkMode.key);
    return isDarkMode ?? false;
  }

  @override
  Future<void> setIsDarkMode(bool isDarkMode) async {
    await _sharedPreferences.setBool(
      StorageKeys.isDarkMode.key,
      isDarkMode,
    );
  }

  @override
  Future<int> get currentStep async {
    final currentStep =
        _sharedPreferences.getInt(StorageKeys.currentStep.key) ?? -1;
    return currentStep;
  }

  @override
  Future<void> setCurrentStep(int step) async {
    await _sharedPreferences.setInt(
      StorageKeys.currentStep.key,
      step,
    );
  }

  @override
  Future<bool> get isCompleted async {
    final isCompleted = _sharedPreferences.getBool(StorageKeys.isCompleted.key);
    return isCompleted ?? false;
  }

  @override
  Future<void> setIsCompleted(bool isCompleted) async {
    await _sharedPreferences.setBool(
      StorageKeys.isCompleted.key,
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
    final isVertical = _sharedPreferences.getBool(
      StorageKeys.isLayoutVertical.key,
    );
    return isVertical ?? false;
  }

  @override
  Future<void> setIsLayoutVertical(bool isVertical) async {
    await _sharedPreferences.setBool(
      StorageKeys.isLayoutVertical.key,
      isVertical,
    );
  }

  @override
  Future<bool> get isExistingUser async {
    final isExisting = _sharedPreferences.getBool(
      StorageKeys.isExistingUser.key,
    );
    return isExisting ?? false;
  }

  @override
  Future<void> setIsExistingUser(bool isExisting) async {
    await _sharedPreferences.setBool(
      StorageKeys.isExistingUser.key,
      isExisting,
    );
  }

  @override
  Future<bool> get hasPreviouslySignedIn async {
    final hasSignedIn = _sharedPreferences.getBool(
      StorageKeys.hasPreviouslySignedIn.key,
    );
    return hasSignedIn ?? false;
  }

  @override
  Future<void> setHasPreviouslySignedIn(bool hasSignedIn) async {
    await _sharedPreferences.setBool(
      StorageKeys.hasPreviouslySignedIn.key,
      hasSignedIn,
    );
  }

  @override
  Future<bool> get isPermissionsChecked async {
    final isChecked = _sharedPreferences.getBool(
      StorageKeys.isPermissionsChecked.key,
    );
    return isChecked ?? false;
  }

  @override
  Future<void> setIsPermissionsChecked(bool isChecked) async {
    await _sharedPreferences.setBool(
      StorageKeys.isPermissionsChecked.key,
      isChecked,
    );
  }

  @override
  Future<bool> get isImportDataBannerDismissed async {
    final isDismissed = _sharedPreferences.getBool(
      StorageKeys.isImportDataBannerDismissed.key,
    );
    return isDismissed ?? false;
  }

  @override
  Future<void> setIsImportDataBannerDismissed(bool isDismissed) async {
    await _sharedPreferences.setBool(
      StorageKeys.isImportDataBannerDismissed.key,
      isDismissed,
    );
  }

  @override
  Future<bool> get isSignupBannerDismissed async {
    final isDismissed = _sharedPreferences.getBool(
      StorageKeys.isSignupBannerDismissed.key,
    );
    return isDismissed ?? false;
  }

  @override
  Future<void> setIsSignupBannerDismissed(bool isDismissed) async {
    await _sharedPreferences.setBool(
      StorageKeys.isSignupBannerDismissed.key,
      isDismissed,
    );
  }

  @override
  Future<String?> get lastUsedEmail async {
    return _sharedPreferences.getString(StorageKeys.lastUsedEmail.key);
  }

  @override
  Future<void> setLastUsedEmail(String email) async {
    await _sharedPreferences.setString(
      StorageKeys.lastUsedEmail.key,
      email,
    );
  }

  @override
  Future<void> clearLastUsedEmail() async {
    await _sharedPreferences.remove(StorageKeys.lastUsedEmail.key);
  }

  @override
  Future<void> clearAllData() async {
    if (!kDebugMode) return;

    await resetTour();
    await setIsDarkMode(false);
    await setIsLayoutVertical(false);
    await setIsExistingUser(false);
    await setHasPreviouslySignedIn(false);
    await setIsPermissionsChecked(false);
    await setIsImportDataBannerDismissed(false);
    await setIsSignupBannerDismissed(false);
    await clearLastUsedEmail();
  }
}
