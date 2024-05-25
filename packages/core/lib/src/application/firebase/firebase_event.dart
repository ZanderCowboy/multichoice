part of 'firebase_bloc.dart';

@freezed
class FirebaseEvent with _$FirebaseEvent {
  const factory FirebaseEvent.onChangeColor(AppBarTitle color) = OnChangeColor;
}
