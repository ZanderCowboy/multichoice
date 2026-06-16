# Feedback Improvements

## Feedback form

- Enforced client-side image limits (3 images, 5 MB each) in `FeedbackBloc` with localized error messages
- Improved clipboard paste: supports PNG, JPEG, WebP, and GIF; clearer snackbars for unsupported formats, read failures, and empty images
- Fixed form reset after successful submit so category and validation state stay in sync (`KeyedSubtree` + version key)

## Language selection

- Added drawer language tile with System / English / Nederlands options persisted via `IAppStorageService`
- App startup applies saved locale preference through `applySavedAppLocale()`

## Feature flags

- Gated update prompt modal behind Remote Config `enable_update_prompt`
- Gated full About page behind `enable_about_page`; drawer falls back to a simple `showAboutDialog` when disabled
- Documented new flags in debug feature-flags UI and architecture reference

## CI / DevOps

- Fixed version-management action: checkout target branch with GitHub App token when `commit_changes` is true (bypasses branch rulesets)

## Platform

- Registered Android `DataProvider` for super_clipboard image paste on feedback form

## i18n

- Added drawer language strings and feedback clipboard error messages (en/nl)

## Tests

- Added `feedback_form_test.dart` widget tests and expanded `FeedbackBloc` / `AppStorageService` unit tests
