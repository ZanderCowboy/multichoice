part of 'entry_bloc.dart';

@freezed
class EntryEvent with _$EntryEvent {
  const factory EntryEvent.onGetEntryCards(String tabId) = OnGetEntryCards;

  const factory EntryEvent.onPressedAddEntry(
    String tabId,
    String title,
    String subtitle,
  ) = OnPressedAddEntry;

  const factory EntryEvent.onLongPressedDeleteEntry(
    String tabId,
    String entryId,
  ) = OnLongPressedDeleteEntry;
}
