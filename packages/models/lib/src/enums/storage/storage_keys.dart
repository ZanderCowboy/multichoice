enum StorageKeys {
  isDarkMode('_isDarkMode'),
  currentStep('_productTourCurrentStep'),
  isCompleted('_productTourIsCompleted'),
  isLayoutVertical('_isLayoutVertical'),
  isExistingUser('_isExistingUser'),
  isPermissionsChecked('_isPermissionsChecked'),
  analyticsUserId('_analyticsUserId')
  ;

  const StorageKeys(this.key);

  final String key;
}
