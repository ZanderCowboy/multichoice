part of 'entry_bloc.dart';

@freezed
class EntryState with _$EntryState {
  const factory EntryState({
    required Entry entry,
    required List<Entry>? entryCards,
    required bool isLoading,
    required bool isDeleted,
    required bool isAdded,
    required String? errorMessage,
  }) = _EntryState;

  factory EntryState.initial() => const EntryState(
        entry: Entry(
          uuid: '',
          tabId: '',
          title: '',
          subtitle: '',
        ),
        entryCards: [],
        isLoading: false,
        isDeleted: false,
        isAdded: false,
        errorMessage: '',
      );
}
