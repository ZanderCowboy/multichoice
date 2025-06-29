# CHANGELOG

Version: 0.3.0+156:
- Write documentation for finalizaing Play Store release
- Create feature graphic
- Take screenshots of the app on multiple devices
- Add testing files - found under 'apps\multichoice\test\data'
- Made changes to the UI to be more readable
- Update .gitignore
- More changes to UI to deal with both Vertical and Horizontal Modes
- Rename VerticalTab to CollectionTab
- Rename Cards to Items

Setting up Integration Testing:
- Create documentation (refer to `docs/setting-up-integration-tests.md`)
- start cmd /k "run_integration_test.bat %* && call shutdown_emulator.bat && exit"

---
Version 0.3.0+153:
- Setup and add widget tests
- Update melos scripts
- Refactor and clean up code
- Create 'WidgetKeys` class

---
Version 0.3.0+140:
- Added 'data_exchange_service' to import/export data
- Update 'home_drawer', added assets and flutter_gen, and cleaned up code
- Added a 'delete_modal' and update files
    => 'entry_card'
    => 'menu_widget'
    => 'vertical_tab'
- Update 'app_theme' for listTiles
- Update 'melos.dart'
- Add 'data_transfer_page' for import/export
- Add 'tooltip_enums' for maintainability
- Add permission request dialog for the 'home_page'
- Update 'AndroidManifest' for permission
- Update 'home_page' to save check for permissions
- Update 'data_transfer_page' to conditionally render export button if db is empty or not
- Update 'data_exchange_service' to allow the user to append or overwrite to existing data

Version 0.1.4+128:
- Fix horizontal layout not working
- Change the 'add entry' card to align with entry cards in horizontal mode
- Add validator to validate user input and trim whitespaces
- Add new colors for enabled/disabled buttons
- Update drawer 'delete all' button with enabled/disabled colors

Version 0.1.4+124:
- Added more padding around icon to avoid cutoffs
- Reworked custom app icon
- Moved `deleteAll` button to drawer and replaced with a `Search` button (not implemented yet)
- Added SliverPadding to have initial padding around tabs, but falls away as user scrolls

---
Version 0.1.4+119:
- Added a change log
- Added custom launcher icons
- Designed a custom icon with drawio

Version 0.1.4+117:
- Earlier version details
