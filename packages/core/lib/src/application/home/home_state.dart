part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required TabsDTO tab,
    required List<TabsDTO>? tabs,
    required EntryDTO entry,
    required List<EntryDTO>? entryCards,
    required String? theme,
    required bool isLoading,
    required bool isDeleted,
    required bool isAdded,
    required bool isValid,
    required String? errorMessage,
  }) = _HomeState;

  factory HomeState.initial() => HomeState(
        tab: TabsDTO.empty(),
        tabs: null,
        entry: EntryDTO.empty(),
        entryCards: null,
        theme: 'light',
        isLoading: false,
        isDeleted: false,
        isAdded: false,
        isValid: false,
        errorMessage: '',
      );
}
