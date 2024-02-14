part of 'entry_bloc.dart';

@freezed
class EntryEvent with _$EntryEvent {
  const factory EntryEvent.onGetAllEntryCards() = OnGetAllEntryCards;

  const factory EntryEvent.onGetEntryCards(int tabId) = OnGetEntryCards;

  const factory EntryEvent.onPressedAddEntry(
    int tabId,
    String title,
    String subtitle,
  ) = OnPressedAddEntry;

  const factory EntryEvent.onLongPressedDeleteEntry(
    int tabId,
    int entryId,
  ) = OnLongPressedDeleteEntry;
}
