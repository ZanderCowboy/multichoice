# multichoice

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
![GitHub Release](https://img.shields.io/github/v/release/ZanderCowboy/multichoice)
![GitHub Tag](https://img.shields.io/github/v/tag/ZanderCowboy/multichoice)

![Linting](https://github.com/ZanderCowboy/multichoice/actions/workflows/linting_workflow.yml/badge.svg)
![Build](https://github.com/ZanderCowboy/multichoice/actions/workflows/build_workflow.yml/badge.svg)
![Deploy](https://github.com/ZanderCowboy/multichoice/actions/workflows/deploy_workflow.yml/badge.svg)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ZanderCowboy_multichoice&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=ZanderCowboy_multichoice)
[![codecov](https://codecov.io/gh/ZanderCowboy/multichoice/graph/badge.svg?token=1DW57BV8D5)](https://codecov.io/gh/ZanderCowboy/multichoice)
![GitHub License](https://img.shields.io/github/license/ZanderCowboy/multichoice)

## Setup

If permissions denied while running `flutter pub get` run the following

```sh
sudo chown -R ${whoami}:${whoami} /flutter
```

OR

```sh
sudo chown -R node:node /flutter
```

### Platforms

This project is specifically meant for `Android`, `Web`, and `Windows`. Run this command
```sh
flutter config --list
```
to enable/disable any needed platforms.

## PRs and Workflows

### Versioning

- Every `PR` from `develop` into `main` needs to have either one of the following labels:
  - `patch`: Used for fixes, hot-fixes, and any form of patch
  - `minor`: Used for the release of one or more individual features
  - `major`: Used for major releases, or big UI and backend changes
  
  **Note: In case no label is provided for the PR (i.e. `unlabeled`), a `patch` will be used for release.**

#### Flow

Linting
ON PUSH - ANY BRANCH
ON PR - ANY BRANCH

Building
ON PR - FROM FEATURE TO DEVELOP

Tag and Release
ON PR - FROM DEVELOP TO MAIN

Deploy
ON PUSH - TO MAIN

## Websites and Links

[![SonarCloud](https://sonarcloud.io/images/project_badges/sonarcloud-white.svg)](https://sonarcloud.io/summary/new_code?id=ZanderCowboy_multichoice)
