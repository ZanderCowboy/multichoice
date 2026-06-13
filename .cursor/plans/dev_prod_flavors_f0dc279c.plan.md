---
name: DEV PROD Flavors
overview: Introduce `dev` and `prod` Android flavors wired to separate Firebase projects (`multichoice-app-develop` vs `multichoice-412309`), JSON config via `--dart-define-from-file`, two main entry points (no main.dart), update CI with DEV_CONFIG_B64/PROD_CONFIG_B64, launch configs, banners, and DEV-only debug tooling. Android-only. No commit/PR until manual verification.
todos:
  - id: main-entrypoints
    content: Delete main.dart; add main_develop.dart, main_production.dart, and shared runMultichoice()
    status: completed
  - id: env-config
    content: Add AppConfig (fromEnvironment), develop_config.json / production_config.json, remove lib/auth/secrets.dart
    status: completed
  - id: firebase-options
    content: Update firebase_options.dart to read from AppConfig defines (no secrets import)
    status: completed
  - id: android-flavors
    content: Add dev/prod productFlavors, app_name resValue, flavor google-services.json dirs
    status: completed
  - id: ui-banner-debug
    content: Update multichoice.dart banner, app_version.dart, debug_page.dart
    status: completed
  - id: launch-json
    content: Add 6 VS Code launch configs with dart-define-from-file per flavor
    status: completed
  - id: onboarding-doc
    content: Add environment config onboarding doc (no .example secret files)
    status: completed
  - id: ci-workflows
    content: Update workflows to decode DEV/PROD_CONFIG_B64 + DEV/PROD_GOOGLE_SERVICES_B64 + prepare-android-release-files action
    status: completed
  - id: manual-verify
    content: User manual testing before commit/PR (no git push in this task)
    status: completed
isProject: false
---

# DEV/PROD Flavor Setup (Issue #386)

**Constraint:** Implement locally for your manual testing first. Do **not** commit or open a PR until you confirm builds behave correctly.

**Scope:** Android only — iOS folder removed; drop all iOS schemes, `GoogleService-Info.plist`, and iOS keys from config (unless re-added later).

## Current state

- Single Android app ID [`co.za.zanderkotze.multichoice`](apps/multichoice/android/app/build.gradle) with prod `google-services.json` at `android/app/`.
- [`firebase_options.dart`](apps/multichoice/lib/firebase_options.dart) imports [`secrets.dart`](apps/multichoice/lib/auth/secrets.dart) and hardcodes prod `projectId`.
- [`secrets.dart`](apps/multichoice/lib/auth/secrets.dart) is gitignored; CI writes it field-by-field from many GitHub secrets.
- Dev `google-services.json` is available (project `multichoice-app-develop`, package `co.za.zanderkotze.multichoice.dev`).
- No Android `productFlavors` exist.

```mermaid
flowchart LR
  subgraph local [Local launch.json]
    DevCfg[develop_config.json]
    ProdCfg[production_config.json]
    DevMain[main_develop.dart]
    ProdMain[main_production.dart]
  end
  subgraph android [Android flavors]
    DevFlavor[dev flavor]
    ProdFlavor[prod flavor]
  end
  subgraph firebase [Firebase projects]
    DevFB[multichoice-app-develop]
    ProdFB[multichoice-412309]
  end
  DevCfg --> DevMain --> DevFlavor --> DevFB
  ProdCfg --> ProdMain --> ProdFlavor --> ProdFB
```

## Architecture decisions

| Concern | Approach |
|---------|----------|
| Entry points | [`main_develop.dart`](apps/multichoice/lib/main_develop.dart) + [`main_production.dart`](apps/multichoice/lib/main_production.dart) only — **delete [`main.dart`](apps/multichoice/lib/main.dart)** |
| Config source | **`--dart-define-from-file`** — replaces entire `lib/auth/secrets.dart` pattern |
| Local config files | Gitignored [`apps/multichoice/config/develop_config.json`](apps/multichoice/config/develop_config.json) and [`production_config.json`](apps/multichoice/config/production_config.json) |
| CI secrets | **`DEV_CONFIG_B64`** / **`PROD_CONFIG_B64`** (flat dart-define JSON) + **`DEV_GOOGLE_SERVICES_B64`** / **`PROD_GOOGLE_SERVICES_B64`** (native config); other concerns stay as separate secrets |
| Flavor signal | `APP_FLAVOR` key inside each config JSON → `String.fromEnvironment('APP_FLAVOR')` in [`AppFlavor`](apps/multichoice/lib/config/app_flavor.dart) |
| Firebase Dart init | [`firebase_options.dart`](apps/multichoice/lib/firebase_options.dart) reads all values via `AppConfig` / `fromEnvironment` |
| Native Firebase | `android/app/src/dev/google-services.json` and `android/app/src/prod/google-services.json` (gitignored) |
| Dev package ID | `applicationIdSuffix ".dev"` → `co.za.zanderkotze.multichoice.dev` |
| Onboarding | New doc (e.g. [`docs/environment-config.md`](docs/environment-config.md)) with JSON schema + setup steps — **no** `*.example` secret/config files |
| Platform | Android only |
| sandbox_workflow | Unchanged (may break until updated later) |

