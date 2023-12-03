part of 'entry_bloc.dart';

@freezed
class EntryEvent with _$EntryEvent {
  const factory EntryEvent.onPressedAddEntry(EntryCard entryCard) =
      onPressedAddEntry;

  const factory EntryEvent.onLongPressedDeleteEntry() =
      onLongPressedDeleteEntry;
}
