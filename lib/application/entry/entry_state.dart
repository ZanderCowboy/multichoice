part of 'entry_bloc.dart';

@freezed
class EntryState with _$EntryState {
  const factory EntryState({
    required EntryCard entryCard,
    required bool isLoading,
    required bool isDeleted,
    required bool isAdded,
    required String? errorMessage,
  }) = _EntryState;

  factory EntryState.initial() => const EntryState(
        entryCard: EntryCard(),
        isLoading: false,
        isDeleted: false,
        isAdded: false,
        errorMessage: '',
      );
}
