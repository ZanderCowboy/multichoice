#372 - Implement App Localization

- Added `slang` and `slang_flutter` dependencies to `core` and `multichoice` app packages
- Created base `en.i18n.json` for initial English translations
- Configured code generation via `slang.yaml` and generated translation classes
- Wrapped the app with `TranslationProvider` and initialized `LocaleSettings` in `main.dart`
- Added localization delegates and locale parameters to `MaterialApp` in `multichoice.dart`
- Set up Android 13+ per-app language preferences in `locales_config.xml` and `AndroidManifest.xml`
- Replaced the hardcoded app title with generated slang property
