part of 'firebase_bloc.dart';

@freezed
class FirebaseState with _$FirebaseState {
  const factory FirebaseState({
    required String color,
  }) = _FirebaseState;

  factory FirebaseState.initial() => FirebaseState(
        color: '',
      );
}
