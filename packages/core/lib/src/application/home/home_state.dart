part of 'home_bloc.dart';

@CopyWith()
class HomeState extends Equatable {
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
  List<Object?> get props => [
    tab,
    tabs,
    entry,
    entryCards,
    isLoading,
    isDeleted,
    isAdded,
    isValid,
    isEditMode,
    errorMessage,
  ];
}
