# [Set up Workflows](https://github.com/ZanderCowboy/multichoice/issues/27)

## Ticket: [27](https://github.com/ZanderCowboy/multichoice/issues/27)

### branch: `27-setup-workflows`

### Overview

This ticket is primarily responsible for setting up a fully functional `CI/CD` pipeline.

### What was done

- [X] Set up **Linting** with `linting_workflow.yml`
- [X] Set up **Test, Analyze, Build** with `build_workflow.yml`
- [X] Set up **Tag and Release** with `release_workflow.yml`
- [X] Set up **Deploy Apps** with `deploy_workflow.yml`
- [X] Created **Reusable workflows** for `building`
- [X] Created **Reusable workflows** for `deployments`
- [X] Added a `config.yml` file with configurations used by `build`, `release`, `deploy` in the root directory
- [X] Added `concurrency groups` to workflows to ensure that no conflicts arise when multiple workflows run at the same time
- [X] Set up **Reusable actions** to `set up Flutter` and `set up Java`
- [X] Created **Reusable actions** for `app versioning` and `auto commiting`

### What needs to be done

- [ ] Set up new `deploy` workflows, replicatas of the current `deploy_workflow.yml`, for (1) a `UAT` workflow, responsible for releases used in `internal testing` and (2) a workflow responsible for releases used in `production`
