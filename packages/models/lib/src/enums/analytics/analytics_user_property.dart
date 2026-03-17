enum AnalyticsUserProperty {
  appVersion('app_version'),
  platform('platform'),
  isExistingUser('is_existing_user')
  ;

  const AnalyticsUserProperty(this.key);

  final String key;
}
