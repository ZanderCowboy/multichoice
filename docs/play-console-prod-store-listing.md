# Play Console — Multichoice PROD (Main store listing)

Guide for updating the **production** Play Console app (`co.za.zanderkotze.multichoice`) **main store listing** — app name, descriptions, contact details, images, and release notes.

**Related:**

- [play-console-dev-internal-testing.md](play-console-dev-internal-testing.md) — DEV Play app store listing (internal testing)
- [82-document-setting-up-app-for-release.md](82-document-setting-up-app-for-release.md) — Play Store release process and feature graphic
- [environment-config.md](environment-config.md) — DEV vs PROD flavors and package IDs

## App identity

| Field | Value |
|-------|--------|
| Play Console | [Main store listing](https://play.google.com/console/u/0/developers/8783535225973670504/app/4976133683768209199/main-store-listing) |
| Public listing | [Google Play — Multichoice](https://play.google.com/store/apps/details?id=co.za.zanderkotze.multichoice) |
| App name (store listing) | `Multichoice` |
| Launcher name (on device) | `Multichoice` (from `build.gradle` `resValue`) |
| Package name | `co.za.zanderkotze.multichoice` |
| Firebase project | `multichoice-412309` |
| Default language | English (United States) — add Dutch (Nederlands) as a translated listing |
| App / Game | App |
| Category | Productivity |
| Free / Paid | Free |

This is the **public** Play app. The DEV app (`co.za.zanderkotze.multichoice.dev`) is documented separately.

---

## Store listing — copy and paste

Open **Grow** → **Store presence** → **Main store listing**.

### App name

Max 30 characters.

```text
Multichoice
```

### Short description

Max 80 characters.

**Recommended (benefit-led):**

```text
Organize lists and choices in customizable tabs. Simple, fast, and flexible.
```

**Alternative (use-case focused):**

```text
Todo lists, watchlists, reading lists & more — all in one clean, flexible app.
```

### Full description

Max 4000 characters. Adjust if your privacy or contact URLs differ from Remote Config / About page.

Only mention **user accounts** in the listing if `enable_user_accounts` is enabled in production Remote Config.

```text
Multichoice helps you organize everyday decisions in one place — from todo lists and watchlists to reading lists, ideas, and anything else you want to track visually.

Create customizable collections (tabs), add entries with titles and details, and switch between vertical and horizontal layouts to match how you think and work.

PERFECT FOR
• Todo lists and personal task boards
• Books, movies, and shows you want to watch or read
• Ideas, options, and shortlists when you are deciding
• Any list you want to group, scan, and update quickly

KEY FEATURES
• Customizable tabs — organize entries your way
• Clean card-based UI — add, edit, and view item details
• Search — find entries across your collections fast
• Vertical or horizontal layout — choose the view that fits you
• Light and dark theme — comfortable day or night
• Import and export backups — move or restore your data
• Interactive tutorial — learn the app in minutes
• In-app feedback — send suggestions with optional screenshots
• English and Dutch — full app localization with in-app language selection

WHY MULTICHOICE
Multichoice is built for everyday use: lightweight, focused, and designed to stay out of your way. No clutter — just a flexible space to capture and organize what matters to you.

PRIVACY & SUPPORT
Your data stays on your device unless you choose to back it up or create an account (when available). Questions or feedback? Use the in-app feedback option or contact us via the About screen.

Download Multichoice and turn scattered lists into organized collections you can actually use.
```

**Optional bullet** — add under KEY FEATURES when `enable_user_accounts` is ON in prod:

```text
• Free account — sign in to keep collections safe across devices
```

### Dutch (Nederlands) translation

Add a **Dutch** store listing in Play Console (**Manage translations** → **Add your own translation** → Dutch).

**Short description:**

```text
Organiseer lijsten en keuzes in aanpasbare tabbladen. Eenvoudig en flexibel.
```

**Full description:**

```text
Multichoice helpt je alledaagse beslissingen op één plek te organiseren — van takenlijsten en kijklijsten tot leeslijsten, ideeën en alles wat je visueel wilt bijhouden.

Maak aanpasbare collecties (tabbladen), voeg items toe met titels en details, en wissel tussen verticale en horizontale weergave.

GESCHIKT VOOR
• Takenlijsten en persoonlijke boards
• Boeken, films en series die je wilt lezen of kijken
• Ideeën, opties en shortlists bij keuzes
• Elke lijst die je snel wilt groeperen en bijwerken

BELANGRIJKE FUNCTIES
• Aanpasbare tabbladen
• Overzichtelijke kaartweergave
• Zoeken in al je collecties
• Verticale of horizontale layout
• Licht en donker thema
• Import en export van back-ups
• Interactieve rondleiding
• Feedback in de app
• Volledige ondersteuning voor Engels en Nederlands

Download Multichoice en maak van losse lijsten overzichtelijke collecties.
```

### Release notes (What's new)

Use in **Production** (or staged track) release notes when publishing an update. Example for v0.13.1:

```text
What's new in this update:
• Refreshed home banners and improved visual consistency
• Full English and Dutch localization with in-app language selection
• In-app Changelog page for release updates
• Smoother import and export experience
```

### Contact details

Use the same values as Remote Config / About page unless you maintain separate public support contacts.

| Field | Guidance |
|-------|----------|
| Email | e.g. `info@zanderkotze.co.za` (verify against `about_contact_email` in Remote Config) |
| Phone | Optional — leave blank if unused |
| Website | e.g. `https://stackmint.app` (verify against `about_website_url` in Remote Config) |

### Privacy policy

Required. Use the **privacy policy URL** from Remote Config (`about_privacy_policy_url`) / About page.

---

## Store listing — images (`play_store/`)

All paths are relative to the repo root: `play_store/`.

### App icon (512 × 512)

| File | Size | Use |
|------|------|-----|
| [`play_store/app_icon/prod/playstore.png`](../play_store/app_icon/prod/playstore.png) | 512 × 512 | **Upload as Play Store app icon** |
| [`play_store/app_icon/prod/appstore.png`](../play_store/app_icon/prod/appstore.png) | 1024 × 1024 | Higher-res source; resize to 512 × 512 if regenerating |
| [`docs/Draw IO/app_icon_no_border.drawio`](../docs/Draw%20IO/app_icon_no_border.drawio) | — | Source diagram; export PNG and run through [appicon.co](https://www.appicon.co/#app-icon) if you need a refreshed icon |

### Feature graphic (1024 × 500)

Play Console requires a **1024 × 500** banner.

| File | Notes |
|------|--------|
| [`play_store/feature_graphic/feature_graphic.png`](../play_store/feature_graphic/feature_graphic.png) | Current production feature graphic — update if UI/theme changed significantly |

**Options if refreshing:**

1. Edit the existing [Canva design](https://www.canva.com/design/DAGiAPel9fk/MMikIcNdzS6wRZWiU4KRkg/edit) (see [82-document-setting-up-app-for-release.md](82-document-setting-up-app-for-release.md)).
2. Compose a 1024 × 500 image using new phone screenshots plus the app icon.

Reference assets for composition (phone screenshot dimensions — **not** valid feature graphic sizes without cropping):

| File | Theme / content |
|------|-----------------|
| `play_store/feature_graphic/reading/reading_home_view_horizontal_light.png` | Reading list — light |
| `play_store/feature_graphic/reading/reading_home_view_horizontal_dark.png` | Reading list — dark |
| `play_store/feature_graphic/todo/todo_home_view_horizontal_light.png` | Todo list — light |
| `play_store/feature_graphic/todo/todo_home_view_horizontal_dark.png` | Todo list — dark |

### Phone screenshots (required — min 2, max 8)

Capture fresh screenshots after UI changes (pill banners, theming, localization). Save under `play_store/screenshots/` and upload to **Phone** screenshots.

Recommended narrative order:

| # | Suggested screen | Why |
|---|------------------|-----|
| 1 | Home with collections | First impression — organized tabs |
| 2 | Horizontal layout (dark mode) | Flexibility and polish |
| 3 | Add new entry | Core create action |
| 4 | Item details | Depth of each entry |
| 5 | Search results | Find anything fast |
| 6 | Settings / drawer | Theme, language, import/export |
| 7 | Changelog (optional) | Shows active maintenance — only if `enable_changelog_page` is ON in prod |
| 8 | Sign-in or profile (optional) | Only if `enable_user_accounts` is ON in prod |

**Capture tips:**

- Use portrait **1080 × 1920** or **1440 × 2560** (or emulator equivalents)
- Populate with realistic sample data (Reading List, Watch Next, Groceries) — avoid empty states
- Mix **light and dark** theme across the set
- Keep the status bar clean (full battery, reasonable time)

Optional theme variants for light/dark coverage:

| File | Notes |
|------|--------|
| `play_store/feature_graphic/reading/reading_home_view_vertical_light.png` | Reading — light portrait |
| `play_store/feature_graphic/reading/reading_home_view_vertical_dark.png` | Reading — dark portrait |
| `play_store/feature_graphic/todo/todo_home_view_vertical_light.png` | Todo — light portrait |
| `play_store/feature_graphic/todo/todo_home_view_vertical_dark.png` | Todo — dark portrait |

### 7-inch and 10-inch tablet screenshots (optional)

Add tablet screenshots under `play_store/screenshots/7-inch/` and `play_store/screenshots/10-inch/` if you want tablet-optimized listing assets. Not required for initial publication.

### Promo video

Optional. Skip unless you have a hosted video URL ready.

---

## Production release (pointer)

For AAB build commands, closed testing, and production rollout steps, see [82-document-setting-up-app-for-release.md](82-document-setting-up-app-for-release.md) and [environment-config.md](environment-config.md).

Example PROD AAB build:

```powershell
cd apps\multichoice
flutter build appbundle --release --target lib/main_production.dart --flavor prod `
  --dart-define-from-file=config/production_config.json
```

Output: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`

Before publishing, confirm [app-check-prod-todo.md](app-check-prod-todo.md) items (Play Integrity, App Check) are complete.

---

## Checklist

- [ ] Store listing: app name, short description, full description pasted (English)
- [ ] Dutch translation added (short + full description)
- [ ] Contact email, website, and privacy policy URL verified against Remote Config
- [ ] App icon: `play_store/app_icon/prod/playstore.png`
- [ ] Feature graphic: 1024 × 500 (`play_store/feature_graphic/feature_graphic.png` or refreshed Canva export)
- [ ] Phone screenshots: at least 2 fresh captures in `play_store/screenshots/`
- [ ] Release notes updated for the version being published
- [ ] Remote Config flags reviewed — listing copy matches what users see (`enable_user_accounts`, `enable_changelog_page`, etc.)
- [ ] Listing saved and published (or included in the production release)

---

## References

- [Play Console — Main store listing](https://play.google.com/console/u/0/developers/8783535225973670504/app/4976133683768209199/main-store-listing)
- [Google Play — Multichoice (public)](https://play.google.com/store/apps/details?id=co.za.zanderkotze.multichoice)
- [Play Console Help — Create and publish a release](https://support.google.com/googleplay/android-developer/answer/9859348)
- [82-document-setting-up-app-for-release.md](82-document-setting-up-app-for-release.md)
- [play-console-dev-internal-testing.md](play-console-dev-internal-testing.md)
