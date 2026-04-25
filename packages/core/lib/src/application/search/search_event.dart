part of 'search_bloc.dart';

sealed class SearchEvent {
  const SearchEvent();

  const factory SearchEvent.search(String query) = Search;
  const factory SearchEvent.clear() = Clear;
  const factory SearchEvent.refresh() = Refresh;
}

final class Search extends SearchEvent {
  const Search(this.query);

  final String query;
}

final class Clear extends SearchEvent {
  const Clear();
}

final class Refresh extends SearchEvent {
  const Refresh();
}
