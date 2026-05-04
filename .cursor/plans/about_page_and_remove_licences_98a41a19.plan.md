---
name: About page and remove licences
overview: Remove all licences UI and replace the About dialog with a dedicated About page containing social/contact/policy sections. Also clean the changelog to only reflect this PR’s fixes and fix release-build version visibility in the drawer footer.
todos:
  - id: remove-licences-ui
    content: Remove all licence UI (unlocker, dialog action, showLicensePage references) and delete related code/test.
    status: completed
  - id: about-page
    content: Create new About page screen, add AutoRoute entry, and update drawer “About” to navigate to it with the requested sections.
    status: completed
  - id: fix-version-visibility
    content: Update AppVersion footer styling so version text is visible in release builds across themes.
    status: completed
  - id: changelog-cleanup
    content: Rewrite CHANGELOG.md to only include this PR’s changes and scan/update any relevant .cursor rules/skills if they contain PR-specific changelog notes.
    status: completed
  - id: validate
    content: Run scoped analyze and add/update focused tests for the new About page flow.
    status: completed
isProject: false
---

## Scope
- Remove **all** end-user access to Flutter licences (no hidden developer mode, no licence page entry).
- Replace the current About modal/dialog with a **full page**.
- Fix release-build drawer version text contrast/visibility.
- Rewrite `CHANGELOG.md` so it only contains changes introduced by this PR (and ensure no duplicated “changelog-like” notes exist in `.cursor/*`).

## What’s in the code today (baseline)
- About is currently a dialog in `[apps/multichoice/lib/presentation/drawer/widgets/more_section.dart](apps/multichoice/lib/presentation/drawer/widgets/more_section.dart)` that can conditionally show a `Licences` action which calls `showLicensePage(...)`.
- A session-only “developer mode” unlocker exists in `[apps/multichoice/lib/presentation/drawer/widgets/about_developer_mode_unlocker.dart](apps/multichoice/lib/presentation/drawer/widgets/about_developer_mode_unlocker.dart)` with a unit test in `[apps/multichoice/test/presentation/drawer/about_developer_mode_unlocker_test.dart](apps/multichoice/test/presentation/drawer/about_developer_mode_unlocker_test.dart)`.
- Drawer footer version uses `context.appTextTheme.bodyMedium` in `[apps/multichoice/lib/presentation/drawer/widgets/app_version.dart](apps/multichoice/lib/presentation/drawer/widgets/app_version.dart)`.
- App routing is AutoRoute in `[apps/multichoice/lib/app/engine/app_router.dart](apps/multichoice/lib/app/engine/app_router.dart)`.

## Implementation approach
### Remove licences entirely
- Delete the unlocker concept:
  - Remove `AboutDeveloperModeUnlocker` usage and state from `MoreSection`.
  - Remove the file `about_developer_mode_unlocker.dart` and its export entry in `widgets/export.dart`.
  - Remove the associated test `about_developer_mode_unlocker_test.dart`.
- Ensure there are **no remaining references** to `showLicensePage(...)` or “Licences” UI.

### New About page (instead of modal)
- Add a new screen, e.g. `[apps/multichoice/lib/presentation/about/about_page.dart](apps/multichoice/lib/presentation/about/about_page.dart)` annotated with `@RoutePage()`.
- Register it in `[apps/multichoice/lib/app/engine/app_router.dart](apps/multichoice/lib/app/engine/app_router.dart)` so we can navigate via `context.router.push(const AboutRoute())` (exact generated name based on AutoRoute conventions).
- Update `MoreSection` so tapping “About” pushes the new route (keeping existing analytics event logging).
- Page layout (matching your spec):
  - **Top**: Multichoice icon + name.
  - **Middle (vertically centered)**: Social section with 2 buttons opening external URLs (system browser): Instagram + Website.
  - **Below**: Contact section with email address (tap-to-mailto).
  - **Below**: “Policies and acknowledgements” section as a list of items that open external URLs.

### Fix: release build drawer version not visible
- Adjust the `AppVersion` text style to use a color that guarantees contrast on drawer backgrounds in both themes.
  - Likely switch from `context.appTextTheme.bodyMedium` (uses theme `textPrimary`) to a style explicitly based on `context.theme.colorScheme.onSurface` or `context.theme.appColors.textSecondary` (pick the one that matches existing design patterns elsewhere).
- Validate in both light/dark theme: version remains readable.

### Fix: changelog should only reflect this PR
- Rewrite `[CHANGELOG.md](CHANGELOG.md)` to remove prior/irrelevant entries and include only:
  - Licences removed from UX
  - About moved to a page with social/contact/policies
  - Drawer version visibility fix
- Scan `.cursor/rules/*.mdc` and `.cursor/skills/*/SKILL.md` for any PR-specific “changelog” notes and remove/adjust if any are found (currently no `#316`-related text was found, but we’ll re-check after edits).

## Validation
- Run scoped analysis for the app: `melos exec --scope=multichoice -- flutter analyze`.
- Update/replace tests as needed:
  - Remove the unlocker unit test.
  - Add a widget test for About page navigation from the drawer (or a focused test ensuring the About page renders key sections), depending on existing testing patterns under `apps/multichoice/test/presentation/drawer/`.

## Notes / assumptions to bake into implementation
- Social + policy links will open externally (system browser).
- Policies/acknowledgements will be external links (not in-app pages).