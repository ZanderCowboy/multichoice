enum StorageKeys {
  currentStep('_productTourCurrentStep'),
  isCompleted('_productTourIsCompleted');

  const StorageKeys(this.key);

  final String key;
}
