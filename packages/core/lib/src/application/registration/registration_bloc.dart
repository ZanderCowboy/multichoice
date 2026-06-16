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
    this._credentialValidationService,
    this._appStorageService,
    this._loginService,
  ) : super(RegistrationState.initial()) {
    on<RegistrationEvent>(_onEvent);
  }

  final IRegistrationRepository _registrationRepository;
  final ICredentialValidationService _credentialValidationService;
  final IAppStorageService _appStorageService;
  final ILoginService _loginService;

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
            confirmPassword: field == RegistrationField.confirmPassword
                ? value
                : state.confirmPassword,
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
    final emailError = _credentialValidationService.validateEmail(state.email);
    if (emailError != null) {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: emailError,
        ),
      );
      return;
    }

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

    final validationError = _credentialValidationService.validatePassword(
      state.password,
    );

    if (validationError != null) {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: validationError,
        ),
      );
      return;
    }

    final confirmError = _credentialValidationService
        .validatePasswordConfirmation(
          password: state.password,
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
          needsUsernameSetup: false,
        ),
      ),
    );
  }

  Future<void> _handleSignIn(Emitter<RegistrationState> emit) async {
    final identifierError = _credentialValidationService
        .validateLoginIdentifier(
          state.email,
        );
    if (identifierError != null) {
      emit(
        state.copyWith(
          isError: true,
          errorMessage: identifierError,
        ),
      );
      return;
    }

    final passwordError = _credentialValidationService.validatePasswordRequired(
      state.password,
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

    emit(state.copyWith(isLoading: true, isError: false, errorMessage: null));

    final resolvedEmail = await _loginService.resolveEmailForLogin(
      state.email.trim(),
    );
    if (resolvedEmail == null || resolvedEmail.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          isError: true,
          errorMessage: 'No account found for this username.',
        ),
      );
      return;
    }

    final result = await _registrationRepository.signIn(
      resolvedEmail,
      state.password,
    );

    result.fold(
      (AuthException error) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          isError: true,
          errorMessage: error.message,
          needsUsernameSetup: false,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          isError: false,
          errorMessage: null,
          needsUsernameSetup: false,
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
          needsUsernameSetup: false,
        ),
      ),
      (authResult) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          isError: false,
          errorMessage: null,
          needsUsernameSetup: authResult.needsUsernameSetup,
        ),
      ),
    );
  }
}
