# GitHub Workflows

This folder documents the active GitHub Actions workflows for linting, `develop`, RC staging, and production release.

## Quick Index

- Linting: `.github/workflows/linting_workflow.yml`
- Develop: `.github/workflows/develop_workflow.yml`
- Staging (RC): `.github/workflows/staging_workflow.yml`
- Production: `.github/workflows/production_workflow.yml`

## Versioning Model

Supported version shapes:

```text
Standard: X.Y.Z+BUILD
RC:       X.Y.Z-RC+BUILD
```

Policy summary:

- `develop` uses labels for semantic bumping (`feature`/`bug`) plus build bump.
- `staging` (RC) bumps **build only** and keeps the `-RC` suffix.
- `production` removes `-RC`, bumps build number by `+1`, and does **not** perform semantic major/minor/patch bumps.

## Workflow Details

### 1) Linting and Analysis

**File:** `.github/workflows/linting_workflow.yml`

#### Develop Triggers

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches: ["**"]
  workflow_dispatch:
```

#### What It Does

- Runs `melos analyze`
- Runs `melos coverage:all`
- Merges LCOV files
- Uploads merged coverage to Codecov

### 2) Develop Workflow

**File:** `.github/workflows/develop_workflow.yml`

#### Staging Triggers

```yaml
on:
  pull_request:
    branches: ["develop"]
    types: [closed]
  workflow_dispatch:
    inputs:
      bump_type:
        type: choice
        options: [none, patch, minor]
```

#### PR Path Behavior

- Runs only when PR is merged and does not contain `no-build`.
- Label mapping:

```text
feature -> minor + build bump
bug     -> patch + build bump
none    -> build bump only
```

- If both labels exist, `feature` wins.

#### Manual Path Behavior

- Uses `workflow_dispatch` input `bump_type` (`none|patch|minor`).

#### Production Build and Release Actions

- Builds APK + AAB
- Uploads APK to Firebase App Distribution
- Creates full tag (`X.Y.Z(+/-RC)+BUILD`)

### 3) Staging (RC) Workflow

**File:** `.github/workflows/staging_workflow.yml`

#### Triggers

```yaml
on:
  pull_request:
    branches: [main]
    types: [opened, synchronize, reopened, ready_for_review]
  workflow_dispatch:
    inputs:
      target_branch:
        type: string
```

#### RC Guard

- PR flow continues only when `github.head_ref` starts with `rc`.
- Supported branch examples:

```text
rc
rc/1
rc/2026-03
rc-1
rc-feature-freeze
rc_1
rc_hotfix
rc/mobile/stabilization
```

#### Version and Build Actions

```text
bump_type: none
suffix:    -RC
result:    build number increments, RC suffix preserved
```

#### Delivery

- Builds AAB
- Uploads to Google Play `internal` track
- Creates RC full tag

### 4) Production Workflow

**File:** `.github/workflows/production_workflow.yml`

#### Trigger

```yaml
on:
  workflow_dispatch:
    inputs:
      release_type:        # legacy compatibility input
      target_branch:
      skip_github_release:
```

#### Version Derivation

Reads latest RC tag in this format:

```text
vX.Y.Z-RC+N
```

Transforms to:

```text
X.Y.Z+(N+1)
```

Example:

```text
v1.3.7-RC+155 -> 1.3.7+156
```

#### Build and Release Actions

- Uses `.github/actions/tokenized-commit` to update `pubspec.yaml`
- Builds APK + AAB
- Uploads AAB to Google Play `production` track
- Creates standard tag (`X.Y.Z+BUILD`)
- Optionally creates GitHub release and uploads APK artifact

## Shared Composite Actions

### `setup-flutter-with-java`

**File:** `.github/actions/setup-flutter-with-java/action.yml`

- Sets up Flutter tooling and Java for workflow jobs.

### `prepare-android-release-files`

**File:** `.github/actions/prepare-android-release-files/action.yml`

- Decodes keystore
- Writes `key.properties`
- Creates `apps/multichoice/lib/auth/secrets.dart`
- Creates and validates `google-services.json`

### `check-version-labels`

**File:** `.github/actions/check-version-labels/action.yml`

- Resolves bump type from labels
- Supports `feature`, `bug`, and `no-build`

### `version-management`

**File:** `.github/actions/version-management/action.yml`

- Applies version/build updates and pushes to the target branch.

### `tokenized-commit`

**File:** `.github/actions/tokenized-commit/action.yml`

- Updates `pubspec.yaml`, commits, and pushes using GitHub App token.

## Operational Notes

- Concurrency groups are enabled to reduce conflicting runs.
- Coverage + Codecov are owned by the linting workflow.
- Keep this file in sync whenever workflow triggers or versioning rules change.
