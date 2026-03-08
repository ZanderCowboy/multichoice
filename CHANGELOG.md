# 289 - BUG - Multiple UI/UX Issues

- Address Haptic Feedback issue by changing to `HapticFeedback.vibrate();` instead of `HapticFeedback.mediumImpact();`
- Fix PopScope closing app instead of closing drawer, exits edit mode
  - Change HomePage from Stateless to Stateful for drawer close
  - Refactor home_page.dart into smaller files
- Fix data not refreshing when navigating back to HomePage
