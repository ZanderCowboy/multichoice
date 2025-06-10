# Feature: Guided App Tour

- Create new enums for `storage_keys` and `product_tour_step`s
- Update pubspec package versions (might be a breaking change)
- Create `app_storage_service` to save the state and values of the app
- Update `firebase_options` to use .env file along with build_workflow
- Update `home_bloc` and `product_bloc`
- Create `ProductTourController`
- Create `showcase_data`
- Has complete feature, might be buggy. NOTE: There needs to be at least one collection and one item entry.
- TODO: Ensure that the app loads with dummy data
- TODO: Ensure that if the user follows the tutorial, save any existing data, load dummy data, run tutorial, and afterwards, restore user data.

- Create and update cursor rules
- Complete refactor and improve of the HomeDrawer
- Refactor light-dark and layout switch to use new AppStorageService
- Implement the tour for the horizontal layout.

- NOTE!!! On the app version in debug mode, long-press to clear app app-state data
- Add new dedicated Tutorial page
- Trigger
