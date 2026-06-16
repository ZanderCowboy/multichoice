# Workflows

This repository contains GitHub Actions workflows for managing the build and deployment process across different environments: develop, staging (RC), and production.

## Version Management

The versioning system follows semantic versioning (MAJOR.MINOR.PATCH+BUILD) with support for release candidates (RC).

### Recommended pattern (compute → deploy → commit)

To avoid “version bump” commits when a build/deploy fails, the recommended approach is:

- **Pre-build**: compute the next version and expose it as workflow outputs **without committing**.
- **Build/Deploy**: use the computed `version_part` + `build_number` to build and deploy artifacts.
- **Post-success**: after a successful deploy, **commit and push** the exact `version_number`, then create tags/releases from that commit.

If you ever switch back to “commit before deploy”, you’ll likely need a rollback mechanism again.

### Version Bumping

Version bumps are controlled through PR labels. Configuration lives in [`.github/config/version-labels.json`](config/version-labels.json).

| Bump | Labels (any one or aliases together) |
|------|--------------------------------------|
| major | `major` |
| minor | `minor`, `feature` |
| patch | `patch`, `bug` |
| build only | no version label (other labels like `documentation` are ignored) |
| skip deploy | `no-build` |

**Rules:**
- Aliases in the same tier (e.g. `patch` + `bug`, `minor` + `feature`) are valid and resolve to that tier.
- Cross-tier labels (e.g. `minor` + `patch`) fail the **PR Version Labels** check.
- `no-build` cannot be combined with any version bump label.
- `major` is only allowed on PRs into `rc`, not `develop`.

The [`pr_version_labels.yml`](workflows/pr_version_labels.yml) workflow validates labels on every PR to `develop` or `rc` before merge. Add **Validate Version Labels** as a required status check on those branches.

### Version Suffixes

- RC (Release Candidate) suffix is automatically added in the staging workflow
- RC suffix is removed when promoting to production

## Workflow Overview

### Develop Workflow

- #### Triggers
  - PR closure to `develop` branch
  - Manual trigger via `workflow_dispatch`
- Supports manual trigger via workflow_dispatch
- Runs tests, analysis, and builds Android app
- Uploads APK to Firebase App Distribution
- Creates AAB artifact
- Version bumping based on PR labels (patch, minor)

### Staging (RC) Workflow

- #### Triggers
  - PR closure to `rc` branch
  - Manual trigger via `workflow_dispatch`
- Supports manual trigger via workflow_dispatch
- Runs tests, analysis, and builds Android app
- Creates AAB artifact
- Uploads to Google Play internal track
- Adds RC suffix to version
- Version bumping based on PR labels (major, minor, patch)

### Production Workflow (`production-workflow`)

- #### Triggers
  - Manual trigger via `workflow_dispatch`
- Reads RC version from pubspec and strips `-RC` suffix (semantic bumps happen in staging)
- Optional `release_version` input overrides semver with validated `X.Y.Z`
- Runs tests, analysis, and builds Android app
- Creates both APK and AAB artifacts
- Uploads to Google Play production track
- Creates GitHub Release with version-only tag (`vX.Y.Z`)

## Common Features Across Workflows

### Pre-build Steps

- Version management
- GitHub App token generation
- Label validation
- Version bumping based on PR labels

### Build Steps

- Flutter and Java setup
- Core package coverage testing
- Codecov integration
- Android keystore setup
- Secrets file generation
- APK/AAB building
- Artifact uploads

### Post-build Steps

- Tag creation
- Version updates in pubspec.yaml
- Google Play Store deployment (where applicable)

## Concurrency Control

- All workflows implement concurrency control
- Prevents multiple builds from running simultaneously
- Cancels in-progress builds when new ones are triggered

## Security

- Uses a dedicated GitHub App (`VERSION_BOT_APP_ID` / `VERSION_BOT_APP_PRIVATE_KEY`) to commit version bumps to protected branches — see [Protected Branch and GitHub App setup](../docs/protected-branch-and-github-app.md)
- Securely handles Android keystore and secrets
- Implements proper permission scopes for GitHub Actions

## Artifacts

- APK files for direct installation
- AAB files for Google Play Store submission
- Coverage reports for code quality monitoring

## Linting Workflow

## Build Workflow

- Runs with every closed PR into develop
- Has workflow_dispatch
- Concurrency

- Only runs when the PR has been merged OR if there is no 'no-build' label
- Runs on ubuntu-latest

preBuild
- Checks out repo
action=app_versioning
- Uses 'stikkyapp/update-pubspec-version@v1' to bump version
- Updates the pubspec file
- Uploads the pubspec file
- Echos the new version

- Reads the config
- Extracts build flag and environment (true and release)
- Downloads pubspec file

build
- Runs on ubuntu-latest
- checks out repo
- sets up Java and Flutter
- Runs melos coverage:core
- Uploads coverage
- Runs dart analysis
<- Get latest tag
<- Get current version from pubspec.yaml
<- Generate GitHub App Token
<- Update version in pubspec.yaml
- Downloads pubspec file
- Downloads Android Keystore.jks file
- Create key.properties
- Decode DEV/PROD config and google-services B64 secrets (see docs/environment-config.md)
- Builds appbundle
- Builds APK
- Uploads AAB artifact
- Uploads APK to Firebase
<- Create new tag

postBuild
- Runs on ubuntu-latest
- Checks out repo
- Uses 'stefanzweifel/git-auto-commit-action@v5' to bump and commit
