part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.onFetchAll() = OnFetchAll;

  const factory HomeEvent.onGetTabs() = OnGetTabs;

  const factory HomeEvent.onGetAllEntryCards() = OnGetAllEntryCards;

  const factory HomeEvent.onGetEntryCards(int tabId) = OnGetEntryCards;

  const factory HomeEvent.onPressedAddTab() = OnPressedAddTab;

  const factory HomeEvent.onPressedAddEntry(int tabId) = OnPressedAddEntry;

  const factory HomeEvent.onLongPressedDeleteTab(int tabId) =
      OnLongPressedDeleteTab;

  const factory HomeEvent.onLongPressedDeleteEntry(
    int tabId,
    int entryId,
  ) = OnLongPressedDeleteEntry;

  const factory HomeEvent.onPressedDeleteAll() = OnPressedDeleteAll;

  const factory HomeEvent.onChangedTabTitle(String text) = OnChangedTabTitle;
  const factory HomeEvent.onChangedTabSubtitle(String text) =
      OnChangedTabSubtitle;
  const factory HomeEvent.onChangedEntryTitle(String text) =
      OnChangedEntryTitle;
  const factory HomeEvent.onChangedEntrySubtitle(String text) =
      OnChangedEntrySubtitle;

  const factory HomeEvent.onEditTab() = OnEditTab;
  const factory HomeEvent.onEditEntry() = OnEditEntry;

  const factory HomeEvent.onPressedCancelTab() = OnPressedCancelTab;
  const factory HomeEvent.onPressedCancelEntry() = OnPressedCancelEntry;

  const factory HomeEvent.onUpdateTab(int tabId) = OnUpdateTab;
  const factory HomeEvent.onUpdateEntry(int tabId, int entryId) = OnUpdateEntry;
}
