part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();

  const factory HomeEvent.onGetTabs() = OnGetTabs;
  const factory HomeEvent.onGetTab(int tabId) = OnGetTab;
  const factory HomeEvent.onPressedAddTab() = OnPressedAddTab;
  const factory HomeEvent.onPressedAddEntry() = OnPressedAddEntry;
  const factory HomeEvent.onChangedTabTitle(String text) = OnChangedTabTitle;
  const factory HomeEvent.onChangedTabSubtitle(String text) =
      OnChangedTabSubtitle;
  const factory HomeEvent.onChangedEntryTitle(String text) =
      OnChangedEntryTitle;
  const factory HomeEvent.onChangedEntrySubtitle(String text) =
      OnChangedEntrySubtitle;
  const factory HomeEvent.onSubmitEditTab() = OnSubmitEditTab;
  const factory HomeEvent.onSubmitEditEntry() = OnSubmitEditEntry;
  const factory HomeEvent.onPressedCancel() = OnPressedCancel;
  const factory HomeEvent.onUpdateTabId(int id) = OnUpdateTabId;
  const factory HomeEvent.onUpdateEntry(int id) = OnUpdateEntry;
  const factory HomeEvent.onLongPressedDeleteTab(int tabId) =
      OnLongPressedDeleteTab;
  const factory HomeEvent.onLongPressedDeleteEntry(int tabId, int entryId) =
      OnLongPressedDeleteEntry;
  const factory HomeEvent.onPressedDeleteAllEntries(int tabId) =
      OnPressedDeleteAllEntries;
  const factory HomeEvent.onPressedDeleteAll() = OnPressedDeleteAll;
  const factory HomeEvent.refresh() = OnRefresh;
  const factory HomeEvent.onToggleEditMode() = OnToggleEditMode;
  const factory HomeEvent.onReorderTabs(int oldIndex, int newIndex) =
      OnReorderTabs;
  const factory HomeEvent.onReorderEntries(
    int tabId,
    int oldIndex,
    int newIndex, {
    required bool isGrid,
  }) = OnReorderEntries;

  const factory HomeEvent.onMoveEntryToTab(
    int entryId,
    int fromTabId,
    int toTabId,
    int insertIndex,
  ) = OnMoveEntryToTab;
}

final class OnGetTabs extends HomeEvent {
  const OnGetTabs();
}

final class OnGetTab extends HomeEvent {
  const OnGetTab(this.tabId);

  final int tabId;
}

final class OnPressedAddTab extends HomeEvent {
  const OnPressedAddTab();
}

final class OnPressedAddEntry extends HomeEvent {
  const OnPressedAddEntry();
}

final class OnChangedTabTitle extends HomeEvent {
  const OnChangedTabTitle(this.text);

  final String text;
}

final class OnChangedTabSubtitle extends HomeEvent {
  const OnChangedTabSubtitle(this.text);

  final String text;
}

final class OnChangedEntryTitle extends HomeEvent {
  const OnChangedEntryTitle(this.text);

  final String text;
}

final class OnChangedEntrySubtitle extends HomeEvent {
  const OnChangedEntrySubtitle(this.text);

  final String text;
}

final class OnSubmitEditTab extends HomeEvent {
  const OnSubmitEditTab();
}

final class OnSubmitEditEntry extends HomeEvent {
  const OnSubmitEditEntry();
}

final class OnPressedCancel extends HomeEvent {
  const OnPressedCancel();
}

final class OnUpdateTabId extends HomeEvent {
  const OnUpdateTabId(this.id);

  final int id;
}

final class OnUpdateEntry extends HomeEvent {
  const OnUpdateEntry(this.id);

  final int id;
}

final class OnLongPressedDeleteTab extends HomeEvent {
  const OnLongPressedDeleteTab(this.tabId);

  final int tabId;
}

final class OnLongPressedDeleteEntry extends HomeEvent {
  const OnLongPressedDeleteEntry(this.tabId, this.entryId);

  final int tabId;
  final int entryId;
}

final class OnPressedDeleteAllEntries extends HomeEvent {
  const OnPressedDeleteAllEntries(this.tabId);

  final int tabId;
}

final class OnPressedDeleteAll extends HomeEvent {
  const OnPressedDeleteAll();
}

final class OnRefresh extends HomeEvent {
  const OnRefresh();
}

final class OnToggleEditMode extends HomeEvent {
  const OnToggleEditMode();
}

final class OnReorderTabs extends HomeEvent {
  const OnReorderTabs(this.oldIndex, this.newIndex);

  final int oldIndex;
  final int newIndex;
}

final class OnReorderEntries extends HomeEvent {
  const OnReorderEntries(
    this.tabId,
    this.oldIndex,
    this.newIndex, {
    required this.isGrid,
  });

  final int tabId;
  final int oldIndex;
  final int newIndex;
  final bool isGrid;
}

final class OnMoveEntryToTab extends HomeEvent {
  const OnMoveEntryToTab(
    this.entryId,
    this.fromTabId,
    this.toTabId,
    this.insertIndex,
  );

  final int entryId;
  final int fromTabId;
  final int toTabId;
  final int insertIndex;
}
