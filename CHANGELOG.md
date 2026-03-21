#333 - Implement Signup And Login Pages Only

- Add sign-in, sign-up, forgot password, and reset password flows plus reusable registration widgets and validators
- Add `AuthNotifier`, `Session` DI registration, and `i_login_service` export for auth state and persisted login
- Add profile and account deletion pages; home app bar Sign In / Profile, drawer profile and logout, and login modal
- Add debug page (tools, optional app colors view, auth debug override) and open it from app version in debug builds
- Add `AsyncFilledButton`, `AsyncOutlinedButton`, and `CircularLoader.tiny` in ui_kit with tests
- Register auth, profile, and related routes in the app router
