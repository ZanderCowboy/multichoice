# Multichoice – Landing Webpage

A simple static landing page for the Multichoice app, deployed to
[https://zandercowboy.github.io/multichoice/](https://zandercowboy.github.io/multichoice/).

## Structure

```
apps/webpage/
├── index.html          # Landing page (HTML + CSS + JS)
└── assets/
    ├── icon.png                  # App icon (512 × 512)
    ├── screenshot_home_dark.png  # Home view – dark theme
    ├── screenshot_home_light.png # Home view – light theme
    └── screenshot_details.png    # Item details view
```

## Firebase Remote Config

The **Google Play** button URL is fetched at runtime from
[Firebase Remote Config](https://firebase.google.com/docs/remote-config) using
the key **`play_store_url`**. If Remote Config is unavailable the page falls
back to the hard-coded Play Store URL.

## Deployment

The page is automatically deployed to the `gh-pages` branch via the
[`pages_workflow.yml`](../../.github/workflows/pages_workflow.yml) GitHub
Actions workflow whenever files under `apps/webpage/` are updated on `main`.

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `FIREBASE_API_KEY` | Firebase Web API key |
| `FIREBASE_AUTH_DOMAIN` | Firebase auth domain |
| `FIREBASE_PROJECT_ID` | Firebase project ID |
| `FIREBASE_STORAGE_BUCKET` | Firebase storage bucket |
| `FIREBASE_MESSAGING_SENDER_ID` | Firebase messaging sender ID |
| `FIREBASE_APP_ID` | Firebase web app ID |
