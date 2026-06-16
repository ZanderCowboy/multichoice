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

# Auth UX, Deep Links, Tutorial Flag, CI & Tooling

## Auth & registration (#220 / #335)

- Added `SetUsernamePage` and `SetUsernameBloc`; after Google sign-in or sign-up when `needsUsernameSetup` is true, users are routed to choose a username before entering the app
- Profile page shows email and username; password tile labels adapt to provider (`Set Password` vs `Update Password`) and opens `ResetPasswordPage` in change-password mode
- `LoginService` stores profile email/username, username→email mapping, and per-user username-confirmed state in secure storage
- `CredentialValidationService.validateLoginIdentifier` accepts email or username for sign-in
- `RegistrationService.setUsername` updates Firebase `displayName`, persists profile locally, and marks username confirmed
- Password reset emails use `ActionCodeSettings` (`handleCodeInApp: true`, package name) when `AUTH_DOMAIN` dart-define is set

## Password-reset deep links

- `PasswordResetDeepLinkListener` listens for Firebase reset links (`app_links`), parses `oobCode`, and opens `ResetPasswordPage`
- Android manifest intent-filters with `android:autoVerify="true"` for DEV/PROD Firebase Hosting domains
- Firebase Hosting (classic) serves `assetlinks.json`, landing `index.html`, and `404.html` for App Link verification
- `AuthEnvironment` centralizes `AUTH_DOMAIN`, package names, and password-reset continue URL from dart-defines
- `password_reset_link_parser` utility and `ResetPasswordBloc` confirm-reset flow via `oobCode`
- Docs: `docs/password-reset-deep-links.md`, `docs/stackmint-app-auth-domain-checklist.md`; `docs/environment-config.md` updated for DEV/PROD auth domains

## Tutorial feature flag (#314)

- Gated the product-tour journey behind Remote Config `enable_tutorial` (default off)
- Welcome modal still shows for new users; Follow Tutorial and drawer Restart are hidden when disabled
- Mid-tour users with the flag off are silently marked complete

## i18n

- Added profile strings: `setUsername`, `setUsernameDescription`, `usernameSetSuccess`, `setPassword`, `updatePassword` (en/nl)

## Tests

- Added/expanded tests: `SetUsernameBloc`, `ResetPasswordBloc` (deep-link confirm flow), `RegistrationBloc` (username setup, login identifier), `RegistrationService` (setUsername, password reset), `LoginService`, `CredentialValidationService`, `password_reset_link_parser`, `RegistrationRepository`
- Consolidated multichoice test fakes into `user_accounts_test_helper.dart`; removed duplicate local fake helpers

## CI / DevOps

- New `pr_version_labels.yml` workflow validates PR version labels on `develop` and `rc` before merge
- Refactored `check-version-labels` action and added `resolve-version-labels.sh` + `version-labels.json` config
- Staging and production workflows use GitHub `staging` and `production` environments
- Deployment notification action skips GitHub issue creation on `dry_run`
- Documented version-label rules and workflow patterns in `.github/README.md`

## Cursor & repo maintenance

- Updated Cursor agents, rules, references, templates, and commit/changelog commands
- Added architecture plans for auth UX, password-reset deep links, and related work
- `melos.yaml`: ignore generated build artifacts; root `TODO` tracks auth/deep-link follow-ups
- README and pull request template tweaks
