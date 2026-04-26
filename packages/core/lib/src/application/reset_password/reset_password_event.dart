part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent {
  const ResetPasswordEvent();

  const factory ResetPasswordEvent.newPasswordChanged(String value) =
      ResetPasswordNewPasswordChanged;
  const factory ResetPasswordEvent.confirmPasswordChanged(String value) =
      ResetPasswordConfirmPasswordChanged;
  const factory ResetPasswordEvent.submitPressed({
    required bool isChangePassword,
    required String? oobCode,
  }) = ResetPasswordSubmitPressed;
  const factory ResetPasswordEvent.successConsumed() =
      ResetPasswordSuccessConsumed;
}

final class ResetPasswordNewPasswordChanged extends ResetPasswordEvent {
  const ResetPasswordNewPasswordChanged(this.value);

  final String value;
}

final class ResetPasswordConfirmPasswordChanged extends ResetPasswordEvent {
  const ResetPasswordConfirmPasswordChanged(this.value);

  final String value;
}

final class ResetPasswordSubmitPressed extends ResetPasswordEvent {
  const ResetPasswordSubmitPressed({
    required this.isChangePassword,
    required this.oobCode,
  });

  final bool isChangePassword;
  final String? oobCode;
}

final class ResetPasswordSuccessConsumed extends ResetPasswordEvent {
  const ResetPasswordSuccessConsumed();
}
