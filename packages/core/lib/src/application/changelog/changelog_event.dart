part of 'changelog_bloc.dart';

sealed class ChangelogEvent {
  const ChangelogEvent();

  const factory ChangelogEvent.fetch() = FetchChangelog;
}

final class FetchChangelog extends ChangelogEvent {
  const FetchChangelog();
}
