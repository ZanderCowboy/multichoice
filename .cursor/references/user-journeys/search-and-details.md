# User Journey: Search and Details

## Search

- **Route**: `SearchPageRoute` from home app bar.
- **Bloc**: `packages/core/lib/src/application/search/` (`SearchBloc`).
- **Repository**: `ISearchRepository` / `SearchRepository` — Isar queries.
- User types query → results list → tap opens details.

## Details

- **Route**: `DetailsPageRoute` with entry context.
- **Bloc**: `packages/core/lib/src/application/details/` (`DetailsBloc`).
- View entry fields, actions (edit, delete per product rules).

## Add / Edit Flows

- **New tab**: `EditTabPage` — dialog-style or full page for tab metadata.
- **New/edit entry**: `EditEntryPage` — form for choice fields.
- **Add widgets**: `apps/multichoice/lib/presentation/shared/widgets/add_widgets/` — reusable add UI patterns.

## Data Layer

- Entries and tabs persisted in Isar via repositories in `packages/core/lib/src/repositories`.
- Models in `packages/models` (database models, DTOs).

## UX Expectations

- Match nearby spacing (`spacing_constants.dart`), borders, theme colors.
- Loading/empty/error states consistent with home and search pages.
- Use existing widget keys / product tour keys where applicable.

## Related Docs

- [`docs/11-create-dialog-flow-for-adding-a-new-item.md`](../../../docs/11-create-dialog-flow-for-adding-a-new-item.md)
- [`docs/4-add-and-implement-db.md`](../../../docs/4-add-and-implement-db.md)
