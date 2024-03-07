part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required TabsDTO tab,
    required List<TabsDTO>? tabs,
    required List<EntryDTO>? entryCards,
    required bool isLoading,
    required bool isDeleted,
    required bool isAdded,
    required String? errorMessage,
  }) = _HomeState;

  factory HomeState.initial() => HomeState(
        tab: TabsDTO.empty(),
        tabs: null,
        entryCards: null,
        isLoading: false,
        isDeleted: false,
        isAdded: false,
        errorMessage: '',
      );
}
