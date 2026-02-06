part of 'changelog_bloc.dart';

@freezed
abstract class ChangelogState with _$ChangelogState {
  const factory ChangelogState({
    required bool isLoading,
    required String? errorMessage,
    required Changelog? changelog,
  }) = _ChangelogState;

  factory ChangelogState.initial() => const ChangelogState(
    isLoading: false,
    errorMessage: null,
    changelog: null,
  );
}
