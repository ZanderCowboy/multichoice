# Code Generation and DI

## Commands

| Task | Command |
|------|---------|
| Codegen | `make db` or `melos build` |
| Full rebuild | `make frb` or `make mr` |
| Scoped analyze | `melos exec --scope=<pkg> -- flutter analyze` |
| Core tests | `melos test:core` |
| App tests | `melos test:multichoice` |

## Generated Artifacts (do not hand-edit)

- `*.g.dart` — JSON, copy_with_extension
- `*.freezed.dart` — Freezed models (in `models`, not blocs)
- `*.config.dart` — injectable (`get_it_injection.config.dart`)
- `*.gr.dart` — auto_route
- `*.mocks.dart` — mockito (`packages/core/test/mocks.mocks.dart`)

## Dependency Injection

- `@injectable` / `@Injectable()` on blocs
- `@LazySingleton(as: I*)` on services and repositories
- Register via build_runner; resolve with `coreSl<T>()`

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
