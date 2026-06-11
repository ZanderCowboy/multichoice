import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.g.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._loginService,
    this._appStorageService,
  ) : super(ProfileState.initial()) {
    on<ProfileEvent>(_onEvent);
  }

  final ILoginService _loginService;
  final IAppStorageService _appStorageService;

  Future<void> _onEvent(
    ProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    switch (event) {
      case ProfileLoadStarted():
        await _handleLoadStarted(emit: emit);
      case ProfileLogoutRequested():
        await _handleLogoutRequested(emit: emit);
    }
  }

  Future<void> _handleLoadStarted({
    required Emitter<ProfileState> emit,
  }) async {
    emit(state.copyWith(isLoading: true));

    var email = await _loginService.getProfileEmail();
    final username = await _loginService.getProfileUsername();

    if (email == null || email.isEmpty) {
      email = await _appStorageService.lastUsedEmail;
    }

    emit(
      state.copyWith(
        isLoading: false,
        email: email,
        username: username,
      ),
    );
  }

  Future<void> _handleLogoutRequested({
    required Emitter<ProfileState> emit,
  }) async {
    emit(state.copyWith(isLoading: true));
    await _loginService.deleteLoginInfo();
    emit(
      state.copyWith(
        isLoading: false,
        isLoggedOut: true,
      ),
    );
  }
}
