abstract class IAppStorageService {
  Future<bool> get isDarkMode;
  Future<void> setIsDarkMode(bool isDarkMode);

  Future<int> get currentStep;
  Future<void> setCurrentStep(int step);
  Future<bool> get isCompleted;
  Future<void> setIsCompleted(bool isCompleted);
  Future<void> resetTour();

  Future<bool> get isLayoutVertical;
  Future<void> setIsLayoutVertical(bool isVertical);

  Future<bool> get isExistingUser;
  Future<void> setIsExistingUser(bool isExisting);

  Future<bool> get isPermissionsChecked;
  Future<void> setIsPermissionsChecked(bool isChecked);

  /// Clears all storage data by resetting all values to their defaults.
  /// This method should only be used in debug mode.
  Future<void> clearAllData();
}
