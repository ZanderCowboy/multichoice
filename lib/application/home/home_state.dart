part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required VerticalTab verticalTab,
    required bool isLoading,
    required bool isDeleted,
    required bool isAdded,
    required String? errorMessage,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState(
        verticalTab: VerticalTab(title: '', subtitle: ''),
        isLoading: false,
        isDeleted: false,
        isAdded: false,
        errorMessage: '',
      );
}
