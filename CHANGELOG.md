# 2 - Add Arrow Up Icon on Columns to go to Top

- Added a shared `useScrollToStartIndicator` hook for tab layouts to control
  when the "scroll to start" button is visible.
- Added an accessible reusable scroll-to-start button widget with `Semantics`
  and `Tooltip` labels for both vertical and horizontal tabs.
- Updated vertical tabs to show an up-arrow action (`Scroll to top`) after the
  user scrolls down, with animated scrolling back to the start.
- Updated horizontal tabs to show a left-arrow action (`Scroll to start`) and
  use the header width as the visibility threshold so the arrow appears only
  once the header has moved out of view.
- Refactored tab layout files to share scroll-indicator behavior across
  `vertical_tab.dart` and `horizontal_tab.dart`.
