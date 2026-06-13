# Play Console — Multichoice DEV (Internal testing)

Guide for creating the **DEV** Play Console app (`co.za.zanderkotze.multichoice.dev`), filling in the **store listing**, and publishing to **Internal testing** so `AndroidPlayIntegrityProvider` works with release/profile DEV builds.

**Related:**

- [app-check-dev.md](app-check-dev.md) — Firebase App Check and Play Integrity SHA-256 setup
- [environment-config.md](environment-config.md) — DEV vs PROD flavors and package IDs
- [82-document-setting-up-app-for-release.md](82-document-setting-up-app-for-release.md) — PROD Play Store release (reference)

## App identity

| Field | Value |
|-------|--------|
| Play Console | [Developer account](https://play.google.com/console/u/0/developers/8783535225973670504/app-list) → **Create app** |
| App name (store listing) | `[DEV] Multichoice` |
| Launcher name (on device) | `[DEV] Multichoice` (from `build.gradle` `resValue`) |
| Package name | `co.za.zanderkotze.multichoice.dev` |
| Firebase project | `multichoice-app-develop` |
| Default language | English (United States) — or your primary locale |
| App / Game | App |
| Free / Paid | Free |

This is a **separate** Play app from production (`co.za.zanderkotze.multichoice`). Internal testing on the prod app does **not** cover the `.dev` package.

---

## Store listing — copy and paste

Open the new DEV app → **Grow** → **Store presence** → **Main store listing**.

### App name

Max 30 characters.

```text
[DEV] Multichoice
```

### Short description

Max 80 characters.

```text
Internal dev build of Multichoice for testers. Not for public use.
```

### Full description

Max 4000 characters. Adjust if your privacy or contact URLs differ from production.

```text
[DEV] Multichoice is the internal development build of Multichoice. It is published on Google Play Internal testing for team validation only — not for general public use.

Use this build to test upcoming features, Firebase App Check (Play Integrity), feedback submission, and release signing before changes ship to the production app.

WHAT YOU CAN DO
• Organize entries into customizable tabs (reading lists, todos, watchlists, and more)
• Create, edit, and delete entries with a clean card-based UI
• Search across your collections
• Export and import backup files
• Dark and light theme support
• In-app feedback with optional image attachments
• Interactive product tour for new users

IMPORTANT — DEVELOPMENT BUILD
• Package ID: co.za.zanderkotze.multichoice.dev (installs alongside the production app)
• Connects to the development Firebase project (multichoice-app-develop), not production data
• Builds may be unstable, incomplete, or reset without notice
• Do not use for real personal data you cannot afford to lose
• For the stable public app, install "Multichoice" from Google Play (co.za.zanderkotze.multichoice)

INTERNAL TESTERS
Access is limited to testers invited via Play Console Internal testing. If you need access, contact the development team.

Feedback and support: use the in-app feedback option or the contact details on the About screen.
```

### Contact details

Use the same contact email and website as the **production** Play listing (from Remote Config / About page), unless you maintain separate dev support contacts.

| Field | Guidance |
|-------|----------|
| Email | Same as prod (e.g. your support or developer email) |
| Phone | Optional — same as prod or leave blank |
| Website | Same as prod website URL |

### Privacy policy

Required for Play Console setup. Use the **same privacy policy URL** as the production Multichoice listing unless you host a dev-specific policy.

---

## Store listing — images (`play_store/`)

All paths are relative to the repo root: `play_store/`.

### App icon (512 × 512)

| File | Size | Use |
|------|------|-----|
| [`play_store/app_icon/playstore.png`](../play_store/app_icon/playstore.png) | 512 × 512 | **Upload as Play Store app icon** |
| [`play_store/app_icon/appstore.png`](../play_store/app_icon/appstore.png) | 1024 × 1024 | iOS / higher-res source; resize to 512 × 512 if regenerating |
| [`play_store/app_icon_no_border.drawio`](../play_store/app_icon_no_border.drawio) | — | Source diagram; export PNG and run through [appicon.co](https://www.appicon.co/#app-icon) if you need a refreshed icon |

**Tip:** The DEV listing can use the **same icon** as production. Testers distinguish the app by the `[DEV]` launcher name and package ID.

### Feature graphic (1024 × 500)

Play Console requires a **1024 × 500** banner. Files under `play_store/feature_graphic/` are **phone screenshots** (1408 × 2974), not feature graphics — do not upload them to the feature graphic slot without resizing/cropping.

**Options:**

1. Reuse the production feature graphic from [Canva](https://www.canva.com/design/DAGiAPel9fk/MMikIcNdzS6wRZWiU4KRkg/edit) (see [82-document-setting-up-app-for-release.md](82-document-setting-up-app-for-release.md)) and add a visible **DEV** label.
2. Compose a 1024 × 500 image in Canva using screenshots from `play_store/screenshots/` plus the app icon.

Reference assets (for composition only):

| File | Theme / content |
|------|-----------------|
| `play_store/feature_graphic/reading/reading_home_view_horizontal_light.png` | Reading list — light |
| `play_store/feature_graphic/reading/reading_home_view_horizontal_dark.png` | Reading list — dark |
| `play_store/feature_graphic/todo/todo_home_view_horizontal_light.png` | Todo list — light |
| `play_store/feature_graphic/todo/todo_home_view_horizontal_dark.png` | Todo list — dark |

### Phone screenshots (required — min 2, max 8)

Portrait **1408 × 2974** — valid phone screenshot aspect ratio. Upload to **Phone** screenshots.

Recommended set (covers main flows):

| # | File | Screen |
|---|------|--------|
| 1 | [`play_store/screenshots/home_view.png`](../play_store/screenshots/home_view.png) | Home / tab view |
| 2 | [`play_store/screenshots/home_view_tabs_menu.png`](../play_store/screenshots/home_view_tabs_menu.png) | Tabs menu |
| 3 | [`play_store/screenshots/add_new_entry.png`](../play_store/screenshots/add_new_entry.png) | Add entry |
| 4 | [`play_store/screenshots/item_details.png`](../play_store/screenshots/item_details.png) | Entry details |
| 5 | [`play_store/screenshots/edit_entry.png`](../play_store/screenshots/edit_entry.png) | Edit entry |
| 6 | [`play_store/screenshots/edit_tab.png`](../play_store/screenshots/edit_tab.png) | Edit tab |
| 7 | [`play_store/screenshots/settings_view.png`](../play_store/screenshots/settings_view.png) | Settings |

Optional theme variants (if you want light/dark coverage on the listing):

| File | Notes |
|------|--------|
| `play_store/feature_graphic/reading/reading_home_view_vertical_light.png` | Reading — light portrait |
| `play_store/feature_graphic/reading/reading_home_view_vertical_dark.png` | Reading — dark portrait |
| `play_store/feature_graphic/todo/todo_home_view_vertical_light.png` | Todo — light portrait |
| `play_store/feature_graphic/todo/todo_home_view_vertical_dark.png` | Todo — dark portrait |

### 7-inch tablet screenshots (optional)

| File | Size | Theme |
|------|------|--------|
| [`play_store/screenshots/7-inch/home_view_horizontal_light.png`](../play_store/screenshots/7-inch/home_view_horizontal_light.png) | 2204 × 2274 | Light, landscape |
| [`play_store/screenshots/7-inch/home_view_horizontal_dark.png`](../play_store/screenshots/7-inch/home_view_horizontal_dark.png) | 2204 × 2274 | Dark, landscape |
| [`play_store/screenshots/7-inch/home_view_vertical_light.png`](../play_store/screenshots/7-inch/home_view_vertical_light.png) | 2204 × 2274 | Light, portrait |

### 10-inch tablet screenshots (optional)

| File | Size | Theme |
|------|------|--------|
| [`play_store/screenshots/10-inch/home_view_horizontal_dark.png`](../play_store/screenshots/10-inch/home_view_horizontal_dark.png) | 2798 × 1837 | Dark, landscape |
| [`play_store/screenshots/10-inch/home_view_vertical_light.png`](../play_store/screenshots/10-inch/home_view_vertical_light.png) | 2798 × 1837 | Light, portrait |

### Promo video

Optional. Skip for DEV internal testing unless you already have a prod video URL to reuse.

---

## Dashboard setup (before Internal testing)

Complete **Dashboard → Set up your app** items. You can mirror answers from the production app where behavior is the same.

| Section | DEV notes |
|---------|-----------|
| App access | Same as prod if login is required; otherwise “All functionality available without restrictions” |
| Ads | Same as prod (typically no ads) |
| Content rating | Same questionnaire as prod |
| Target audience | Same age groups as prod |
| News apps | No (unless applicable) |
| COVID-19 contact tracing | No |
| Data safety | Same data types as prod; note dev Firebase project if asked |
| Government apps | No |
| Financial features | No (unless applicable) |
| Store listing | Use copy and images above |

---

## Internal testing release

### 1. Build the AAB

```powershell
cd apps\multichoice
flutter build appbundle --release --target lib/main_develop.dart --flavor dev `
  --dart-define-from-file=config/develop_config.json
```

Output: `build/app/outputs/bundle/devRelease/app-dev-release.aab`

CI also produces this artifact on **develop-workflow** (`android-release-appbundle`).

### 2. Upload to Internal testing

1. **Testing → Internal testing** → **Create new release**
2. Upload `app-dev-release.aab`
3. Release notes (example):

   ```text
   DEV internal build for tester validation.
   Firebase: multichoice-app-develop
   Package: co.za.zanderkotze.multichoice.dev
   ```

4. **Review release** → **Start rollout to Internal testing**

### 3. Add testers

**Testers** tab → create an email list → add testers → share the **opt-in URL**.

Testers must install from that Play link on a **physical device** (not sideloaded App Distribution APK) for reliable Play Integrity.

### 4. App integrity and App Check

After the first upload:

1. **Release → App integrity → App signing** — copy **App signing key certificate** SHA-256
2. **Release → App integrity → Play Integrity API** — link GCP project `multichoice-app-develop`
3. Register SHA-256 in [Firebase App Check](https://console.firebase.google.com/u/0/project/multichoice-app-develop/appcheck) — full steps in [app-check-dev.md](app-check-dev.md)

---

## Checklist

- [ ] Play app created with package `co.za.zanderkotze.multichoice.dev`
- [ ] Store listing: app name, short description, full description pasted
- [ ] App icon: `play_store/app_icon/playstore.png`
- [ ] Feature graphic: 1024 × 500 (Canva or composite — not raw `feature_graphic/` PNGs)
- [ ] Phone screenshots: at least 2 from `play_store/screenshots/`
- [ ] Privacy policy URL set
- [ ] Dashboard policy sections completed
- [ ] AAB uploaded to Internal testing
- [ ] Testers added and opt-in link shared
- [ ] Play Integrity API linked to `multichoice-app-develop`
- [ ] App signing SHA-256 registered in Firebase App Check
- [ ] Release/profile DEV build verified on a physical device

---

## References

- [Play Console Help — Create and publish a release](https://support.google.com/googleplay/android-developer/answer/9859348)
- [Play Integrity provider (Firebase App Check)](https://firebase.google.com/docs/app-check/android/play-integrity-provider)
- [app-check-dev.md](app-check-dev.md)
