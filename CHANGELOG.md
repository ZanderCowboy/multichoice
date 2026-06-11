#User Accounts - Feature Flagged Profile And Registration

- Added `ProfileBloc` in core for profile load and logout flows
- Refactored profile page to BLoC and extracted shared `ShineCard` widget
- Gated sign-in, sign-up, password, and profile flows behind Remote Config `enable_user_accounts` (default false)
- Added route guards and entry-point hiding for auth/profile when the flag is off
- Added `ProfileBloc` unit tests and user-accounts feature-flag widget tests
