enum FirebaseConfigKeys {
  // Feature flags (bools)
  // example: enableNewFeature('enable_new_feature'),

  // JSON configs
  // example: appConfig('app_config'),

  // Strings
  welcomeMessage('welcome_message')
  ;

  const FirebaseConfigKeys(this.key);

  final String key;
}
