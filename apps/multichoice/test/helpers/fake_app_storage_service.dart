import 'package:core/core.dart';

class FakeAppStorageService implements IAppStorageService {
  @override
  Future<bool> get isDarkMode async => false;

  @override
  Future<void> setIsDarkMode(bool isDarkMode) async {}

  @override
  Future<int> get currentStep async => 0;

  @override
  Future<void> setCurrentStep(int step) async {}

  @override
  Future<bool> get isCompleted async => false;

  @override
  Future<void> setIsCompleted(bool isCompleted) async {}

  @override
  Future<void> resetTour() async {}

  @override
  Future<bool> get isLayoutVertical async => false;

  @override
  Future<void> setIsLayoutVertical(bool isVertical) async {}

  @override
  Future<bool> get isExistingUser async => false;

  @override
  Future<void> setIsExistingUser(bool isExisting) async {}

  @override
  Future<bool> get hasPreviouslySignedIn async => false;

  @override
  Future<void> setHasPreviouslySignedIn(bool hasSignedIn) async {}

  @override
  Future<bool> get isPermissionsChecked async => false;

  @override
  Future<void> setIsPermissionsChecked(bool isChecked) async {}

  @override
  Future<bool> get isImportDataBannerDismissed async => true;

  @override
  Future<void> setIsImportDataBannerDismissed(bool isDismissed) async {}

  @override
  Future<bool> get isSignupBannerDismissed async => true;

  @override
  Future<void> setIsSignupBannerDismissed(bool isDismissed) async {}

  @override
  Future<String?> get lastUsedEmail async => null;

  @override
  Future<void> setLastUsedEmail(String email) async {}

  @override
  Future<void> clearLastUsedEmail() async {}

  @override
  Future<bool> canSubmitMoreFeedbackToday() async => true;

  @override
  Future<void> recordFeedbackSubmissionForToday() async {}

  @override
  Future<void> clearAllData() async {}
}
