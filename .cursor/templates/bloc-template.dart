// Bloc template — replace <Feature> / <feature> with your feature name.
// Create folder: packages/core/lib/src/application/<feature>/
// Files: <feature>_bloc.dart, <feature>_event.dart, <feature>_state.dart
// After @CopyWith: run `make db` for <feature>_bloc.g.dart
// Export: packages/core/lib/src/application/export.dart

// ========== <feature>_bloc.dart ==========
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part '<feature>_event.dart';
part '<feature>_state.dart';
part '<feature>_bloc.g.dart';

@injectable
class <Feature>Bloc extends Bloc<<Feature>Event, <Feature>State> {
  <Feature>Bloc(
    this._dependency,
  ) : super(<Feature>State.initial()) {
    on<<Feature>Event>(_onEvent);
  }

  final IDependency _dependency;

  Future<void> _onEvent(
    <Feature>Event event,
    Emitter<<Feature>State> emit,
  ) async {
    switch (event) {
      case <Feature>Started():
        await _handleStarted(emit: emit);
    }
  }

  Future<void> _handleStarted({
    required Emitter<<Feature>State> emit,
  }) async {
    emit(state.copyWith(isLoading: true));
    // ...
    emit(state.copyWith(isLoading: false));
  }
}

// ========== <feature>_event.dart (part of bloc) ==========
part of '<feature>_bloc.dart';

sealed class <Feature>Event {
  const <Feature>Event();

  const factory <Feature>Event.started() = <Feature>Started;
}

final class <Feature>Started extends <Feature>Event {
  const <Feature>Started();
}

// ========== <feature>_state.dart (part of bloc) ==========
part of '<feature>_bloc.dart';

@CopyWith()
class <Feature>State extends Equatable {
  const <Feature>State({
    required this.isLoading,
  });

  factory <Feature>State.initial() => const <Feature>State(
        isLoading: false,
      );

  final bool isLoading;

  @override
  List<Object?> get props => [isLoading];
}
