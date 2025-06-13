part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required List<SearchResult> results,
    required bool isLoading,
    required String? errorMessage,
    required String query,
  }) = _SearchState;

  factory SearchState.initial() => const SearchState(
        results: [],
        isLoading: false,
        errorMessage: null,
        query: '',
      );
}
