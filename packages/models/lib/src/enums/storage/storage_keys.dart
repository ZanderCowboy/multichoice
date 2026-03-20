enum StorageKeys {
  isDarkMode('_isDarkMode'),
  currentStep('_productTourCurrentStep'),
  isCompleted('_productTourIsCompleted'),
  isLayoutVertical('_isLayoutVertical'),
  isExistingUser('_isExistingUser'),
  isPermissionsChecked('_isPermissionsChecked'),
  analyticsUserId('_analyticsUserId'),
  isImportDataBannerDismissed('_isImportDataBannerDismissed'),
  lastUsedEmail('_lastUsedEmail')
  ;

  const StorageKeys(this.key);

  final String key;
}
