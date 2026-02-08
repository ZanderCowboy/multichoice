#7 - Implement Draggable

- Add `order` field to `Tabs` model and `TabsDTO` for persistent collection ordering
- Add `isEditMode` boolean flag to `HomeState` to toggle drag-and-drop mode
- Add `OnToggleEditMode`, `OnReorderTabs`, and `OnReorderEntries` events to `HomeEvent`
- Implement reorder handlers in `HomeBloc` with immediate UI updates and database persistence
- Add pencil/tick toggle button in AppBar to enter/exit edit mode
- Implement `ReorderableListView` for collections in both horizontal and vertical layouts
- Implement `SliverReorderableList` and `ReorderableListView` for entries within tabs
- Add drag handle icons that appear on collections and entries in edit mode
- Update `TabsRepository` to sort by `order` field and add `updateTabsOrder` method
- Update `EntryRepository` to respect `entryIds` order and add `updateEntriesOrder` method
- Disable navigation and menu interactions when in edit mode
- Add `AlwaysScrollableScrollPhysics` to reorderable lists for better drag behavior
