# 285 - Refactor - Remove freezed completely

- Removed Freezed package from application layer
- Replaced Freezed unions with Dart 3 sealed classes for events
- Replaced Freezed states with `@CopyWith()` from copy_with_extension
- Integrated Equatable package for state equality comparison
- Updated all 7 application blocs (changelog, details, feedback, firebase, home, product, search)
- Cleaned up configuration files and documentation
- Fixed child delete toggle in Details to derive visible children from an immutable source list.
