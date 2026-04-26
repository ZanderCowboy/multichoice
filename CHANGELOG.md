#310 - Add Update Modal

- Show a floating update prompt when `latest_app_version` is newer than the installed version.
- Prevent OS back from dismissing the update prompt.
- Open the Play Store via Remote Config `google_play_store_url`.
- Add debug actions to refetch Remote Config and trigger the update prompt.
- Prefer scoped `flutter analyze` (via `melos exec --scope=...` or Makefile targets) over full `melos analyze`.

#316 - Remove Licences from UX

- Remove the default “View licenses” entry from the About dialog.
- Add a session-only “Developer mode” multi-tap unlock to access Licences when needed.
