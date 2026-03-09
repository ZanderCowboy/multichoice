# Workflows

This repository contains GitHub Actions workflows for managing the build and deployment process across different environments: develop, staging (RC), and production.

## Version Management

The versioning system follows semantic versioning (MAJOR.MINOR.PATCH+BUILD) with support for release candidates (RC).

### Version Bumping

Version bumps are controlled through PR labels:
- `major`: Increments the major version (1.0.0 -> 2.0.0)
- `minor`: Increments the minor version (1.0.0 -> 1.1.0)
- `patch`: Increments the patch version (1.0.0 -> 1.0.1)
- `no-build`: Skips version bumping

### Version Suffixes

- RC (Release Candidate) suffix is automatically added in the staging workflow
- RC suffix is removed when promoting to production

## Workflow Overview

### Develop Workflow

- Triggered on PR closure to `develop` branch
- Supports manual trigger via workflow_dispatch
- Runs tests, analysis, and builds Android app
- Uploads APK to Firebase App Distribution
- Creates AAB artifact
- Version bumping based on PR labels (patch, minor)

### Staging (RC) Workflow

- Triggered on PR closure to `rc` branch
- Supports manual trigger via workflow_dispatch
- Runs tests, analysis, and builds Android app
- Creates AAB artifact
- Uploads to Google Play internal track
- Adds RC suffix to version
- Version bumping based on PR labels (major, minor, patch)

### Production Workflow

- Triggered on PR closure to `main` branch from `rc`
- Supports manual trigger via workflow_dispatch
- Runs tests, analysis, and builds Android app
- Creates both APK and AAB artifacts
- Removes RC suffix from version
- Uploads to Google Play production track (currently commented out)

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

- Uses GitHub App tokens for authentication
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
- Create secrets.dart
- Builds appbundle
- Builds APK
- Uploads AAB artifact
- Uploads APK to Firebase
<- Create new tag

postBuild
- Runs on ubuntu-latest
- Checks out repo
- Uses 'stefanzweifel/git-auto-commit-action@v5' to bump and commit
