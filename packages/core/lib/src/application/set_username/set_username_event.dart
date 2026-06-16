part of 'set_username_bloc.dart';

sealed class SetUsernameEvent {
  const SetUsernameEvent();

  const factory SetUsernameEvent.usernameChanged(String value) =
      SetUsernameChanged;
  const factory SetUsernameEvent.submitted() = SetUsernameSubmitted;
}

final class SetUsernameChanged extends SetUsernameEvent {
  const SetUsernameChanged(this.value);

  final String value;
}

final class SetUsernameSubmitted extends SetUsernameEvent {
  const SetUsernameSubmitted();
}
