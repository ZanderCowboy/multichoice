# App Check — DEV setup

Firebase App Check protects Firestore and Storage by verifying requests come from your app. This doc covers DEV (`multichoice-app-develop`) console setup and how the Flutter app selects attestation providers.

**PROD checklist:** [app-check-prod-todo.md](app-check-prod-todo.md)

## Before you start

| Item | Value |
|------|--------|
| Firebase project | `multichoice-app-develop` |
| Android package | `co.za.zanderkotze.multichoice.dev` |
| Console app name | **Multichoice Develop** (typical) |
| App Check console | [multichoice-app-develop → App Check](https://console.firebase.google.com/u/0/project/multichoice-app-develop/appcheck) |

You will configure **two attestation paths** depending on how you build the app:

| Build | App Check provider | What you need in Firebase Console |
|-------|-------------------|-----------------------------------|
| **Debug** (`flutter run`, Debug launch config) | Debug | **Manage debug tokens** — token from logcat |
| **Profile / Release** (CI App Distribution, `flutter run --release`) | Play Integrity | **Play Integrity** SHA-256 for the **upload/release** keystore |

A debug token registered while running **Debug [DEV]** does **not** apply to a **Release [DEV]** install on the same emulator — they use different providers.

## Code behavior

App Check is activated in `setupFirebase()` after `Firebase.initializeApp()` via [`app_check_setup.dart`](../../apps/multichoice/lib/app/bootstrap/app_check_setup.dart).

Provider selection matches the usual Flutter split: **debug builds use the debug provider; profile and release use Play Integrity** (same for DEV and PROD flavors).

| Build mode | Android provider | Applies to |
|------------|------------------|------------|
| Debug (`kDebugMode`) | `AndroidDebugProvider` | DEV and PROD |
| Profile / Release | `AndroidPlayIntegrityProvider` | DEV and PROD |

- **Android only** — web and desktop are skipped (no ReCAPTCHA keys in config yet).
- **Enforcement scope (when enabled):** Cloud Firestore and Cloud Storage only. Auth and Remote Config stay unenforced.

### Why DEV Release failed but DEV Debug worked

Typical scenario: Firestore/Storage enforced, debug token registered from a **Debug [DEV]** run, then a **DEV release** APK from CI/App Distribution fails on feedback.

1. **Different provider** — Release uses **Play Integrity**, not the debug provider. The debug token you registered is ignored.
2. **Release SHA-256** — Play Integrity must have the **upload keystore** SHA-256 (the cert that signed the CI APK), not only the debug keystore.
3. **Emulators** — Play Integrity often **does not pass** on emulators, even if SHA-256 is correct. Test release builds on a **physical device**.
4. **Install source** — APKs from Firebase App Distribution are sideloaded. Play Integrity attestation is designed around Play-distributed apps. The `.dev` package may not attest until it is on a Play track (internal testing) with Play Integrity API linked — see Step 1e.

---

## Step 1 — Play Integrity SHA-256 (required for profile / release builds)

Release and profile builds use Play Integrity. Register signing certificates under **Play Integrity** for `co.za.zanderkotze.multichoice.dev`.

The **upload/release** SHA-256 is mandatory for CI and App Distribution DEV APKs. The debug keystore SHA-256 is only needed if you run **Profile [DEV]** with a debug-signed profile build (unusual).

### 1a. Open the right screen

1. Go to [App Check → Apps](https://console.firebase.google.com/u/0/project/multichoice-app-develop/appcheck).
2. Find **Multichoice Develop** / `co.za.zanderkotze.multichoice.dev` (status may show **Unregistered** until you finish).
3. Click the app → choose **Play Integrity** as the attestation provider.
4. You should see a field **Enter SHA-256** and a link **Add another fingerprint**.

### 1b. Debug keystore SHA-256 (local `flutter run`)

Run in PowerShell:

```powershell
keytool -list -v -alias androiddebugkey -keystore "$env:USERPROFILE\.android\debug.keystore"
```

- Password: `android` (default Android debug keystore).
- If `keytool` is not found, use the JDK bundled with Android Studio, e.g.:
  `"$env:LOCALAPPDATA\Android\Sdk\jbr\bin\keytool.exe" -list -v ...`

**Read the output.** You will see two fingerprint lines — copy the **SHA256** line, not SHA1:

```
Certificate fingerprints:
     SHA1: A1:B2:C3:D4:...
     SHA256: 8F:3A:2B:1C:4D:5E:6F:...   ← copy this entire value (with colons)
```

Paste that value into Firebase **Enter SHA-256**.

### 1c. Release keystore SHA-256 (CI / App Distribution / Release builds)

DEV release APKs from CI are signed with the upload keystore, not the debug keystore. Add this fingerprint as a **second** entry (**Add another fingerprint**).

Paths and alias from [`apps/multichoice/android/key.properties`](../../apps/multichoice/android/key.properties) (gitignored — values are not in the repo):

| Property | Typical location |
|----------|------------------|
| `storeFile` | `apps/multichoice/android/upload-keystore.jks` |
| `keyAlias` | `upload` |

```powershell
keytool -list -v -alias upload -keystore "C:\Programming\Projects\multichoice\apps\multichoice\android\upload-keystore.jks"
```

Use the `storePassword` and `keyPassword` from your local `key.properties`. Copy the **SHA256** line from the output and paste into the second fingerprint field.

### 1d. Save Play Integrity settings

On the Play Integrity dialog:

| Field | Recommendation for DEV |
|-------|--------------------------|
| **Token time to live** | 1 hour (default) |
| **Require app integrity label PLAY_RECOGNISED** | Checked (default) |
| **Require account details label LICENSED** | Unchecked |
| **Minimum acceptable device integrity level** | Don't explicitly check |

Click **Save** / **Register**. The app row should move from **Unregistered** to registered for Play Integrity.

### 1e. Play Integrity API and App Distribution (DEV release)

For **PROD** release, link Play Integrity in Play Console for the prod app (see [app-check-prod-todo.md](app-check-prod-todo.md)).

For **DEV release** APKs from Firebase App Distribution:

1. If feedback still fails on a **physical device** with release SHA-256 registered, Play Integrity may require the app to be **recognized by Play**:
   - Create a separate Play app for `co.za.zanderkotze.multichoice.dev` and publish to **internal testing** — store listing copy and assets: [play-console-dev-internal-testing.md](play-console-dev-internal-testing.md), **or**
   - Play Console → **App integrity** → **Play Integrity API** → link the Firebase/GCP project.
2. Re-install from App Distribution after console changes.
3. Prefer testing **Release [DEV]** on a **physical phone**, not an emulator.

If DEV release on App Distribution cannot pass Play Integrity, options are: internal Play track for the `.dev` package, or temporarily set Firestore/Storage to **Unenforced** while testing distribution builds.

---

## Step 2 — Debug tokens (debug builds only)

Only **debug** builds use `AndroidDebugProvider`. Profile, release, and CI APKs do **not** use debug tokens.

### 2a. Run the DEV app

```bash
cd apps/multichoice
flutter run --target lib/main_develop.dart --flavor dev \
  --dart-define-from-file=config/develop_config.json
```

Or use the **Debug [DEV]** launch config in VS Code / Cursor.

On startup you should see a log similar to:

```
App Check debug provider active. Register the debug token from logcat ...
```

### 2b. Find the debug token in logcat

**Android Studio / Cursor:** open **Logcat**, filter by `App Check` or `FirebaseAppCheck`.

**Command line** (device connected):

```powershell
adb logcat -d | Select-String "App Check debug token"
```

Look for a line like:

```
App Check debug token: 12345678-ABCD-1234-ABCD-1234567890AB
```

Copy the token string (the UUID after the colon).

**If no token appears:** cold-start the app once after a clean install; ensure you are on the DEV flavor (`co.za.zanderkotze.multichoice.dev`), not PROD.

### 2c. Register the token in Firebase

1. [App Check → Apps](https://console.firebase.google.com/u/0/project/multichoice-app-develop/appcheck)
2. **Multichoice Develop** → overflow menu (⋮) → **Manage debug tokens**
3. **Add debug token** → paste the token → save

Repeat for each physical device or emulator you use for **debug** runs (tokens can differ per environment).

Do **not** expect a debug token from Step 2 to fix a **release** install — use Step 1 (Play Integrity + release SHA-256) instead.

---

## Step 3 — SHA fingerprints in Project Settings

Separate from App Check Play Integrity, Google Sign-In and some Firebase features need fingerprints under **Project Settings**.

1. [Project Settings → Your apps](https://console.firebase.google.com/u/0/project/multichoice-app-develop/settings/general)
2. Select the Android app `co.za.zanderkotze.multichoice.dev`
3. Under **SHA certificate fingerprints**, add **both** debug and release SHA-1 and SHA-256 (same values from the `keytool` commands above).

`keytool` prints SHA-1 and SHA-256 on the same block — add both for each keystore. See [environment-config.md](environment-config.md).

---

## Step 4 — Enable monitoring, then enforcement

In [App Check → APIs](https://console.firebase.google.com/u/0/project/multichoice-app-develop/appcheck):

| API | Action |
|-----|--------|
| **Cloud Firestore** | Enable App Check → start **Unenforced** (monitoring) |
| **Cloud Storage** | Same |
| **Authentication** | Leave unenforced |
| **Remote Config** | Leave unenforced |

**Order matters:** enable APIs in **Unenforced** mode **before** relying on App Check; old behavior keeps working until you enforce.

### Verification before enforcement

Test the same build types you will ship:

1. **Debug [DEV]:** debug token registered → submit feedback with images.
2. **Release [DEV]** (CI / App Distribution): release SHA-256 in Play Integrity → test on a **physical device** → submit feedback with images.
3. In App Check → **Metrics**, confirm valid token % rises for Firestore and Storage for both paths.
4. After smoke tests (or 1–2 days of clean metrics), switch Firestore and Storage to **Enforced**.

### Rollback

If requests fail after enforcement, set the API back to **Unenforced**, fix missing debug tokens or wrong project config, then re-enforce.

---

## End-to-end checklist

Use this to confirm you did not skip a step:

- [ ] Play Integrity: **upload/release** keystore **SHA-256** pasted and saved (required for CI / App Distribution)
- [ ] Play Integrity: debug keystore SHA-256 (optional; local debug builds use debug tokens instead)
- [ ] Project Settings: debug + release **SHA-1** and **SHA-256** added for the DEV Android app
- [ ] **Debug [DEV]:** debug token copied from logcat and registered
- [ ] **Debug [DEV]:** feedback submit tested
- [ ] **Release [DEV]:** feedback tested on physical device (not only emulator)
- [ ] Firestore + Storage: App Check enabled, **Unenforced**
- [ ] Metrics show valid tokens for debug and release paths
- [ ] Firestore + Storage switched to **Enforced** (only after verification)

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Debug DEV works; Release DEV fails (same device) | Release uses Play Integrity; debug token does not apply | Register **release** SHA-256; test on physical device; see Step 1e |
| Unsure what to paste after `keytool` | Copied SHA-1 instead of SHA-256 | Use the line labeled `SHA256:` (with colons) |
| Release DEV fails on emulator | Play Integrity often fails on emulators | Test Release [DEV] on a physical phone |
| Firestore/Storage `permission-denied` after enforcement (debug) | Debug token not registered for this device | Register token from logcat on a **debug** build |
| Firestore/Storage `permission-denied` after enforcement (release) | Missing/wrong release SHA-256 or Play Integrity not linked | Add upload keystore SHA-256; link Play Integrity API |
| No `App Check debug token` in logcat | Release/profile build (expected) or App Check not in build | Debug token only appears on **debug** builds |
| `App attestation failed` on profile build | Profile uses Play Integrity (`kDebugMode` is false) | Same fixes as release — SHA-256 + physical device |
| Metrics show 0% valid tokens | Wrong Firebase project or wrong attestation path | Confirm `develop_config.json` → `multichoice-app-develop` |
| `keytool` password fails for release keystore | Wrong password | Use values from local `android/key.properties` (not committed to git) |

---

## References

- [Get started with App Check in Flutter](https://firebase.google.com/docs/app-check/flutter/default-providers)
- [App Check debug provider (Flutter)](https://firebase.google.com/docs/app-check/flutter/debug-provider)
- [Play Integrity provider setup](https://firebase.google.com/docs/app-check/android/play-integrity-provider)
