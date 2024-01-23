part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.onGetTabs() = OnGetTabs;

  // TODO(@ZanderCowboy): Remove Tabs instance, and rather pass Tabs parameters
  const factory HomeEvent.onPressedAddTab(Tabs tab) = OnPressedAddTab;

  const factory HomeEvent.onLongPressedDeleteTab(String tabId) =
      OnLongPressedDeleteTab;
}
