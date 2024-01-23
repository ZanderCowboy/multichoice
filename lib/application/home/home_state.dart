part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required Tabs tab,
    required List<Tabs> tabs,
    required Entry entry,
    required List<Entry>? entryCards,
    required bool isLoading,
    required bool isDeleted,
    required bool isAdded,
    required String? errorMessage,
  }) = _HomeState;

  factory HomeState.initial() => HomeState(
        tab: Tabs.empty(),
        tabs: [],
        entry: Entry.empty(),
        entryCards: [],
        isLoading: false,
        isDeleted: false,
        isAdded: false,
        errorMessage: '',
      );
}
