part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.onGetTabs() = OnGetTabs;

  const factory HomeEvent.onUpdateTab(Tabs tab) = OnUpdateTab;

  const factory HomeEvent.onPressedAddTab(
    String title,
    String subtitle,
  ) = OnPressedAddTab;

  const factory HomeEvent.onLongPressedDeleteTab(String tabId) =
      OnLongPressedDeleteTab;
}
