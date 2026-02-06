#118 - Add Remote Config to Codebase

- Add `FirebaseService` in core package for Firebase Remote Config management
- Add `FirebaseConfigKeys` enum in models package for type-safe config keys
- Support automatic JSON to model conversion via `getConfig<T>()`
- Support feature flags via `isEnabled()` 
- Support strings via `getString()`
- Auto-initialize service in bootstrap