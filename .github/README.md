# Workflows

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
