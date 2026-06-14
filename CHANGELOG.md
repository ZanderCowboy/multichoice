# Localization, App Icon, DevOps

- Completed slang string migration (#388): localized remaining presentation strings, nl feedback parity, forgot-password error mapping, and required dismiss tooltip on banner bars
- Documented GitHub App setup and protected-branch bypass for CI version commits (#215)
- Production workflow renamed to `production-workflow`; removed deprecated `release_type` input; optional `release_version` manual override with validation takes precedence over RC suffix removal (see #326)
- SonarCloud analysis now runs on pushes to `main` in addition to pull requests (see #350)
- Prod drawer shows semver-only version (`vX.Y.Z`); feedback submissions still include build number (see #216)
