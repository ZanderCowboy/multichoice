part of 'details_bloc.dart';

@freezed
abstract class DetailsState with _$DetailsState {
  const factory DetailsState({
    required String title,
    required String subtitle,
    required DateTime timestamp,
    required bool isValid,
    required bool isLoading,
    required bool isEditingMode,
    required bool isDeleted,
    TabsDTO? parent,
    List<EntryDTO>? children,
    List<int>? deleteChildren,
    int? tabId,
    int? entryId,
  }) = _DetailsState;

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
}
