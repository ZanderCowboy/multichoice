part of 'home_bloc.dart';

@CopyWith()
class HomeState {
  const HomeState({
    required this.tab,
    required this.tabs,
    required this.entry,
    required this.entryCards,
    required this.isLoading,
    required this.isDeleted,
    required this.isAdded,
    required this.isValid,
    required this.isEditMode,
    required this.errorMessage,
  });

  factory HomeState.initial() => HomeState(
    tab: TabsDTO.empty(),
    tabs: null,
    entry: EntryDTO.empty(),
    entryCards: null,
    isLoading: false,
    isDeleted: false,
    isAdded: false,
    isValid: false,
    isEditMode: false,
    errorMessage: '',
  );

  final TabsDTO tab;
  final List<TabsDTO>? tabs;
  final EntryDTO entry;
  final List<EntryDTO>? entryCards;
  final bool isLoading;
  final bool isDeleted;
  final bool isAdded;
  final bool isValid;
  final bool isEditMode;
  final String? errorMessage;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.tab == tab &&
        _listEquals(other.tabs, tabs) &&
        other.entry == entry &&
        _listEquals(other.entryCards, entryCards) &&
        other.isLoading == isLoading &&
        other.isDeleted == isDeleted &&
        other.isAdded == isAdded &&
        other.isValid == isValid &&
        other.isEditMode == isEditMode &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    tab,
    Object.hashAll(tabs ?? const <TabsDTO>[]),
    entry,
    Object.hashAll(entryCards ?? const <EntryDTO>[]),
    isLoading,
    isDeleted,
    isAdded,
    isValid,
    isEditMode,
    errorMessage,
  );
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null || a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
