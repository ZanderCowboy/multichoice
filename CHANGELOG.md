# Localization, App Icon, DevOps

- Completed slang string migration (#388, child of #372): localized remaining presentation strings across changelog, drawer, home, search, tutorial, data transfer, delete modal, and tooltips; added `localizeCoreMessage()` to map core validation/auth/feedback errors to en/nl at the presentation boundary; Dutch feedback strings aligned with English; forgot-password errors localized; dismiss tooltip required on `DismissibleBannerBar`
- Migrated the rest of the app UI to slang i18n (en/nl): registration fields and validation, password rules, modals, banners, product tour, and debug copy; removed direct `slang` dependency from `packages/core`
- Updated app launcher icons: refreshed prod/main mipmaps, added dev-flavor launcher assets, reorganized Play Store icons into `play_store/app_icon/dev` and `prod`, and updated Draw.io source files (`app_icon.drawio`, `app_icon_dev.drawio`)
- Debug page: added Feature Flags tab with per-flag Remote Config overrides, refetch action, and clear-all; `RemoteConfigDebugNotifier` and `IFirebaseService` debug-override APIs (`setDebugOverride`, `hasDebugOverride`, `clearAllDebugOverrides`)
- Sign-up: password confirmation field with bloc/state validation; Continue with Google on the sign-up page (reuses `RegistrationGoogleSignInClicked` / `signInWithGoogle`); documented Google Sign-In setup in `docs/environment-config.md`
- Prod drawer shows semver-only version (`vX.Y.Z`) via `getDisplayAppVersion()`; DEV still shows full `X.Y.Z+build`; feedback submissions still include build number (#216)
- Production workflow renamed to `production-workflow`; removed deprecated `release_type` input; optional `release_version` manual override with `X.Y.Z` validation takes precedence over RC suffix removal (#326)
- SonarCloud analysis now runs on pushes to `main` in addition to pull requests; dropped `rc` from PR trigger branches (#350)
- Documented GitHub App setup and protected-branch bypass for CI version commits in `docs/protected-branch-and-github-app.md` (#215)
- Cleared root `TODO` (CI/CD notes absorbed into docs and workflow changes)
