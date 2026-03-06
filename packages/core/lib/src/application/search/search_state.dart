part of 'search_bloc.dart';

@CopyWith()
class SearchState extends Equatable {
  const SearchState({
    required this.results,
    required this.isLoading,
    required this.errorMessage,
    required this.query,
  });

  factory SearchState.initial() => const SearchState(
    results: [],
    isLoading: false,
    errorMessage: null,
    query: '',
  );

  final List<SearchResult> results;
  final bool isLoading;
  final String? errorMessage;
  final String query;

  @override
  List<Object?> get props => [results, isLoading, errorMessage, query];
}
