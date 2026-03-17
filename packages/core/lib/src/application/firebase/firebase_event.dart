part of 'firebase_bloc.dart';

sealed class FirebaseEvent {
  const FirebaseEvent();

  const factory FirebaseEvent.onChangeColor(AppBarTitle color) = OnChangeColor;
}

final class OnChangeColor extends FirebaseEvent {
  const OnChangeColor(this.color);

  final AppBarTitle color;
}
