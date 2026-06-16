part of 'set_username_bloc.dart';

@CopyWith()
class SetUsernameState extends Equatable {
  const SetUsernameState({
    required this.username,
    required this.isLoading,
    required this.isSuccess,
    required this.isError,
    required this.errorMessage,
  });

  factory SetUsernameState.initial() => const SetUsernameState(
        username: '',
        isLoading: false,
        isSuccess: false,
        isError: false,
        errorMessage: null,
      );

  final String username;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        username,
        isLoading,
        isSuccess,
        isError,
        errorMessage,
      ];
}
