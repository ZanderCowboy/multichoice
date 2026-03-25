import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'registration_event.dart';
part 'registration_state.dart';
part 'registration_bloc.g.dart';

@Injectable()
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc(
    this._registrationRepository,
    this._passwordService,
    this._appStorageService,
  ) : super(RegistrationState.initial()) {
    on<RegistrationEvent>(_onEvent);
  }

  final IRegistrationRepository _registrationRepository;
  final IPasswordService _passwordService;
  final IAppStorageService _appStorageService;

  Future<void> _onEvent(
    RegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    switch (event) {
      case RegistrationFieldsChanged(:final field, :final value):
        emit(
          state.copyWith(
            email: field == RegistrationField.email ? value : state.email,
            username: field == RegistrationField.username
                ? value
                : state.username,
            password: field == RegistrationField.password
                ? value
                : state.password,
            isError: false,
            errorMessage: null,
          ),
        );
        break;
      case RegistrationSignupClicked():
        await _handleSignup(emit);
        break;
      case RegistrationSignInClicked():
        await _handleSignIn(emit);
        break;
      case RegistrationGoogleSignInClicked():
        await _handleGoogleSignIn(emit);
        break;
      case RegistrationCancelClicked():
        emit(RegistrationState.initial());
        break;
      case RegistrationPrefillRequested():
        await _handlePrefill(emit);
        break;
      case RegistrationSignupFormOpened():
        emit(RegistrationState.initial());
        break;
    }
  }

  Future<void> _handlePrefill(Emitter<RegistrationState> emit) async {
    final email = await _appStorageService.lastUsedEmail;
    if (email != null && email.isNotEmpty) {
      emit(state.copyWith(email: email));
    }
  }

  Future<void> _handleSignup(Emitter<RegistrationState> emit) async {
    final validationError = _passwordService.validate(state.password);
    if (validationError != null) {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: validationError,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, isError: false, errorMessage: null));

    final dto = SignupRequestDTO(
      email: state.email.trim(),
      username: state.username.trim(),
      password: state.password,
    );

    final result = await _registrationRepository.signUp(dto);

    result.fold(
      (AuthException error) => emit(
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

  Future<void> _handleSignIn(Emitter<RegistrationState> emit) async {
    final email = state.email.trim();
    if (email.isEmpty) {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: 'Email is required',
        ),
      );
      return;
    }

    if (state.password.isEmpty) {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: 'Password is required',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, isError: false, errorMessage: null));

    final result = await _registrationRepository.signIn(
      email,
      state.password,
    );

    result.fold(
      (AuthException error) => emit(
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

  Future<void> _handleGoogleSignIn(Emitter<RegistrationState> emit) async {
    emit(state.copyWith(isLoading: true, isError: false, errorMessage: null));

    final result = await _registrationRepository.signInWithGoogle();

    result.fold(
      (AuthException error) => emit(
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