### Why `--dart-define-from-file` instead of `secrets.dart`?

**Yes — this is the recommended approach.** Flutter SDK `>=3.7` supports [`--dart-define-from-file`](https://docs.flutter.dev/deployment/flavors#using-dart-defines) (your SDK `>=3.10.8` qualifies).

- Removes generated/hand-maintained Dart secret files.
- Same mechanism locally (launch.json) and in CI (`flutter build --dart-define-from-file=...`).
- Values accessed via `const String.fromEnvironment('WEB_API_KEY')` etc. in a small [`AppConfig`](apps/multichoice/lib/config/app_config.dart) class.
- [`firebase_options.dart`](apps/multichoice/lib/firebase_options.dart) imports `AppConfig` instead of `secrets.dart`.

**Caveat:** `--dart-define-from-file` only accepts **flat string/bool** entries — no nested objects. So `google-services.json` is always a **separate file** on disk (`android/app/src/{dev,prod}/`). It is never passed to Flutter as a dart-define.

**No `*.defines.json` files.** Locally you maintain one flat `develop_config.json` and point launch.json at it directly. CI decodes the same file shape from `DEV_CONFIG_B64` — no `jq` splitting.

## 1. Main entry points

**Delete** [`apps/multichoice/lib/main.dart`](apps/multichoice/lib/main.dart) — no backward-compat alias.

**[`apps/multichoice/lib/app/run_multichoice.dart`](apps/multichoice/lib/app/run_multichoice.dart)** — shared startup (extract current main.dart body):

```dart
Future<void> runMultichoice() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();
  await bootstrap();
  // crashlytics, window_size (desktop), runApp(...)
}
```

**[`apps/multichoice/lib/main_develop.dart`](apps/multichoice/lib/main_develop.dart)** and **`main_production.dart`** — thin wrappers:

```dart
import 'package:multichoice/app/run_multichoice.dart';
import 'package:multichoice/config/app_flavor.dart';
import 'package:flutter/foundation.dart';

void main() async {
  assert(
    AppFlavor.isDev, // or isProd in main_production.dart
    'Run with --dart-define-from-file=config/develop_config.json',
  );
  await runMultichoice();
}
```

The `assert` catches entry-point / config-file mismatches during debug builds.

## 2. App flavor + AppConfig modules

**[`apps/multichoice/lib/config/app_flavor.dart`](apps/multichoice/lib/config/app_flavor.dart)** — driven by dart-define, not runtime `useDev()`:

```dart
abstract final class AppFlavor {
  static const flavor = String.fromEnvironment('APP_FLAVOR', defaultValue: 'prod');
  static bool get isDev => flavor == 'dev';
  static bool get isProd => !isDev;
  static bool get allowsDebugPage => isDev;
  static bool get showsEnvironmentBanner => isDev || (isProd && !kReleaseMode);
}
```

**[`apps/multichoice/lib/config/app_config.dart`](apps/multichoice/lib/config/app_config.dart)** — thin `fromEnvironment` accessors:

```dart
abstract final class AppConfig {
  static const webApiKey = String.fromEnvironment('WEB_API_KEY');
  static const androidApiKey = String.fromEnvironment('ANDROID_API_KEY');
  static const androidAppId = String.fromEnvironment('ANDROID_APP_ID');
  static const firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const messagingSenderId = String.fromEnvironment('MESSAGING_SENDER_ID');
  static const authDomain = String.fromEnvironment('AUTH_DOMAIN');
  static const storageBucket = String.fromEnvironment('STORAGE_BUCKET');
  static const revenueCatAndroidApiKey = String.fromEnvironment('REVENUE_CAT_ANDROID_API_KEY', defaultValue: '');
  // ... other keys as needed
}
```

**Remove** the entire [`lib/auth/`](apps/multichoice/lib/auth/) secrets pattern (`secrets.dart`, `secrets_develop.dart`, `secrets_production.dart`). Update [`.gitignore`](apps/multichoice/.gitignore): drop `lib/auth/` rule; add `config/develop_config.json` and `config/production_config.json`.

## 3. Environment config JSON (local + CI)

### Two files per environment (not one nested blob)

| File | Purpose | Used by |
|------|---------|---------|
| `config/develop_config.json` | **Flat** dart-defines only | `--dart-define-from-file` (local + CI) |
| `android/app/src/dev/google-services.json` | Native Firebase config | Gradle / Google Services plugin |

Same pattern for prod: `production_config.json` + `android/app/src/prod/google-services.json`.

### Local `develop_config.json` (flat — passed directly to Flutter)

```json
{
  "APP_FLAVOR": "dev",
  "WEB_API_KEY": "...",
  "WEB_APP_ID": "...",
  "ANDROID_API_KEY": "AIzaSyBubUjVay3aR6q4VrYDuJPWlTRQj4yJfQ8",
  "ANDROID_APP_ID": "1:663305224058:android:ec2b1bdcb110b9b99760c3",
  "FIREBASE_PROJECT_ID": "multichoice-app-develop",
  "MESSAGING_SENDER_ID": "663305224058",
  "AUTH_DOMAIN": "multichoice-app-develop.firebaseapp.com",
  "STORAGE_BUCKET": "multichoice-app-develop.firebasestorage.app",
  "REVENUE_CAT_ANDROID_API_KEY": "..."
}
```

No `jq` step — locally or in CI.

### GitHub secrets mapping (one secret per artifact)

| GitHub secret | Decodes to | Same file you use locally |
|---------------|------------|---------------------------|
| `DEV_CONFIG_B64` | `config/develop_config.json` | yes — flat dart-defines |
| `PROD_CONFIG_B64` | `config/production_config.json` | yes |
| `DEV_GOOGLE_SERVICES_B64` | `android/app/src/dev/google-services.json` | yes |
| `PROD_GOOGLE_SERVICES_B64` | `android/app/src/prod/google-services.json` | yes |

CI decode (develop example — direct, no wrapping):

```bash
printf '%s' "${{ secrets.DEV_CONFIG_B64 }}" | base64 --decode > apps/multichoice/config/develop_config.json
printf '%s' "${{ secrets.DEV_GOOGLE_SERVICES_B64 }}" | base64 --decode > apps/multichoice/android/app/src/dev/google-services.json
# validate google-services package_name + mobilesdk_app_id match develop_config.json ANDROID_* keys
```

### Known dev values (from your `google-services.json`)

| Key | Value |
|-----|-------|
| `ANDROID_API_KEY` | `AIzaSyBubUjVay3aR6q4VrYDuJPWlTRQj4yJfQ8` |
| `ANDROID_APP_ID` | `1:663305224058:android:ec2b1bdcb110b9b99760c3` |
| `FIREBASE_PROJECT_ID` | `multichoice-app-develop` |
| `MESSAGING_SENDER_ID` | `663305224058` |
| `STORAGE_BUCKET` | `multichoice-app-develop.firebasestorage.app` |
| `google-services` package | `co.za.zanderkotze.multichoice.dev` |

Populate `WEB_*` and `AUTH_DOMAIN` from Firebase Console / FlutterFire as needed.

### Onboarding doc (no `.example` files)

Add [`docs/environment-config.md`](docs/environment-config.md) covering:

- JSON schema above with placeholder values
- How to create local `develop_config.json` / `production_config.json`
- How to base64-encode for GitHub (four secrets, four files):
  - `DEV_CONFIG_B64` ← `develop_config.json`
  - `PROD_CONFIG_B64` ← `production_config.json`
  - `DEV_GOOGLE_SERVICES_B64` ← `android/app/src/dev/google-services.json`
  - `PROD_GOOGLE_SERVICES_B64` ← `android/app/src/prod/google-services.json`
  - Linux: `base64 -w0 <file>` / PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes("path"))`
- Launch.json and `flutter run` examples
- SHA-1 setup for Google Sign-In on dev project
- Note: dev `google_services.oauth_client` is empty until SHA-1 is registered

Optionally add a short pointer in [`.github/README.md`](.github/README.md).

## 4. Firebase options

Update [`firebase_options.dart`](apps/multichoice/lib/firebase_options.dart):

- Remove `import 'package:multichoice/auth/secrets.dart'`
- Use `AppConfig.androidApiKey`, `AppConfig.firebaseProjectId`, etc.
- Remove iOS `FirebaseOptions` branch (Android-only) or guard with `UnsupportedError` on non-Android
- Remove hardcoded prod `projectId` / `messagingSenderId`

## 5. Android flavors

Update [`apps/multichoice/android/app/build.gradle`](apps/multichoice/android/app/build.gradle):

```gradle
flavorDimensions "environment"
productFlavors {
    dev {
        dimension "environment"
        applicationIdSuffix ".dev"
        versionNameSuffix "-dev"
        resValue "string", "app_name", "Multichoice Dev"
    }
    prod {
        dimension "environment"
        resValue "string", "app_name", "Multichoice"
    }
}
```

Update [`AndroidManifest.xml`](apps/multichoice/android/app/src/main/AndroidManifest.xml): `android:label="@string/app_name"`.

Move native configs:

```
android/app/src/dev/google-services.json      ← from dev Firebase (you have this)
android/app/src/prod/google-services.json     ← from current android/app/google-services.json
```

Remove legacy `android/app/google-services.json` once flavor dirs are in place.

## 6. VS Code launch configs

Replace multichoice entries in [`.vscode/launch.json`](.vscode/launch.json):

| Name | program | flutterMode | toolArgs / args |
|------|---------|-------------|-----------------|
| multichoice debug [DEV] | `apps/multichoice/lib/main_develop.dart` | debug | `--flavor dev`, `--dart-define-from-file=apps/multichoice/config/develop_config.json` |
| multichoice profile [DEV] | `main_develop.dart` | profile | same |
| multichoice release [DEV] | `main_develop.dart` | release | same |
| multichoice debug [PROD] | `main_production.dart` | debug | `--flavor prod`, `--dart-define-from-file=apps/multichoice/config/production_config.json` |
| multichoice profile [PROD] | `main_production.dart` | profile | same |
| multichoice release [PROD] | `main_production.dart` | release | same |

> VS Code Dart extension passes extra args via `"toolArgs"` (preferred) or `"args"` depending on extension version — use whichever matches your existing launch.json pattern.

## 7. Debug page + banner UI

- [`app_version.dart`](apps/multichoice/lib/presentation/drawer/widgets/app_version.dart): `AppFlavor.allowsDebugPage` instead of `kDebugMode`
- [`debug_page.dart`](apps/multichoice/lib/presentation/debug/debug_page.dart): same
- [`multichoice.dart`](apps/multichoice/lib/app/view/multichoice.dart): environment `Banner` when `AppFlavor.showsEnvironmentBanner`

| Build | Banner |
|-------|--------|
| DEV debug/profile/release | DEV |
| PROD debug/profile | PROD |
| PROD release | none |

Keep `kDebugMode` for build-mode behavior (Remote Config fetch, changelog refresh, `clearAllData`).

## 8. CI/CD workflow updates

### Config decode step (shared script or composite action)

```bash
# develop_workflow.yml
printf '%s' "${{ secrets.DEV_CONFIG_B64 }}" | base64 --decode > apps/multichoice/config/develop_config.json
printf '%s' "${{ secrets.DEV_GOOGLE_SERVICES_B64 }}" | base64 --decode > apps/multichoice/android/app/src/dev/google-services.json
# validate package_name + mobilesdk_app_id vs develop_config.json ANDROID_* keys

