import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';
part 'reset_password_bloc.g.dart';

@Injectable()
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc(
    this._registrationRepository,
    this._credentialValidationService,
  ) : super(ResetPasswordState.initial()) {
    on<ResetPasswordEvent>(_onEvent);
  }

  final IRegistrationRepository _registrationRepository;
  final ICredentialValidationService _credentialValidationService;

  Future<void> _onEvent(
    ResetPasswordEvent event,
    Emitter<ResetPasswordState> emit,
  ) async {
    switch (event) {
      case ResetPasswordNewPasswordChanged(:final value):
        emit(
          state.copyWith(
            newPassword: value,
            isError: false,
            errorMessage: null,
          ),
        );
      case ResetPasswordConfirmPasswordChanged(:final value):
        emit(
          state.copyWith(
            confirmPassword: value,
            isError: false,
            errorMessage: null,
          ),
        );
      case ResetPasswordCurrentPasswordChanged(:final value):
        emit(
          state.copyWith(
            currentPassword: value,
            isError: false,
            errorMessage: null,
          ),
        );
      case ResetPasswordSubmitPressed(
        :final isChangePassword,
        :final isSetPassword,
        :final oobCode,
      ):
        await _handleSubmit(
          emit: emit,
          isChangePassword: isChangePassword,
          isSetPassword: isSetPassword,
          oobCode: oobCode,
        );
      case ResetPasswordSuccessConsumed():
        emit(
          state.copyWith(
            shouldNavigateOnSuccess: false,
          ),
        );
    }
  }

  Future<void> _handleSubmit({
    required Emitter<ResetPasswordState> emit,
    required bool isChangePassword,
    required bool isSetPassword,
    required String? oobCode,
  }) async {
    final passwordError = _credentialValidationService.validatePassword(
      state.newPassword,
    );
    if (passwordError != null) {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: passwordError,
        ),
      );
      return;
    }

    final confirmError = _credentialValidationService
        .validatePasswordConfirmation(
          password: state.newPassword,
          confirmation: state.confirmPassword,
        );
    if (confirmError != null) {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: confirmError,
        ),
      );
      return;
    }

    if (isChangePassword && !isSetPassword) {
      final currentPasswordError = _credentialValidationService
          .validatePasswordRequired(
            state.currentPassword,
          );
      if (currentPasswordError != null) {
        emit(
          state.copyWith(
            isError: true,
            errorMessage: currentPasswordError,
          ),
        );
        return;
      }
    }

    emit(
      state.copyWith(
        isLoading: true,
        isError: false,
        errorMessage: null,
        successMessage: null,
        shouldNavigateOnSuccess: false,
      ),
    );

    final password = state.newPassword;

    if (isChangePassword) {
      if (isSetPassword) {
        final result = await _registrationRepository.linkPassword(password);
        result.fold(
          (error) => emit(
            state.copyWith(
              isLoading: false,
              isError: true,
              errorMessage: error.message,
            ),
          ),
          (_) =>
              _emitSuccess(emit, isChangePassword: true, isSetPassword: true),
        );
        return;
      }

      final reauthResult = await _registrationRepository
          .reauthenticateWithPassword(state.currentPassword);
      var reauthFailed = false;
      reauthResult.fold(
        (error) {
          reauthFailed = true;
          emit(
            state.copyWith(
              isLoading: false,
              isError: true,
              errorMessage: error.message,
            ),
          );
        },
        (_) {},
      );
      if (reauthFailed) {
        return;
      }

      final result = await _registrationRepository.updatePassword(password);
      result.fold(
        (error) => emit(
          state.copyWith(
            isLoading: false,
            isError: true,
            errorMessage: error.message,
          ),
        ),
        (_) => _emitSuccess(emit, isChangePassword: true, isSetPassword: false),
      );
      return;
    }

    if (oobCode != null && oobCode.isNotEmpty) {
      final result = await _registrationRepository.confirmPasswordReset(
        oobCode: oobCode,
        newPassword: password,
      );

      result.fold(
        (error) => emit(
          state.copyWith(
            isLoading: false,
            isError: true,
            errorMessage: error.message,
          ),
        ),
        (_) =>
            _emitSuccess(emit, isChangePassword: false, isSetPassword: false),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage:
            'This reset link is invalid or missing. Request a new reset email.',
      ),
    );
  }

  void _emitSuccess(
    Emitter<ResetPasswordState> emit, {
    required bool isChangePassword,
    required bool isSetPassword,
  }) {
    final successMessage = isChangePassword
        ? (isSetPassword
              ? 'Password set successfully!'
              : 'Password updated successfully!')
        : 'Password reset successfully!';

    emit(
      state.copyWith(
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: successMessage,
        shouldNavigateOnSuccess: true,
      ),
    );
  }
}
