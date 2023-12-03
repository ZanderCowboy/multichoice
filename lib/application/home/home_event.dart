part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.onPressedAddTab(VerticalTab verticalTab) =
      onPressedAddTab;

  const factory HomeEvent.onLongPressedDeleteTab() = onLongPressedDeleteTab;
}
