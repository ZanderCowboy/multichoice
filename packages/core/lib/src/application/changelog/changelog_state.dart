part of 'changelog_bloc.dart';

@CopyWith()
class ChangelogState {
  const ChangelogState({
    required this.isLoading,
    required this.errorMessage,
    required this.changelog,
  });

  factory ChangelogState.initial() => const ChangelogState(
    isLoading: false,
    errorMessage: null,
    changelog: null,
  );

  final bool isLoading;
  final String? errorMessage;
  final Changelog? changelog;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChangelogState &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.changelog == changelog;
  }

  @override
  int get hashCode => Object.hash(isLoading, errorMessage, changelog);
}
