enum FirebaseConfigKeys {
  // Feature flags (bools)
  // example: enableNewFeature('enable_new_feature'),
  usePillStyleBanner('use_pill_style_banner'),

  // JSON configs
  // example: appConfig('app_config'),
  changelog('changelog'),

  // Strings
  welcomeMessage('welcome_message'),
  playStoreUrl('play_store_url')
  ;

  const FirebaseConfigKeys(this.key);

  final String key;
}
