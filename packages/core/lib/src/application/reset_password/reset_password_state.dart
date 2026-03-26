part of 'reset_password_bloc.dart';

@CopyWith()
class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    required this.newPassword,
    required this.confirmPassword,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
    required this.successMessage,
    required this.shouldNavigateOnSuccess,
  });

  factory ResetPasswordState.initial() => const ResetPasswordState(
    newPassword: '',
    confirmPassword: '',
    isLoading: false,
    isError: false,
    errorMessage: null,
    successMessage: null,
    shouldNavigateOnSuccess: false,
  );

  final String newPassword;
  final String confirmPassword;
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final String? successMessage;
  final bool shouldNavigateOnSuccess;

  @override
  List<Object?> get props => [
    newPassword,
    confirmPassword,
    isLoading,
    isError,
    errorMessage,
    successMessage,
    shouldNavigateOnSuccess,
  ];
}
