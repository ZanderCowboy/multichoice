part of 'changelog_bloc.dart';

@CopyWith()
class ChangelogState extends Equatable {
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
  List<Object?> get props => [isLoading, errorMessage, changelog];
}
