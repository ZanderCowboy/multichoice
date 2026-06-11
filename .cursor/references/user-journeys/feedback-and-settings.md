# User Journey: Feedback and Settings

## Feedback

- **Route**: `FeedbackPageRoute` (drawer).
- **Bloc**: `FeedbackBloc` in `packages/core/lib/src/application/feedback/`.
- **Repository**: `IFeedbackRepository` — Firestore submission.
- **Rate limit**: `IAppStorageService.canSubmitMoreFeedbackToday()` (max 5/day).
- **Images**: optional when `feedback_images_enabled` Remote Config flag is on.

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

## Debug (dev)

- **Route**: `DebugPageRoute` — internal tools, feature flag overrides in debug builds.

## Settings Pattern

No single settings screen; secondary flows live in drawer (about, changelog, data transfer, tutorial, feedback).

## Related Docs

- [`docs/178-implement-in-app-feedback.md`](../../../docs/178-implement-in-app-feedback.md)
