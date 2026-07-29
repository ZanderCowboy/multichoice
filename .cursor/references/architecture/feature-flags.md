# Feature Flags (Firebase Remote Config)

## Pattern

1. Add key to [`FirebaseConfigKeys`](../../../packages/models/lib/src/enums/firebase/firebase_config_keys.dart).
2. Read via `coreSl<IFirebaseService>().isEnabled(FirebaseConfigKeys.xxx)` for booleans.
3. Hide UI entry points **and** guard routes when flag is off.

## Current Keys (bools)

| Enum | RC key | Usage |
|------|--------|-------|
| `usePillStyleBanner` | `use_pill_style_banner` | Home banner style |
| `enableChangelogPage` | `enable_changelog_page` | Changelog drawer link + route |
| `feedbackImagesEnabled` | `feedback_images_enabled` | Feedback **Add Images** + **Paste Screenshot** buttons; uploads gated by same flag |
| `enableUserAccounts` | `enable_user_accounts` | Auth, profile, related routes |
| `enableTutorial` | `enable_tutorial` | Guided product-tour journey, welcome Follow Tutorial, drawer Restart |
| `enableUpdatePrompt` | `enable_update_prompt` | Home update-available prompt |
| `enableAboutPage` | `enable_about_page` | Full About page with RC links (drawer falls back to dialog when off) |

## JSON / Strings

- `changelog` — JSON for changelog content
- `welcome_message`, `google_play_store_url`, `latest_app_version`
- About URLs: `about_instagram_url`, `about_website_url`, `about_contact_email`, etc.

## App Helpers

- [`user_accounts_feature.dart`](../../../apps/multichoice/lib/utils/user_accounts_feature.dart) — central guard for user-account surfaces.

## Debug overrides (DEV only)

`AppFlavor.allowsDebugPage` gates `DebugPageRoute`. Feature Flags tab uses `RemoteConfigDebugNotifier` + `IFirebaseService`:

- `setDebugOverride(key, value | null)` — per-flag override
- `hasDebugOverride(key)` — whether local override is active
- `clearAllDebugOverrides()` — reset all
- `getRemoteBool(key)` — Firebase value without override

Overrides affect `isEnabled()` for bool flags. Refetch action calls `notifyRemoteConfigRefreshed()` after fetch.

## Rollout

- Ship with safe defaults (usually `false` for new flags).
- Enable in Firebase console after QA.

See [`docs/setting-up-dev-prod-environments.md`](../../../docs/setting-up-dev-prod-environments.md).
