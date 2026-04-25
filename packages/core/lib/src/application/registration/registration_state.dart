part of 'registration_bloc.dart';

@CopyWith()
class RegistrationState extends Equatable {
  const RegistrationState({
    required this.email,
    required this.username,
    required this.password,
    required this.isLoading,
    required this.isSuccess,
    required this.isError,
    required this.errorMessage,
  });

  factory RegistrationState.initial() => const RegistrationState(
        email: '',
        username: '',
        password: '',
        isLoading: false,
        isSuccess: false,
        isError: false,
        errorMessage: null,
      );

  final String email;
  final String username;
  final String password;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        email,
        username,
        password,
        isLoading,
        isSuccess,
        isError,
        errorMessage,
      ];
}
