# User Journey: Registration and Profile

## Feature Flag

All flows gated by Firebase Remote Config `enable_user_accounts` (`FirebaseConfigKeys.enableUserAccounts`).

- Helper: [`user_accounts_feature.dart`](../../../apps/multichoice/lib/utils/user_accounts_feature.dart)
- `isUserAccountsEnabled()` — checks `IFirebaseService.isEnabled`
- `guardUserAccountsRoute(context)` — pops route when flag off
- **Default**: flag off in production until QA enables in Firebase console

## Entry Points (flag on)

| Surface | File | Behavior |
|---------|------|----------|
| Home app bar | `profile_button.dart` | Profile icon (logged in) or Sign in |
| Home banner | `home_promotional_banners.dart` | Sign-up CTA for guests |
| Drawer | `home_drawer.dart` | Account section / Sign in tile |
| Login modal | `login_modal.dart` | `showLoginModal()` — shared entry |

## Routes ([`app_router.dart`](../../../apps/multichoice/lib/app/engine/app_router.dart))

- `LoginPageRoute`, `SignupPageRoute`
- `ForgotPasswordPageRoute`, `ResetPasswordPageRoute` (deep link / oob code)
- `ProfilePageRoute`, `AccountDeletionPageRoute`

Guarded routes call `guardUserAccountsRoute` on build when flag off.

## State and Services

- **RegistrationBloc** — sign-up, sign-in, Google sign-in
- **ResetPasswordBloc** — forgot/reset password
- **ProfileBloc** — load email/username, logout
- **IRegistrationRepository** → **IRegistrationService** (Firebase Auth)
- **ILoginService** — token storage, profile display fields

## Typical Flows

1. **Guest → Sign in**: profile button or drawer → login modal or `LoginPage` → home (logged in).
2. **Sign up**: banner or signup route → `SignupPage` → auth → home.
3. **Forgot password**: link from login → email → reset link → `ResetPasswordPage`.
4. **Profile**: logged-in user → `ProfilePage` → view email/username, logout, account deletion.

## Related Docs

- [`docs/login-implementation-guide.md`](../../../docs/login-implementation-guide.md)
- [`docs/implementing-login-with-google-signin.md`](../../../docs/implementing-login-with-google-signin.md)
