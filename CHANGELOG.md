#7 - Implement Draggable Retry - PART 1

- Add `order` field to `Tabs` model and `TabsDTO` for persistent collection ordering and drag-and-drop support
- Add `isEditMode` flag and drag/reorder events to `HomeState`/`HomeEvent`, with reorder handlers in `HomeBloc` that use optimistic UI updates and rollback on failure
- Implement `ReorderableListView` / `SliverReorderableList` for collections and entries in both horizontal and vertical layouts, including drag handles and disabled navigation while editing
- Update `TabsRepository` and `EntryRepository` to sort by `order` and persist tab and entry ordering
- Refine details, edit, home, search, tutorial, and feedback pages to integrate the new drag/edit flows and improve UX
- Rework editing overlay when in editing mode and added delete option.
- Make `FirebaseService` accept an injectable `FirebaseRemoteConfig` for improved testability
- Expand and update unit tests for blocs and services (home, details, product, search, data exchange, Firebase) to cover draggable and retry behavior
- Adjust Android, iOS, and web splash/background colors and metadata to match updated branding
- Apply shared spacing constants and minor layout refactors for more consistent spacing and readability
- Add `SafeArea`s to deal with app behind system navigation bar
- Remove elevation behind Collections and Items for better UI
