abstract class IAppStorageService {
  Future<int> get currentStep;
  Future<void> setCurrentStep(int step);
  Future<bool> get isCompleted;
  Future<void> setIsCompleted(bool isCompleted);
  Future<void> resetTour();
}
