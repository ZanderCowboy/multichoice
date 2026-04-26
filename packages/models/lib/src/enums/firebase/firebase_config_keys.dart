enum FirebaseConfigKeys {
  /// Feature flags (bools)
  /// example: enableNewFeature('enable_new_feature'),
  usePillStyleBanner('use_pill_style_banner'),
  enableChangelogPage('enable_changelog_page'),

  /// JSON configs
  // example: appConfig('app_config'),
  changelog('changelog'),

  /// Strings
  welcomeMessage('welcome_message'),
  googlePlayStoreUrl('google_play_store_url'),
  latestAppVersion('latest_app_version');

  const FirebaseConfigKeys(this.key);

  final String key;
}
