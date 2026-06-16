part of 'registration_bloc.dart';

@CopyWith()
class RegistrationState extends Equatable {
  const RegistrationState({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.isLoading,
    required this.isSuccess,
    required this.isError,
    required this.errorMessage,
    required this.needsUsernameSetup,
  });

  factory RegistrationState.initial() => const RegistrationState(
        email: '',
        username: '',
        password: '',
        confirmPassword: '',
        isLoading: false,
        isSuccess: false,
        isError: false,
        errorMessage: null,
        needsUsernameSetup: false,
      );

  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String? errorMessage;
  final bool needsUsernameSetup;

  @override
  List<Object?> get props => [
        email,
        username,
        password,
        confirmPassword,
        isLoading,
        isSuccess,
        isError,
        errorMessage,
        needsUsernameSetup,
      ];
}
