part of 'profile_bloc.dart';

@CopyWith()
class ProfileState extends Equatable {
  const ProfileState({
    required this.email,
    required this.username,
    required this.isLoading,
    required this.isLoggedOut,
    required this.hasPasswordProvider,
  });

  factory ProfileState.initial() => const ProfileState(
        email: null,
        username: null,
        isLoading: false,
        isLoggedOut: false,
        hasPasswordProvider: true,
      );

  final String? email;
  final String? username;
  final bool isLoading;
  final bool isLoggedOut;
  final bool hasPasswordProvider;

  @override
  List<Object?> get props => [
        email,
        username,
        isLoading,
        isLoggedOut,
        hasPasswordProvider,
      ];
}
