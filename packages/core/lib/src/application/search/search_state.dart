part of 'search_bloc.dart';

@CopyWith()
class SearchState {
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchState &&
        _listEquals(other.results, results) &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.query == query;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(results),
    isLoading,
    errorMessage,
    query,
  );
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
