part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.onGetTabs() = OnGetTabs;

  const factory HomeEvent.onGetTab(int tabId) = OnGetTab;

  const factory HomeEvent.onPressedAddTab(
    String title,
    String subtitle,
  ) = OnPressedAddTab;

  const factory HomeEvent.onPressedAddEntry(
    int tabId,
    String title,
    String subtitle,
  ) = OnPressedAddEntry;

  const factory HomeEvent.onLongPressedDeleteTab(int tabId) =
      OnLongPressedDeleteTab;

  const factory HomeEvent.onLongPressedDeleteEntry(
    int tabId,
    int entryId,
  ) = OnLongPressedDeleteEntry;

  const factory HomeEvent.onPressedDeleteAll() = OnPressedDeleteAll;
}