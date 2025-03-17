# Document Setting up App for Release

This document describes the process of how one can go about releasing an app to the Play Store.

It also details the process of how to get the app in a state ready for deploying a release.

## Setup

Visit [Dashboard](https://play.google.com/console/u/0/developers/8783535225973670504/app/4976133683768209199/app-dashboard?timespan=thirtyDays) and finish set up there.

### Create store listing

#### App Icon

Use the `DRAWIO` file with no border found at `play_store\app_icon_no_border.drawio` for the app icon. Export as `png`.

Then use `appicon.co` to generate a 512px x 512px image to be added a App Icon on the dashboard.

*Resources*:
- <https://www.appicon.co/#app-icon>
- <https://app.diagrams.net/>

#### Look into Feature Graphic

Create a feature graphic using `Canva` and add some of the screenshots.

<https://www.canva.com/design/DAGiAPel9fk/MMikIcNdzS6wRZWiU4KRkg/edit>

<div style="position: relative; width: 100%; height: 0; padding-top: 48.8281%;
 padding-bottom: 0; box-shadow: 0 2px 8px 0 rgba(63,69,81,0.16); margin-top: 1.6em; margin-bottom: 0.9em; overflow: hidden;
 border-radius: 8px; will-change: transform;">
  <iframe loading="lazy" style="position: absolute; width: 100%; height: 100%; top: 0; left: 0; border: none; padding: 0;margin: 0;"
    src="https://www.canva.com/design/DAGiAPel9fk/bEkj1rGHPNHHcxG99eiwmQ/view?embed" allowfullscreen="allowfullscreen" allow="fullscreen">
  </iframe>
</div>
<a href="https:&#x2F;&#x2F;www.canva.com&#x2F;design&#x2F;DAGiAPel9fk&#x2F;bEkj1rGHPNHHcxG99eiwmQ&#x2F;view?utm_content=DAGiAPel9fk&amp;utm_campaign=designshare&amp;utm_medium=embeds&amp;utm_source=link" target="_blank" rel="noopener">Feature Graphic</a> by Zander Kotze

*Resources*:
- <https://hotpot.ai/blog/how-to-make-feature-graphics>
- <https://www.norio.be/graphic-generator/#>
- <https://www.apptamin.com/blog/feature-graphic-play-store/>
- <https://developer.android.com/studio/debug/am-screenshot>
- <https://developer.android.com/studio/debug/device-file-explorer>

#### App Screenshots

In `Android Studio`, open different devices of the required screen size.

Use `Device Explorer` to share the `json` files with app data between devices to avoid having to recreate data.

Then `screenshot` different views of the app.

Upload these on the Dashboard.

### Closed Testing - Alpha

<https://play.google.com/console/u/0/developers/8783535225973670504/app/4976133683768209199/tracks/4698104785923137009?tab=countryAvailability>

### Create a Production Release
