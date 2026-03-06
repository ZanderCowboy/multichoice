part of 'firebase_bloc.dart';

@CopyWith()
class FirebaseState {
  const FirebaseState({
    required this.color,
  });

  factory FirebaseState.initial() => const FirebaseState(
    color: '',
  );

  final String color;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FirebaseState && other.color == color;
  }

  @override
  int get hashCode => color.hashCode;
}
