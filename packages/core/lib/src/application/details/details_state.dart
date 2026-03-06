part of 'details_bloc.dart';

@CopyWith()
class DetailsState {
  DetailsState({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isValid,
    required this.isLoading,
    required this.isEditingMode,
    required this.isDeleted,
    required this.parent,
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
  final List<EntryDTO>? children;
  final List<int>? deleteChildren;
  final int? tabId;
  final int? entryId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DetailsState &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.timestamp == timestamp &&
        other.isValid == isValid &&
        other.isLoading == isLoading &&
        other.isEditingMode == isEditingMode &&
        other.isDeleted == isDeleted &&
        other.parent == parent &&
        _listEquals(other.children, children) &&
        _listEquals(other.deleteChildren, deleteChildren) &&
        other.tabId == tabId &&
        other.entryId == entryId;
  }

  @override
  int get hashCode => Object.hash(
    title,
    subtitle,
    timestamp,
    isValid,
    isLoading,
    isEditingMode,
    isDeleted,
    parent,
    Object.hashAll(children ?? const <EntryDTO>[]),
    Object.hashAll(deleteChildren ?? const <int>[]),
    tabId,
    entryId,
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
