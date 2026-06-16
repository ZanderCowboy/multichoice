# User Journey: Home and Tabs

## Entry

- App opens on `HomePageWrapperRoute` (initial route in [`app_router.dart`](../../../apps/multichoice/lib/app/engine/app_router.dart)).
- [`home_page.dart`](../../../apps/multichoice/lib/presentation/home/home_page.dart): public `HomePage` → private `_HomePage` (StatefulWidget).

## Home Screen

- **App bar**: menu (drawer), search, profile/sign-in button ([`profile_button.dart`](../../../apps/multichoice/lib/presentation/home/widgets/profile_button.dart)).
- **Body**: tab strip + entry list per active tab.
- **Promotional banners** ([`home_promotional_banners.dart`](../../../apps/multichoice/lib/presentation/home/widgets/home_promotional_banners.dart)): sign-up CTA (guests), import-data CTA — respect feature flags.

## Drawer ([`home_drawer.dart`](../../../apps/multichoice/lib/presentation/drawer/home_drawer.dart))

- Account section when logged in (profile link, logout).
- Sign-in tile when logged out (opens login modal).
- Links: tutorial, feedback, about, changelog (if enabled), data transfer, debug (dev).

## Tabs and Entries

- **Edit tab**: `EditTabPageRoute` — create/rename/delete tabs.
- **Edit entry**: `EditEntryPageRoute` — add or edit a choice in a tab.
- **Details**: `DetailsPageRoute` — view single entry (see search-and-details journey).

## Product Tour

- Steps defined in `packages/models` (`ProductTourStep` enum).
- App utils under `apps/multichoice/lib/utils` for tour keys/helpers.
- `TutorialPageRoute` for dedicated tutorial flow.

## Layout

- [`apps/multichoice/lib/layouts`](../../../apps/multichoice/lib/layouts) — home layout, tab chrome.

## Feature Flags (home-related)

- `enable_user_accounts` — profile button, drawer account section, banners.
- `use_pill_style_banner` — banner visual style.
- `welcome_message` — optional Remote Config copy.