# staging/production_workflow.yml
printf '%s' "${{ secrets.PROD_CONFIG_B64 }}" | base64 --decode > apps/multichoice/config/production_config.json
printf '%s' "${{ secrets.PROD_GOOGLE_SERVICES_B64 }}" | base64 --decode > apps/multichoice/android/app/src/prod/google-services.json
```

### develop_workflow.yml → DEV

- Decode `DEV_CONFIG_B64` + `DEV_GOOGLE_SERVICES_B64`
- Build: `flutter build apk --target lib/main_develop.dart --flavor dev --dart-define-from-file=config/develop_config.json`
- Artifacts: `app-dev-release.apk`, `bundle/devRelease/app-dev-release.aab`
- Firebase App Distribution: keep **`APP_ID`** + **`CREDENTIAL_FILE_CONTENT`** as separate secrets (dev project values)

### staging_workflow.yml + production_workflow.yml → PROD

- Decode `PROD_CONFIG_B64` + `PROD_GOOGLE_SERVICES_B64`
- Build: `--target lib/main_production.dart --flavor prod --dart-define-from-file=config/production_config.json`
- Artifacts: `app-prod-release.apk`, `bundle/prodRelease/...`

### Refactor [`prepare-android-release-files`](.github/actions/prepare-android-release-files/action.yml)

Replace per-field secret inputs with:

- `config_b64` → decode to `config/{develop,production}_config.json`
- `google_services_b64` → decode to `android/app/src/{dev,prod}/google-services.json`
- `flavor` (`dev` | `prod`)
- `package_name` for validation (`co.za.zanderkotze.multichoice.dev` vs `co.za.zanderkotze.multichoice`)
- Remove `secrets.dart` creation step entirely

### sandbox_workflow.yml

Unchanged — may fail after flavors land.

### Migrate away from legacy per-key GitHub secrets

After migration, **remove** (values now in config JSON or renamed B64 secrets):

- `WEB_API_KEY`, `WEB_APP_ID`, `ANDROID_API_KEY`, `ANDROID_APP_ID`, `IOS_API_KEY`, `IOS_APP_ID`
- `GOOGLE_SERVICES_JSON_B64` → replaced by `DEV_GOOGLE_SERVICES_B64` / `PROD_GOOGLE_SERVICES_B64`

## 9. GitHub secrets

### New / renamed (required per environment)

| Secret | Contents |
|--------|----------|
| **`DEV_CONFIG_B64`** | Base64 of flat `develop_config.json` only |
| **`PROD_CONFIG_B64`** | Base64 of flat `production_config.json` only |
| **`DEV_GOOGLE_SERVICES_B64`** | Base64 of dev `google-services.json` |
| **`PROD_GOOGLE_SERVICES_B64`** | Base64 of prod `google-services.json` |

### Keep as separate secrets (not in config JSON)

| Secret | Used by | Notes |
|--------|---------|-------|
| `ANDROID_KEYSTORE_BASE64`, `STORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS` | All release builds | Signing |
| `APP_ID` | develop_workflow | Firebase App Distribution app ID (**dev** project) |
| `CREDENTIAL_FILE_CONTENT` | develop_workflow | App Distribution service account (**dev** project) |
| `SERVICE_ACCOUNT_JSON` | staging/production | Play Store upload (**prod**) |
| `VERSION_BOT_APP_ID`, `VERSION_BOT_APP_PRIVATE_KEY` | All versioned workflows | Version bot |
| `DEPLOYMENT_WEBHOOK_URL`, `DEPLOYMENT_EMAIL_RECIPIENTS` | Post-deploy notifications | |
| `CODECOV_TOKEN` | CI coverage | |

Consider renaming dev distribution secrets to `DEV_APP_ID` / `DEV_CREDENTIAL_FILE_CONTENT` for clarity (optional — not required for implementation).

## 10. Manual verification checklist

1. Create flat `develop_config.json` and `production_config.json` locally.
2. Place / extract `google-services.json` under `src/dev/` and `src/prod/`.
3. Run all 6 launch configs on Android emulator/device.
4. Confirm Firebase project: DEV → `multichoice-app-develop`, PROD → `multichoice-412309`.
5. Side-by-side install (`.dev` package).
6. Google Sign-In on DEV (SHA-1 registered).
7. Base64-encode config + google-services files → set four GitHub secrets → dry-run develop workflow.

## Gaps / footguns

- **Entry point + config + flavor must stay paired** — `main_develop.dart` + `develop_config.json` + `--flavor dev`.
- **`develop_config.json` must be flat** — `DEV_CONFIG_B64` is a direct base64 copy of that file; do not nest `google_services` inside it.
- **Keep config and google-services secrets in sync** — `ANDROID_APP_ID` / `ANDROID_API_KEY` in config must match the decoded `google-services.json`.
- **`debug_page.dart`** must change alongside `app_version.dart`.
- **Remove iOS references** from `firebase_options.dart`, pubspec platform notes, and any desktop `Platform.isIOS` crashlytics branch if desired.
- **sandbox_workflow** still uses old pattern until updated.
- **No `main.dart`** — update any docs/scripts that reference it (integration test launch config, README, etc.).

## Suggested implementation order

1. `AppConfig` + `AppFlavor` + delete `lib/auth/secrets*`
2. `run_multichoice.dart` + `main_develop.dart` / `main_production.dart` + delete `main.dart`
3. `develop_config.json` / `production_config.json` + `firebase_options` update
4. Android `productFlavors` + `google-services.json` flavor dirs
5. Banner + debug page gating
6. `launch.json` + `docs/environment-config.md`
7. CI decode script + workflow updates (after local verification)
