#211 - Add Changelog Page in App

- Add `ChangelogPage` to display version history from Firebase Remote Config
- Add `Changelog` and `ChangelogEntry` models for changelog data structure
- Add `IChangelogRepository` interface and `ChangelogRepository` implementation
- Add `ChangelogBloc` for state management with loading, error, and success states
- Add `changelog` key to `FirebaseConfigKeys` enum
- Add changelog navigation item in drawer's "More" section
- Sort versions by semantic versioning (newest first) in repository
