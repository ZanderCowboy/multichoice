part of 'profile_bloc.dart';

@CopyWith()
class ProfileState extends Equatable {
  const ProfileState({
    required this.email,
    required this.username,
    required this.isLoading,
    required this.isLoggedOut,
  });

  factory ProfileState.initial() => const ProfileState(
        email: null,
        username: null,
        isLoading: false,
        isLoggedOut: false,
      );

  final String? email;
  final String? username;
  final bool isLoading;
  final bool isLoggedOut;

  @override
  List<Object?> get props => [
        email,
        username,
        isLoading,
        isLoggedOut,
      ];
}
