part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
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
  const factory HomeEvent.onLongPressedDeleteEntry(
    int tabId,
    int entryId,
  ) = OnLongPressedDeleteEntry;

  const factory HomeEvent.onPressedDeleteAllEntries(int tabId) =
      OnPressedDeleteAllEntries;

  const factory HomeEvent.onPressedDeleteAll() = OnPressedDeleteAll;
}
