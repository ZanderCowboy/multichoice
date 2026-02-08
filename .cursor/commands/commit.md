Always create smaller, logical commits from staged and unstaged changes. Group files by functionality and create separate commits for each group. Never create a single large commit - always break changes into multiple smaller commits.

## Process

1. **Exclude files**: Never commit files matching:
   - `.cursor/plans/*.plan.md`
   - `debug-log-*.md`
   - Any other debug or plan files

2. **Check git status** to see what files have changed

3. **Group changes** into logical commits based on file patterns. Create a separate commit for each group that has changes:

   **Group 1: UI Constants & Spacing**
   - `packages/ui_kit/lib/src/constants/*.dart`
   - Commit message: `feat(ui): <describe spacing/constant changes>`

   **Group 2: Android/iOS Platform**
   - `apps/multichoice/android/**/*`
   - `apps/multichoice/ios/**/*`
   - Commit message: `feat(android|ios): <describe platform change>`

   **Group 3: Core BLoC/State Management**
   - `packages/core/lib/src/application/**/*_bloc.dart`
   - `packages/core/lib/src/application/**/*_event.dart`
   - `packages/core/lib/src/application/**/*_state.dart`
   - Commit message: `feat(<feature>): <describe bloc changes>`

   **Group 4: Repository Layer**
   - `packages/core/lib/src/repositories/**/*.dart`
   - Commit message: `feat(repository): <describe repository changes>`

   **Group 5: Service Layer**
   - `packages/core/lib/src/services/**/*.dart`
   - Commit message: `feat(service): <describe service changes>`

   **Group 6: Details Page**
   - `apps/multichoice/lib/presentation/details/**/*.dart`
   - Commit message: `feat(details): <describe details changes>`

   **Group 7: Layout Components**
   - `apps/multichoice/lib/layouts/**/*.dart`
   - Commit message: `feat(layout): <describe layout changes>`

   **Group 8: Home Widgets**
   - `apps/multichoice/lib/presentation/home/**/*.dart`
   - Commit message: `feat(home): <describe home changes>`

   **Group 9: Edit Pages**
   - `apps/multichoice/lib/presentation/edit/**/*.dart`
   - Commit message: `refactor(edit): <describe edit changes>`

   **Group 10: Add Widgets**
   - `apps/multichoice/lib/presentation/shared/widgets/add_widgets/**/*.dart`
   - Commit message: `refactor(add): <describe add widget changes>`

   **Group 11: Other Presentation Pages**
   - `apps/multichoice/lib/presentation/**/*.dart` (excluding already grouped)
   - Commit message: `refactor(presentation): <describe presentation changes>`

   **Group 12: Models**
   - `packages/models/**/*.dart`
   - Commit message: `feat(models): <describe model changes>`

   **Group 13: Tests**
   - `**/*_test.dart`
   - `**/*_test.mocks.dart`
   - Commit message: `test(<scope>): <describe test changes>`

   **Group 14: Configuration & Build**
   - `pubspec.yaml`
   - `melos.yaml`
   - `Makefile`
   - `*.yaml` (config files)
   - Commit message: `chore: <describe config changes>`

4. **For each group that has changes**:
   - Stage only files in that group (excluding plan/debug files)
   - Create a commit with an appropriate message
   - Use conventional commit format: `type(scope): description`
   - Analyze the actual changes in the files to create descriptive commit messages

5. **Commit message guidelines**:
   - Use `feat` for new features
   - Use `fix` for bug fixes
   - Use `refactor` for code restructuring
   - Use `test` for test changes
   - Use `chore` for maintenance tasks
   - Keep descriptions concise but descriptive
   - Base the message on the actual diff content, not just file names

6. **After all commits**, show a summary with `git log --oneline -N` where N is the number of commits created.

## Important Rules

- **ALWAYS create multiple smaller commits** - never combine unrelated changes into one commit
- If a file matches multiple groups, place it in the most specific group
- If only one group has changes, still create that single commit (but it should be small and focused)
- Always verify no plan/debug files are included before committing
- Use `git add <specific files>` to stage files for each group individually
- Don't push commits unless explicitly asked
- Review the actual changes in files to write meaningful commit messages
