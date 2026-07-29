# Play Console — Android permissions before publish

When **adding or changing sensitive Android permissions** (especially photo/video, location, SMS, etc.), complete the matching **App content** declarations in Google Play Console **before** uploading or publishing a release.

CI can upload the AAB successfully and still fail at **Committing the Edit** with:

```text
Error: All developers requesting access to the photo and video permissions are required
to tell Google Play about the core functionality of their app
```

## What to do

### 1. Open the right place in Play Console

Use the **prod** app (`co.za.zanderkotze.multichoice`), not DEV, unless CI failed on the dev package.

Left menu → **Policy and programs** → **App content**  
Direct pattern: `https://play.google.com/console/developers/{dev_id}/app/{app_id}/app-content`

On that page, look for (names vary slightly):

| What to look for | Notes |
|------------------|--------|
| **Action required** / **To do** tab at the top | Often where pending declarations live |
| **Photo and video permissions** | Under App content cards |
| **Sensitive app permissions** → **Permissions Declaration Form** | Older/alternate label for the same thing |
| **App permissions** | Some accounts show it here after a bundle is uploaded |

If everything shows **Complete** / “You’re all caught up” but CI still fails, expand every section on App content anyway — the photo/video form sometimes only appears after Google has seen an AAB with the permission ([Play help](https://support.google.com/googleplay/android-developer/answer/9214102)).

### 2. If you still don’t see Photo and video permissions

Google usually only surfaces the form **after** it detects `READ_MEDIA_IMAGES` / `READ_MEDIA_VIDEO` in an uploaded bundle ([policy FAQ](https://support.google.com/googleplay/android-developer/answer/14115180)).

Because CI failed at **Committing the Edit**, the bundle may have uploaded without unlocking the declaration UI. Force it:

1. **Release** → **Testing** → **Internal testing** (or the track CI uses)
2. **Create new release**
3. **Upload the `.aab` manually** in the browser (same build CI produced)
4. Save the release draft (you don’t have to roll out yet)
5. Wait a few minutes, then refresh **App content**

Also check **Policy status** (left menu) and the account **Inbox** for a direct link to the declaration.

### 3. Check all tracks

Any **active or paused** track with an older bundle that still declares `READ_MEDIA_IMAGES` can block publish until the declaration is done — including internal/closed/open testing ([Stack Overflow thread](https://stackoverflow.com/questions/79383234)).

### 4. Complete the form, then publish

Fill in use case (feedback screenshot paste), how to test, and a short screen recording if asked. Then re-run CI or roll out the release.

Do this **before** expecting a Play upload/publish to succeed — not only after CI fails.

## Feedback screenshot flow (current)

Feedback paste uses clipboard read, then a MediaStore fallback for recent screenshots (Samsung/One UI). That requires `READ_MEDIA_IMAGES` in the manifest and a Play Console **Photo and video permissions** declaration before publish.

There is no supported way to keep the automatic Samsung-style fallback without this permission — the system photo picker is the Play-policy alternative, but it changes the paste UX.

## Related docs

- [play-console-prod-store-listing.md](../../../docs/play-console-prod-store-listing.md)
- [play-console-dev-internal-testing.md](../../../docs/play-console-dev-internal-testing.md)
- [feedback-and-settings.md](../user-journeys/feedback-and-settings.md) — paste screenshot journey
