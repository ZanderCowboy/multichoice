# App Check — PROD TODO

Checklist for enabling App Check on production (`multichoice-412309`). Complete after DEV is enforced and feedback is verified — see [app-check-dev.md](app-check-dev.md).

**Important:** Console setup and merging App Check SDK code do **not** require a new release. Turning on **enforcement** for Firestore/Storage requires users to be on a build that includes the SDK.

## Prerequisites

- [ ] DEV App Check enforced for Firestore + Storage
- [ ] DEV feedback submit (with images) works with registered debug tokens
- [ ] App Check SDK code merged (same code for both flavors — no PROD-specific App Check code)

## Firebase Console — multichoice-412309

Console: [multichoice-412309 → App Check](https://console.firebase.google.com/u/0/project/multichoice-412309/appcheck)

- [ ] Register Android app `co.za.zanderkotze.multichoice` (if not already listed)
- [ ] **Play Integrity** provider:
  - [ ] Add **App signing key certificate SHA-256** from [Play Console](https://play.google.com/console) → **Release** → **App integrity** → **App signing**
  - [ ] Add release signing key SHA-256 if testing release builds outside Play Store
- [ ] **Debug tokens** (optional): register tokens for internal debug/profile builds on prod flavor
- [ ] Project Settings → Android PROD app → SHA-1 and SHA-256 for debug + release keys present

## Play Console — Play Integrity API

- [ ] Play Console → **Multichoice** (prod app) → **Release** → **App integrity** → **Play Integrity API**
- [ ] Link the Google Cloud project tied to `multichoice-412309` / Firebase
- [ ] Confirm Integrity API is enabled for the app

## Release gate

- [ ] Ship a Play Store release containing App Check SDK (`firebase_app_check` + `setupAppCheck()` in bootstrap)
- [ ] Old builds without the SDK continue to work until enforcement is enabled

## Monitoring (before enforcement)

In [App Check → APIs](https://console.firebase.google.com/u/0/project/multichoice-412309/appcheck):

- [ ] **Cloud Firestore** — enable App Check, set **Unenforced**
- [ ] **Cloud Storage** — enable App Check, set **Unenforced**
- [ ] Leave **Authentication** and **Remote Config** unenforced
- [ ] Confirm metrics show valid tokens from production release builds (Play Integrity)

## Enforcement

- [ ] Wait for release adoption (suggested: 7–14 days or your usual rollout percentage)
- [ ] Switch **Cloud Firestore** to **Enforced**
- [ ] Switch **Cloud Storage** to **Enforced**
- [ ] Smoke-test feedback submit on a production build after enforcement

## Rollback

If metrics show failures or users cannot submit feedback:

1. Set Firestore and Storage back to **Unenforced** in App Check → APIs
2. Diagnose (missing Play Integrity link, wrong SHA-256, users on old builds)
3. Re-enforce after fix

## References

- [app-check-dev.md](app-check-dev.md) — provider selection and debug token workflow
- [environment-config.md](environment-config.md) — flavor and Firebase project mapping
- [Play Integrity provider setup](https://firebase.google.com/docs/app-check/android/play-integrity-provider)
