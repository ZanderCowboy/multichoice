enum StorageKeys {
  isDarkMode('_isDarkMode'),
  currentStep('_productTourCurrentStep'),
  isCompleted('_productTourIsCompleted'),
  isLayoutVertical('_isLayoutVertical');

  const StorageKeys(this.key);

  final String key;
}
