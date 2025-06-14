part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.search(String query) = Search;
  const factory SearchEvent.clear() = Clear;
  const factory SearchEvent.refresh() = Refresh;
}
