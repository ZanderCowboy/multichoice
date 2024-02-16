# multichoice

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
![GitHub License](https://img.shields.io/github/license/ZanderCowboy/multichoice)
![GitHub Release](https://img.shields.io/github/v/release/ZanderCowboy/multichoice)
![GitHub Tag](https://img.shields.io/github/v/tag/ZanderCowboy/multichoice)

![Linting](https://github.com/ZanderCowboy/multichoice/actions/workflows/linting_workflow.yml/badge.svg)
![Build](https://github.com/ZanderCowboy/multichoice/actions/workflows/build_workflow.yml/badge.svg)
![Deploy](https://github.com/ZanderCowboy/multichoice/actions/workflows/deploy_workflow.yml/badge.svg)

[![codecov](https://codecov.io/gh/ZanderCowboy/multichoice/graph/badge.svg?token=1DW57BV8D5)](https://codecov.io/gh/ZanderCowboy/multichoice)
## Setup

If permissions denied while running `flutter pub get` run the following

```sh
sudo chown -R ${whoami}:${whoami} /flutter
```

OR

```sh
sudo chown -R node:node /flutter
```

### PRs and Workflows

#### Versioning

- Every `PR` from `develop` into `main` needs to have either one of the following labels:
  - `patch`: Used for fixes, hot-fixes, and any form of patch
  - `minor`: Used for the release of one or more individual features
  - `major`: Used for major releases, or big UI and backend changes
  
  **Note: In case no label is provided for the PR (i.e. `unlabeled`), a `patch` will be used for release.**
