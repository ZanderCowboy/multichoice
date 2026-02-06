part of 'changelog_bloc.dart';

@freezed
class ChangelogEvent with _$ChangelogEvent {
  const factory ChangelogEvent.fetch() = FetchChangelog;
}
