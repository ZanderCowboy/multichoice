import 'dart:developer';

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:models/models.dart';

@LazySingleton(as: ISearchRepository)
class SearchRepository implements ISearchRepository {
  SearchRepository(this.db);

  final Isar db;

  @override
  Future<List<SearchResult>> search(String query) async {
    try {
      if (query.isEmpty) return [];

      final normalizedQuery = query.toLowerCase();

      return await db.writeTxn(() async {
        final tabs = await db.tabs
            .where()
            .filter()
            .titleContains(normalizedQuery, caseSensitive: false)
            .or()
            .subtitleContains(normalizedQuery, caseSensitive: false)
            .findAll();

        final entries = await db.entrys
            .where()
            .filter()
            .titleContains(normalizedQuery, caseSensitive: false)
            .or()
            .subtitleContains(normalizedQuery, caseSensitive: false)
            .findAll();

        final tabResults = tabs.map((tab) {
          final dto = TabsMapper().convert<Tabs, TabsDTO>(tab);
          final score =
              _calculateMatchScore(dto.title, dto.subtitle, normalizedQuery);
          return SearchResult(
            isTab: true,
            item: dto,
            matchScore: score,
          );
        }).toList();

        final entryResults = entries.map((entry) {
          final dto = EntryMapper().convert<Entry, EntryDTO>(entry);
          final score =
              _calculateMatchScore(dto.title, dto.subtitle, normalizedQuery);
          return SearchResult(
            isTab: false,
            item: dto,
            matchScore: score,
          );
        }).toList();

        final allResults = [...tabResults, ...entryResults];
        allResults.sort((a, b) => b.matchScore.compareTo(a.matchScore));

        return allResults;
      });
    } catch (e, s) {
      log('Error searching: $e', error: e, stackTrace: s);
      return [];
    }
  }

  double _calculateMatchScore(String title, String? subtitle, String query) {
    double score = 0.0;

    if (title.toLowerCase() == query.toLowerCase()) {
      score += 1.0;
    } else if (title.toLowerCase().contains(query.toLowerCase())) {
      score += 0.8;
    }

    if (subtitle != null) {
      if (subtitle.toLowerCase() == query.toLowerCase()) {
        score += 0.6;
      } else if (subtitle.toLowerCase().contains(query.toLowerCase())) {
        score += 0.4;
      }
    }

    return score;
  }
}
