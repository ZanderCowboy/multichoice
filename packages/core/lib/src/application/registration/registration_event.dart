part of 'registration_bloc.dart';

enum RegistrationField {
  email,
  username,
  password,
}

sealed class RegistrationEvent {
  const RegistrationEvent();

  const factory RegistrationEvent.fieldsChanged({
    required RegistrationField field,
    required String value,
  }) = RegistrationFieldsChanged;
  const factory RegistrationEvent.signupClicked() = RegistrationSignupClicked;
  const factory RegistrationEvent.signInClicked() = RegistrationSignInClicked;
  const factory RegistrationEvent.googleSignInClicked() =
      RegistrationGoogleSignInClicked;
  const factory RegistrationEvent.cancelClicked() = RegistrationCancelClicked;
  const factory RegistrationEvent.prefillRequested() =
      RegistrationPrefillRequested;
  /// Clears form state for sign-up so no prior login email is shown.
  const factory RegistrationEvent.signupFormOpened() =
      RegistrationSignupFormOpened;
}

final class RegistrationPrefillRequested extends RegistrationEvent {
  const RegistrationPrefillRequested();
}

final class RegistrationFieldsChanged extends RegistrationEvent {
  const RegistrationFieldsChanged({
    required this.field,
    required this.value,
  });

  final RegistrationField field;
  final String value;
}

final class RegistrationSignupClicked extends RegistrationEvent {
  const RegistrationSignupClicked();
}

final class RegistrationSignInClicked extends RegistrationEvent {
  const RegistrationSignInClicked();
}

final class RegistrationGoogleSignInClicked extends RegistrationEvent {
  const RegistrationGoogleSignInClicked();
}

final class RegistrationCancelClicked extends RegistrationEvent {
  const RegistrationCancelClicked();
}

final class RegistrationSignupFormOpened extends RegistrationEvent {
  const RegistrationSignupFormOpened();
}
