import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';
part 'reset_password_bloc.g.dart';

@injectable
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
      case ResetPasswordSubmitPressed(
        :final isChangePassword,
        :final oobCode,
      ):
        await _handleSubmit(
          emit: emit,
          isChangePassword: isChangePassword,
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
      final result = await _registrationRepository.updatePassword(password);
      result.fold(
        (error) => emit(
          state.copyWith(
            isLoading: false,
            isError: true,
            errorMessage: error.message,
          ),
        ),
        (_) => _emitSuccess(emit, isChangePassword: true),
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
        (_) => _emitSuccess(emit, isChangePassword: false),
      );
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));
    _emitSuccess(emit, isChangePassword: false);
  }

  void _emitSuccess(
    Emitter<ResetPasswordState> emit, {
    required bool isChangePassword,
  }) {
    emit(
      state.copyWith(
        isLoading: false,
        isError: false,
        errorMessage: null,
        successMessage: isChangePassword
            ? 'Password changed successfully!'
            : 'Password reset successfully!',
        shouldNavigateOnSuccess: true,
      ),
    );
  }
}
