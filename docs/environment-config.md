# Environment configuration (DEV / PROD)

Multichoice uses Android product flavors (`dev` / `prod`) with separate Firebase projects. Runtime secrets are supplied via flat JSON config files and `--dart-define-from-file` — not `lib/auth/secrets.dart`.

## Local files

| File | Purpose |
|------|---------|
| `apps/multichoice/config/develop_config.json` | DEV dart-defines (gitignored) |
| `apps/multichoice/config/production_config.json` | PROD dart-defines (gitignored) |
| `apps/multichoice/android/app/src/dev/google-services.json` | DEV native Firebase config (gitignored) |
| `apps/multichoice/android/app/src/prod/google-services.json` | PROD native Firebase config (gitignored) |

## Config JSON schema

Flat key/value pairs only (strings). Example `develop_config.json`:

```json
{
  "APP_FLAVOR": "dev",
  "WEB_API_KEY": "",
  "WEB_APP_ID": "",
  "ANDROID_API_KEY": "your-dev-android-api-key",
  "ANDROID_APP_ID": "your-dev-mobilesdk-app-id",
  "FIREBASE_PROJECT_ID": "multichoice-app-develop",
  "MESSAGING_SENDER_ID": "663305224058",
  "AUTH_DOMAIN": "multichoice-app-develop.firebaseapp.com",
  "STORAGE_BUCKET": "multichoice-app-develop.firebasestorage.app",
  "REVENUE_CAT_ANDROID_API_KEY": ""
}
```

Production uses `"APP_FLAVOR": "prod"` and `multichoice-412309` project values. Optional: `WEB_MEASUREMENT_ID` for web builds.

`ANDROID_APP_ID` and `ANDROID_API_KEY` must match the corresponding `google-services.json`.

## Entry points

| Flavor | Main file | Config file |
|--------|-----------|-------------|
| DEV | `lib/main_develop.dart` | `config/develop_config.json` |
| PROD | `lib/main_production.dart` | `config/production_config.json` |

## Run locally

```bash
cd apps/multichoice

# DEV
flutter run --target lib/main_develop.dart --flavor dev \
  --dart-define-from-file=config/develop_config.json

# PROD
flutter run --target lib/main_production.dart --flavor prod \
  --dart-define-from-file=config/production_config.json
```

Use the VS Code launch configs under **Run and Debug** (six DEV/PROD × debug/profile/release options).

## Emulator behavior (DEV + PROD side by side)

Android treats each flavor as a **separate app** because DEV uses `applicationIdSuffix ".dev"`:

| Flavor | Package ID | Launcher name |
|--------|------------|---------------|
| DEV | `co.za.zanderkotze.multichoice.dev` | `[DEV] Multichoice` |
| PROD | `co.za.zanderkotze.multichoice` | `Multichoice` |

Expected behavior (same as a typical multi-flavor work setup):

- **Same flavor → same flavor** (e.g. Debug DEV twice): in-place update via `adb install -r`; local data kept.
- **Different flavor → different flavor** (e.g. Debug DEV then Debug PROD): only the target flavor is updated; the other stays installed with its own data.
- **No uninstall** unless install fails or the emulator is out of storage.

Signing matches a standard Flutter project: only `release` uses `signingConfigs.release`; debug/profile use the default debug keystore for all flavors.

Verify both apps are installed:

```powershell
adb shell pm list packages | findstr multichoice
```

You should see both `co.za.zanderkotze.multichoice.dev` and `co.za.zanderkotze.multichoice`.

### `INSTALL_FAILED_UPDATE_INCOMPATIBLE` / "Uninstalling old version..."

This is **not** normal flavor switching. Flutter prints `Uninstalling old version...` only when `adb install` fails, then retries after uninstalling **that package ID** (which wipes that flavor's local data).

Cause: the target package was previously installed with a **different signing key** — e.g. Play Store / internal testing build, a one-off **Release [PROD]** run, or CI APK — while you are now installing a **debug** build of the same package ID.

Fix (one-time per emulator, for the affected package only):

```powershell
adb uninstall co.za.zanderkotze.multichoice
# or, if DEV is affected:
adb uninstall co.za.zanderkotze.multichoice.dev
```

Then run the debug flavor again. After that, debug-to-debug and cross-flavor switches should update in place without uninstall.

Avoid mixing **Release [PROD]** and **Debug [PROD]** on the same emulator unless you uninstall prod first.

## GitHub secrets

Create four base64 secrets (one file each):

| Secret | Source file |
|--------|-------------|
| `DEV_CONFIG_B64` | `config/develop_config.json` |
| `PROD_CONFIG_B64` | `config/production_config.json` |
| `DEV_GOOGLE_SERVICES_B64` | `android/app/src/dev/google-services.json` |
| `PROD_GOOGLE_SERVICES_B64` | `android/app/src/prod/google-services.json` |

**Linux / CI:**

```bash
base64 -w0 apps/multichoice/config/develop_config.json
base64 -w0 apps/multichoice/android/app/src/dev/google-services.json
```

**PowerShell:**

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("apps/multichoice/config/develop_config.json"))
```

### Other secrets (unchanged)

- `ANDROID_KEYSTORE_BASE64`, `STORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS` — signing
- `APP_ID`, `CREDENTIAL_FILE_CONTENT` — Firebase App Distribution (develop workflow, dev project)
- `SERVICE_ACCOUNT_JSON` — Play Store upload (staging/production)
- `VERSION_BOT_APP_ID`, `VERSION_BOT_APP_PRIVATE_KEY`, `DEPLOYMENT_WEBHOOK_URL`, `DEPLOYMENT_EMAIL_RECIPIENTS`, `CODECOV_TOKEN`

### Legacy secrets to remove after migration

`WEB_API_KEY`, `WEB_APP_ID`, `ANDROID_API_KEY`, `ANDROID_APP_ID`, `IOS_API_KEY`, `IOS_APP_ID`, `GOOGLE_SERVICES_JSON_B64`

## Firebase projects

| Flavor | Project | Android package |
|--------|---------|-----------------|
| DEV | [multichoice-app-develop](https://console.firebase.google.com/u/0/project/multichoice-app-develop/overview) | `co.za.zanderkotze.multichoice.dev` |
| PROD | [multichoice-412309](https://console.firebase.google.com/u/0/project/multichoice-412309/overview) | `co.za.zanderkotze.multichoice` |

Register debug/release SHA-1 fingerprints in the dev Firebase project before Google Sign-In works on DEV builds.

**App Check:** DEV setup guide [app-check-dev.md](app-check-dev.md); PROD checklist [app-check-prod-todo.md](app-check-prod-todo.md). DEV Play Internal testing listing: [play-console-dev-internal-testing.md](play-console-dev-internal-testing.md).

## Banner and debug tooling

| Build | Banner | Debug page (long-press version) |
|-------|--------|----------------------------------|
| DEV debug/profile/release | DEV | Yes |
| PROD debug/profile | PROD | No |
| PROD release | None | No |

## Cloud Functions

Deploy [`functions/`](../functions/) separately to each Firebase project (feedback email trigger, Firestore/Storage rules). See [firebase-functions-environments.md](firebase-functions-environments.md).
