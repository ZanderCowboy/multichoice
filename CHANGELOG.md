# 183 - Implement Search Functionality

## New Features

- Access the SearchPage on the HomePage.
- Create unified CircularLoader used across app.
- Update backend: Create new SearchResult model, repository, and bloc.
- BUGGY: From SearchPage, tapping on search results, should navigate back to HomePage and highlight item/collection. Some items that too deep in the list (not the first few items/collections) is has difficulty finding.
- Adding new items or collections ensures that it's in view.
- Tapping on Item or Collection, navigates to the DetailsPage

## Bug Fixes

- Avoid HomePage rebuilding when new collections/items are added.
- Fix AppVersion being cut-off by the device navigation buttons.
- Add check to make the user can not double tap the FeedbackPage title for dev logging.
- Remove duplicate/unused Items class.
- In light mode, adding a new entry, add button text is vague.
- Add failsafe to ensure no blank collections/items can be stored in database.
