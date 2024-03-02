part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.onFetchAll() = OnFetchAll;

  const factory HomeEvent.onGetTabs() = OnGetTabs;

  const factory HomeEvent.onGetEntryCards(int tabId) = OnGetEntryCards;

  const factory HomeEvent.onPressedAddTab() = OnPressedAddTab;

  const factory HomeEvent.onPressedAddEntry() = OnPressedAddEntry;

  const factory HomeEvent.onLongPressedDeleteTab(int tabId) =
      OnLongPressedDeleteTab;

  const factory HomeEvent.onLongPressedDeleteEntry(
    int tabId,
    int entryId,
  ) = OnLongPressedDeleteEntry;

  const factory HomeEvent.onPressedDeleteEntries(int id) =
      OnPressedDeleteEntries;
  const factory HomeEvent.onPressedDeleteAll() = OnPressedDeleteAll;

  const factory HomeEvent.onChangedTabTitle(String text) = OnChangedTabTitle;
  const factory HomeEvent.onChangedTabSubtitle(String text) =
      OnChangedTabSubtitle;
  const factory HomeEvent.onChangedEntryTitle(String text) =
      OnChangedEntryTitle;
  const factory HomeEvent.onChangedEntrySubtitle(String text) =
      OnChangedEntrySubtitle;

  const factory HomeEvent.onPressedEditTab() = OnPressedEditTab;
  const factory HomeEvent.onPressedEditEntry() = OnPressedEditEntry;

  const factory HomeEvent.onPressedCancelTab() = OnPressedCancelTab;
  const factory HomeEvent.onPressedCancelEntry() = OnPressedCancelEntry;

  const factory HomeEvent.onUpdateTab(int tabId) = OnUpdateTab;
  const factory HomeEvent.onUpdateTabId(int id) = OnUpdateTabId;
  const factory HomeEvent.onUpdateEntry(int tabId, int entryId) = OnUpdateEntry;
}
