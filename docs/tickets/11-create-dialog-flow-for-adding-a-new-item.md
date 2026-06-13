# [Create dialog flow for adding a New Item](https://github.com/ZanderCowboy/multichoice/issues/11)

## Ticket: [11](https://github.com/ZanderCowboy/multichoice/issues/11)

### branch: `11-create-dialog-flow-for-adding-a-new-item`

### Overview

This ticket was to add the necessary and required widgets to the dialog for adding a Tab or an Entry

### What was done

- [X] Added `TextFormField`s to the add dialog for tabs and entries
- [X] Cleared up `HomeBloc` of unnecessary emits and values
- [X] Added `onChanged` events for add dialog, as well as `onPressedCancel`
- [X] Added `getTab` and `getEntry` to tabs_repository and entry_repository respectively
- [X] UI Changes
- [X] Fixed UI bug: The dialog to add new tabs and entries had a render overflow error
- [X] Add `MenuAnchor` with options to `Tabs` in upper right corner
- [X] Fix bug where adding a new entry with no subtitle, it uses the previously added entry's values
- [X] Add validation to ensure that 'blank' items can't be added by fading out `Add` button
- [X] Fix bug where `menu delete option` does not do a state change. Possibly the `tabs` state being empty
- [X] Implement the `rename` functionality for [#76](https://github.com/ZanderCowboy/multichoice/issues/76)
- [X] Add confirmation dialog to pop up when delete option is selected in menu
- [X] Added `Auto Router` and implemented it in the code base
- [X] Add validation to make sure that entry and tab `title`s are not empty
- [X] Add `menu item` for tabs to `clear entries`
- [X] Create Edit Page for Entries
- [X] Add menu options to entries
- [X] Multiple refactorings to use new decoupled files structure
- [X] Deleting tabs from the `menu` does not render correctly everytime
- [X] Adding new entries use data from previous entry added
