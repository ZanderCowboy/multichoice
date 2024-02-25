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

### What needs to be done

- [ ] Add `MenuAnchor` with options to `Tabs` in upper right corner
- [ ] Fix bug where adding a new entry with no subtitle, it uses the previously added entry's values
- [ ] Add validation to ensure that 'blank' items can't be added by fading out `Add` button
