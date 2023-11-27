part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.onPressedAddTab() = onPressedAddTab;

  const factory HomeEvent.onLongPressedDeleteTab() = onLongPressedDeleteTab;
}
