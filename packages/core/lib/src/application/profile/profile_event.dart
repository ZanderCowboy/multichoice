part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();

  const factory ProfileEvent.loadStarted() = ProfileLoadStarted;
  const factory ProfileEvent.logoutRequested() = ProfileLogoutRequested;
}

final class ProfileLoadStarted extends ProfileEvent {
  const ProfileLoadStarted();
}

final class ProfileLogoutRequested extends ProfileEvent {
  const ProfileLogoutRequested();
}
