#210 - Workflows Updates

- Fix `rc-workflow` manual runs by allowing `preBuild` to run on `workflow_dispatch`.
- Add `dry_run` support to staging/production deploy steps to prevent accidental publish/commits.
- Change versioning flow to compute next version pre-build and commit the exact version only after a successful deploy.
- Expand `version-management` composite action to support compute-only mode (`commit_changes: false`) and committing a specified `target_version`.
- Remove unused rollback action and document the recommended versioning pattern in `.github/README.md`.