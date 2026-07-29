# 413 - Hotfix v0.13.2 RC

## Feedback — paste screenshot (Android)

- **Paste Screenshot** attaches an image from the clipboard (PNG, JPEG, WebP, GIF)
- After taking a screenshot, paste should work even when the clipboard appears empty (Samsung / One UI)
- App may request **Photos** permission the first time you paste
- Still capped at **3 images**, **5 MB** each — verify limit messages still appear
- Empty clipboard or read failure shows a snackbar (no crash)
- **Add Images** (file picker) still works as before

## Remote Config — first launch

- On a **fresh install**, verify feature flags match Firebase without needing an app restart:
  - Tutorial visibility
  - Update prompt
  - About page vs simple about dialog
  - Feedback image attachments (Add Images / Paste Screenshot buttons)

## Android — install & permissions

- App installs and launches on **16 KB page-size** devices (Android 15+)
- No regression on standard page-size devices

## Regression smoke tests

- Create, edit, reorder, and delete tab entries
- Import / export data
- Language selection (System / English / Nederlands) in drawer
- Submit feedback with and without images

- Trigger comment