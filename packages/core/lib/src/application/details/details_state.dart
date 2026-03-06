part of 'details_bloc.dart';

@CopyWith()
class DetailsState extends Equatable {
  DetailsState({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isValid,
    required this.isLoading,
    required this.isEditingMode,
    required this.isDeleted,
    required this.parent,
    required this.allChildren,
    required this.children,
    required this.deleteChildren,
    required this.tabId,
    required this.entryId,
  });

  factory DetailsState.initial() => DetailsState(
    title: '',
    subtitle: '',
    timestamp: DateTime.now(),
    isValid: false,
    isLoading: false,
    isEditingMode: false,
    isDeleted: false,
    parent: null,
    allChildren: null,
    children: null,
    deleteChildren: <int>[],
    tabId: null,
    entryId: null,
  );

  final String title;
  final String subtitle;
  final DateTime timestamp;
  final bool isValid;
  final bool isLoading;
  final bool isEditingMode;
  final bool isDeleted;
  final TabsDTO? parent;
  final List<EntryDTO>? allChildren;
  final List<EntryDTO>? children;
  final List<int>? deleteChildren;
  final int? tabId;
  final int? entryId;

  @override
  List<Object?> get props => [
    title,
    subtitle,
    timestamp,
    isValid,
    isLoading,
    isEditingMode,
    isDeleted,
    parent,
    allChildren,
    children,
    deleteChildren,
    tabId,
    entryId,
  ];
}
