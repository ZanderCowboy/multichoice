# Product Overview

## What Multichoice Is

Flutter app for managing and organizing choices across categories (tabs). Users create tabs, add entries (choices), search, export/import data, and get an in-app product tour.

Shipped on Google Play (Android only). Monorepo managed by Melos.

**Flavors**: `dev` and `prod` via compile-time `APP_FLAVOR` (`AppFlavor` in `lib/config/app_flavor.dart`). DEV enables debug page and dev launcher icon.

**Locales**: English and Dutch via slang (`lib/i18n/`). See [architecture/i18n.md](architecture/i18n.md).

## Monorepo Map

| Area | Path | Role |
|------|------|------|
| Main app | `apps/multichoice` | UI, routing, app wiring |
| Showcase | `apps/showcase` | Ignored by Melos |
| Core | `packages/core` | Blocs, services, repos, controllers |
| Models | `packages/models` | DTOs, DB models, enums, mappers |
| Theme | `packages/theme` | Colors, theme extensions |
| UI kit | `packages/ui_kit` | Shared widgets, spacing/border constants |
| Functions | `functions/` | Firebase backend |
| Docs | `docs/` | Setup guides, tickets |

## Core Features

- Dark/light theme
- Tabs and entries (create, edit, delete, details view)
- Search across choices
- Export/import (data transfer screen)
- Product tour for onboarding
- In-app feedback (optional image attachments via Remote Config — file picker + Android paste-screenshot)
- User accounts (sign-in, sign-up, password reset, profile) — gated by `enable_user_accounts`
- Changelog page (gated by `enable_changelog_page`)
- About page with remote-config URLs

## Architecture (summary)

Clean architecture monorepo: presentation in app, business logic in `core`, shared models in `models`. State via Bloc. DI via injectable/get_it. Local DB via Isar. Firebase for Remote Config, Auth, Firestore feedback.

See [architecture/layers-and-ownership.md](architecture/layers-and-ownership.md).
