# Layers and Ownership

## Package Boundaries

| Layer | Location | Owns |
|-------|----------|------|
| Presentation | `apps/multichoice/lib/presentation`, `layouts`, `app`, `utils` | Pages, widgets, routing, app-only helpers |
| Application | `packages/core/lib/src/application` | Blocs (events, states, handlers) |
| Domain/data | `packages/core/lib/src/repositories`, `services`, `controllers`, `wrappers` | Interfaces + implementations |
| Models | `packages/models/lib/src` | DTOs, Isar models, enums, mappers |
| Shared UI | `packages/ui_kit`, `packages/theme` | Reusable widgets, constants, colors |

**Do not** put business logic in presentation or duplicate models in the app.

## Folder Conventions

- Services/controllers/wrappers: `interfaces/` + `implementations/`
- Repositories: `interfaces/` + `implementation/` (note singular `implementation`)
- App pages: feature folder under `presentation/<feature>/`
- Tests mirror source under each package's `test/` tree

## App Wiring

- `apps/multichoice/lib/app` — router (`auto_route`), theme, DI (`coreSl`), auth notifier
- Barrel files: `export.dart` (not `index.dart`)

## Canonical Examples

| Pattern | Example |
|---------|---------|
| Bloc | `packages/core/.../profile/profile_bloc.dart` |
| Thin repository | `.../registration/registration_repository.dart` |
| Isar repository | `.../search/search_repository.dart` |
| Page + bloc | `apps/multichoice/.../profile/profile_page.dart` |

See `.cursor/templates/` for scaffolds.
