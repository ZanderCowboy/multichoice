part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required TabDTO tab,
    required TabsDTO tabs,
    required EntryDTO entry,
    required List<EntryDTO>? entryCards,
    required bool isLoading,
    required bool isDeleted,
    required bool isAdded,
    required bool isValid,
    required String? errorMessage,
  }) = _HomeState;

  factory HomeState.initial() => HomeState(
        tab: TabDTO.empty(),
        tabs: TabsDTO.empty(),
        entry: EntryDTO.empty(),
        entryCards: null,
        isLoading: false,
        isDeleted: false,
        isAdded: false,
        isValid: false,
        errorMessage: '',
      );
}
