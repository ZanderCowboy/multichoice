# Glossary

| Term | Meaning |
|------|---------|
| **Tab** | Top-level category/container for choices (Isar model) |
| **Entry** | A single choice/item within a tab |
| **DTO** | Data transfer object in `packages/models` (API/auth payloads) |
| **Bloc** | State container in `packages/core/.../application/` |
| **Repository** | Data access boundary; interface in `repositories/interfaces/` |
| **Service** | External or platform integration (Auth, storage, Firebase) |
| **Wrapper** | Thin adapter around a third-party SDK (file picker, etc.) |
| **Controller** | Non-bloc orchestration (e.g. product tour) |
| **coreSl** | GetIt service locator for `packages/core` |
| **Melos** | Monorepo tool for bootstrap, test, and exec across packages |
| **Remote Config** | Firebase feature flags and JSON strings |
| **Product tour** | Guided onboarding highlighting UI elements |
| **Either** | `dartz` `Either<Exception, T>` for auth/repository results |
| **auto_route** | Declarative routing; `@RoutePage()` on pages |
| **slang** | i18n codegen; JSON locale files → `strings.g.dart` |
| **localizeCoreMessage** | App helper mapping core English strings to `context.t` |
