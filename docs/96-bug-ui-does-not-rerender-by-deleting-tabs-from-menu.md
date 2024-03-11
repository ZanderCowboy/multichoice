# [Bug UI does not Rerender when a Tab is Deleted from Menu](https://github.com/ZanderCowboy/multichoice/issues/96)

## Ticket: [96](https://github.com/ZanderCowboy/multichoice/issues/96)

### branch: `96-bug-ui-does-not-rerender-by-deleting-tabs-from-menu`

### Overview

This was a bug issue where the UI code was rewritten to make sure there is a solid understanding of `BLoC` and state management

### What was done

- [X] Added Mockito to pubspec.yaml
- [X] Added `tabs_repository_test.dart`
- [X] Rewrote the UI code and did cleanup
- [X] Merged changes from #98 into this branch and refactored issues
- [X] Update [#11](https://github.com/ZanderCowboy/multichoice/issues/11) after merging this branch and refactor codebase accordingly

### Resources

- [TDD with Flutter Repository, Bloc](https://danielllewellyn.medium.com/test-driven-development-with-flutter-repository-bloc-938d87a4d205)
- Note when dealing with `Equal Unmodifiable Lists`
```dart
        //List.from<inty>(ab?.entryIds)
        //[...tab?.entryIds ?? []];
```
