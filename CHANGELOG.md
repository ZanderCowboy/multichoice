#340 - Rework Theming

- Split theme data into `theme_data/` (light/dark colors, text themes, `ThemeData`) and simplify `AppPalette` to flat static colors
- Add `AppColorsExtension` and `AppTextExtension` in theme package; update extension getters for theme access
- Refactor `AppTypography` and wire typography via theme extensions instead of direct `AppTypography` usage
- Add debug tools: app colors viewer and app text themes viewer, accessible from debug page
- Update home, details, drawer, changelog, and shared widgets to use new theme extensions
