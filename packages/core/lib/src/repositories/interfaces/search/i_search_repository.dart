import 'package:models/models.dart';

abstract class ISearchRepository {
  /// Searches across both tabs and entries
  /// Returns a list of SearchResult objects containing both tabs and entries
  /// sorted by relevance
  Future<List<SearchResult>> search(String query);
}
