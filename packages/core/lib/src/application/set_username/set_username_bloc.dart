import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'set_username_event.dart';
part 'set_username_state.dart';
part 'set_username_bloc.g.dart';

@Injectable()
class SetUsernameBloc extends Bloc<SetUsernameEvent, SetUsernameState> {
  SetUsernameBloc(
    this._registrationRepository,
    this._credentialValidationService,
  ) : super(SetUsernameState.initial()) {
    on<SetUsernameEvent>(_onEvent);
  }

  final IRegistrationRepository _registrationRepository;
  final ICredentialValidationService _credentialValidationService;

  Future<void> _onEvent(
    SetUsernameEvent event,
    Emitter<SetUsernameState> emit,
  ) async {
    switch (event) {
      case SetUsernameChanged(:final value):
        emit(
          state.copyWith(
            username: value,
            isError: false,
            errorMessage: null,
          ),
        );
      case SetUsernameSubmitted():
        await _handleSubmit(emit);
    }
  }

  Future<void> _handleSubmit(Emitter<SetUsernameState> emit) async {
    final usernameError = _credentialValidationService.validateUsername(
      state.username,
    );
    if (usernameError != null) {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: usernameError,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, isError: false, errorMessage: null));

    final result = await _registrationRepository.setUsername(
      state.username.trim(),
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          isError: true,
          errorMessage: error.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          isError: false,
          errorMessage: null,
        ),
      ),
    );
  }
}
