# Code Generation and DI

## Commands

| Task | Command |
|------|---------|
| Codegen | `make db` or `melos build` |
| Full rebuild | `make frb` or `make mr` |
| Scoped analyze | `melos exec --scope=<pkg> -- flutter analyze` |
| Core tests | `melos test:core` |
| App tests | `melos test:multichoice` |
| i18n | `make slang` or `melos slang` (after `*.i18n.json` edits) |

## Generated Artifacts (do not hand-edit)

All patterns below are **gitignored** (root `.gitignore`). They exist on disk after codegen but **never appear in `git diff`**. Reviewers and agents must read files on disk to verify codegen — absence from the diff is normal.

| Pattern | Generator | Typical location |
|---------|-----------|------------------|
| `*.g.dart` | build_runner (JSON, copy_with_extension) | Same directory as source (e.g. `packages/core/lib/src/application/<feature>/<feature>_bloc.g.dart`) |
| `*.freezed.dart` | Freezed | `packages/models/` (not blocs) |
| `*.config.dart` | injectable | `packages/core/lib/src/get_it_injection.config.dart` |
| `*.gr.dart` | auto_route | `apps/multichoice/lib/app/engine/app_router.gr.dart` |
| `*.mocks.dart` | mockito | `packages/core/test/mocks.mocks.dart` |
| `strings*.g.dart` | slang | `apps/multichoice/lib/i18n/` — see [i18n.md](i18n.md) |

### Verifying codegen is up to date

1. Identify what source changed (bloc `part`, `@RoutePage`, `@injectable`, `MockSpec`, i18n keys).
2. Read the matching generated file on disk.
3. Confirm expected symbols/keys exist in the generated output.
4. Run `make db` / `melos slang` only if the file is missing or content is stale.

Do **not** flag “missing codegen” because `git status` shows no changes to `*.g.dart` / `*.gr.dart`.

## Dependency Injection

- `@injectable` / `@Injectable()` on blocs
- `@LazySingleton(as: I*)` on services and repositories
- Register via build_runner; resolve with `coreSl<T>()`

### What `@Injectable()` does *not* do

`@Injectable()` registers a **factory** in GetIt. It wires constructor dependencies only. It does **not**:

- Provide the bloc to the widget tree
- Close the bloc when a route is popped
- Make `coreSl<T>()` return a non-null “always there” instance in the UI layer

Every `coreSl<MyBloc>()` call creates a **new** bloc instance (unless you explicitly register a singleton, which page-scoped blocs should not use).

## Bloc lifecycle in pages

**Always** wrap page-scoped blocs in `BlocProvider` and resolve from DI in `create`:

```dart
return BlocProvider(
  create: (_) => coreSl<SearchBloc>(),
  child: _SearchView(...),
);
```

`BlocProvider` closes the bloc when its provider is disposed. **Do not** store blocs in nullable fields, null-check them in `build`, or call `bloc.close()` in `State.dispose`.

Use `BlocProvider.value` only when re-providing a bloc owned elsewhere (e.g. app-level `HomeBloc`, product tour).

Initial events belong in `create`:

```dart
create: (_) => coreSl<ProfileBloc>()..add(const ProfileLoadStarted()),
```

### Feature-flagged auth routes

For user-accounts pages, call `guardUserAccountsRoute(context)` in `initState` (same as `LoginPage`, `ResetPasswordPage`). Do **not** skip bloc creation with an early `return` — that forces nullable blocs and manual lifecycle code for no benefit.

## Bloc State

- `@CopyWith()` + `Equatable` (not Freezed for bloc states)
- Sealed events with `final class` variants
- `part` files: `{feature}_event.dart`, `{feature}_state.dart`, `{feature}_bloc.g.dart`

## Mocks

1. Add `MockSpec<I*>` to `packages/core/test/mocks.dart`
2. Run `make db` or `melos run rebuild:core`
3. Import `mocks.mocks.dart` in tests

## Exports

- New bloc → `packages/core/lib/src/application/export.dart`
- New repo interface → `packages/core/lib/src/repositories/export.dart`
