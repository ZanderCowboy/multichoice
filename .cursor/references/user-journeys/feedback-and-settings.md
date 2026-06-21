# User Journey: Feedback and Settings

## Feedback

- **Route**: `FeedbackPageRoute` (drawer).
- **Bloc**: `FeedbackBloc` in `packages/core/lib/src/application/feedback/`.
- **Repository**: `IFeedbackRepository` — Firestore submission.
- **Rate limit**: `IAppStorageService.canSubmitMoreFeedbackToday()` (max 5/day).
- **Images**: optional when `feedback_images_enabled` Remote Config flag is on.

### Image attachments (when flag is on)

Two add paths in [`feedback_form.dart`](../../../apps/multichoice/lib/presentation/feedback/widgets/feedback_form.dart):

| Action | Entry point | Flow |
|--------|-------------|------|
| **Add Images** | `FilePicker` (`_pickImage`) | Picked files → `FeedbackEvent.imageAdded` |
| **Paste Screenshot** | `_pasteImageFromClipboard` | `ScreenshotImageReader.readImageBytes()` → `PlatformFile` bytes → same event |

**Validation** (both paths): `FeedbackBloc` enforces `FeedbackImageLimits` in `packages/core` — max **3** images, **5 MB** each. Failures surface via bloc error messages localized in the app.

### Paste screenshot (Android)

App-only platform bridge — not in `packages/core`.

| Layer | Path |
|-------|------|
| Dart API | `apps/multichoice/lib/utils/screenshot_image_reader.dart` |
| MethodChannel | `co.za.zanderkotze.multichoice/screenshot_image` |
| Native | `android/.../ScreenshotImageReader.kt` (registered from `MainActivity.kt`) |

**Read order (native):**

1. System clipboard — content URIs and inline bitmap items (PNG/JPEG/WebP/GIF).
2. Fallback: most recent screenshot in MediaStore (≤ 3 minutes old; helps Samsung/One UI where clipboard is empty after capture).

**Permissions:** Dart requests `Permission.photos` before calling native code (MediaStore fallback).

**UX / i18n:** `feedback.pasteScreenshot`, `noImageInClipboard`, `clipboardReadFailed` (en/nl).

**Scope:** Android-only today. Non-Android platforms get `MissingPluginException` → null bytes → “No image found in clipboard” snackbar. Do not reintroduce `super_clipboard` without explicit approval.

## Changelog

- **Route**: `ChangelogPageRoute`.
- **Bloc**: `ChangelogBloc`.
- **Data**: Remote Config JSON key `changelog` (`FirebaseConfigKeys.changelog`).
- **Page flag**: `enable_changelog_page` must be enabled.

## About

- **Route**: `AboutPageRoute`.
- URLs and contact from Remote Config: Instagram, website, email, privacy, terms, acknowledgements.

## Data Transfer (Export/Import)

- **Route**: `DataTransferScreenRoute`.
- Backup and restore user data (tabs/entries).
- Service: data exchange patterns in `packages/core`.

## Debug (DEV flavor only)

- **Route**: `DebugPageRoute` (`AppFlavor.allowsDebugPage`).
- **Feature Flags tab**: toggle Remote Config bool flags via `RemoteConfigDebugNotifier`; refetch + clear-all overrides.
- See [architecture/feature-flags.md](../architecture/feature-flags.md#debug-overrides-dev-only).

## Settings Pattern

No single settings screen; secondary flows live in drawer (about, changelog, data transfer, tutorial, feedback).

## Related Docs

- [`docs/178-implement-in-app-feedback.md`](../../../docs/178-implement-in-app-feedback.md)
