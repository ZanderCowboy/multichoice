part of 'firebase_bloc.dart';

@CopyWith()
class FirebaseState extends Equatable {
  const FirebaseState({
    required this.color,
  });

  factory FirebaseState.initial() => const FirebaseState(
    color: '',
  );

  final String color;

  @override
  List<Object?> get props => [color];
}
