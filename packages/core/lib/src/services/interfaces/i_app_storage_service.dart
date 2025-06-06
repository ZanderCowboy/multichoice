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
}
