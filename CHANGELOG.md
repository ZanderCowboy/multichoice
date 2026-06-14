# Localization, App Icon, DevOps

- Implemented slang localization: en/nl string catalogs, `TranslationProvider` wiring, Android locale config, and migrated remaining presentation strings (see #372, #388)
- Production workflow renamed to `production-workflow`; removed deprecated `release_type` input; optional `release_version` manual override with validation takes precedence over RC suffix removal (see #326)
- SonarCloud analysis now runs on pushes to `main` in addition to pull requests (see #350)
- Prod drawer shows semver-only version (`vX.Y.Z`); feedback submissions still include build number (see #216)
