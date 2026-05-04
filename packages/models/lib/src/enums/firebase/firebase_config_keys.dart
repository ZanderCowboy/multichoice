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
  latestAppVersion('latest_app_version'),
  aboutInstagramUrl('about_instagram_url'),
  aboutWebsiteUrl('about_website_url'),
  aboutContactEmail('about_contact_email'),
  aboutPrivacyPolicyUrl('about_privacy_policy_url'),
  aboutTermsUrl('about_terms_url'),
  aboutAcknowledgementsUrl('about_acknowledgements_url');

  const FirebaseConfigKeys(this.key);

  final String key;
}
