# 425 - Play Photo Picker Policy

## Feedback — images

- **Paste Screenshot** is removed
- Attach images only via **Add Images** (system photo picker)
- App should **not** request Photos / media library access for feedback
- Still capped at **3 images**, **5 MB** each — verify limit messages still appear
- Feature flag `feedback_images_enabled` still gates the Add Images button

## Android — permissions

- Fresh install should not prompt for broad photo/media access for feedback
- App installs and launches normally on Android devices

## Regression smoke tests

- Submit feedback with and without images (Add Images only)
- Create, edit, reorder, and delete tab entries
- Language selection (System / English / Nederlands) in drawer
