enum StorageKeys {
  isDarkMode('_isDarkMode'),
  currentStep('_productTourCurrentStep'),
  isCompleted('_productTourIsCompleted'),
  isLayoutVertical('_isLayoutVertical'),
  isExistingUser('_isExistingUser'),
  hasPreviouslySignedIn('_hasPreviouslySignedIn'),
  isPermissionsChecked('_isPermissionsChecked'),
  analyticsUserId('_analyticsUserId'),
  isImportDataBannerDismissed('_isImportDataBannerDismissed'),
  isSignupBannerDismissed('_isSignupBannerDismissed'),
  lastUsedEmail('_lastUsedEmail'),
  feedbackSubmissionDay('_feedbackSubmissionDay'),
  feedbackSubmissionCount('_feedbackSubmissionCount'),
  ;

  const StorageKeys(this.key);

  final String key;
}
