import 'package:core/src/repositories/implementation/entry/entry_repository.dart';
import 'package:core/src/repositories/implementation/search/search_repository.dart';
import 'package:core/src/repositories/implementation/tabs/tabs_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:models/models.dart';

import '../../../../injection.dart';

void main() {
  late SearchRepository searchRepository;
  late TabsRepository tabsRepository;
  late EntryRepository entryRepository;
  late Isar db;

  setUpAll(() async {
    db = await configureIsarInstance();
  });

  setUp(() async {
    if (!db.isOpen) {
      db = await configureIsarInstance();
    }
    searchRepository = SearchRepository(db);
    tabsRepository = TabsRepository(db);
    entryRepository = EntryRepository(db);
  });

  tearDownAll(() {
    closeIsarInstance();
  });

  group('SearchRepository', () {
    setUp(() async {
      await db.writeTxn(() => db.clear());

      // Add test data
      await tabsRepository.addTab(
        title: 'Test Tab',
        subtitle: 'Test Subtitle',
      );
      await tabsRepository.addTab(
        title: 'Another Tab',
        subtitle: 'Another Subtitle',
      );

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'Test Tab');

      await entryRepository.addEntry(
        tabId: tab.id,
        title: 'Test Entry',
        subtitle: 'Some Other Subtitle',
      );
      await entryRepository.addEntry(
        tabId: tab.id,
        title: 'Another Entry',
        subtitle: 'Another Entry Subtitle',
      );
    });

    test('should return empty list when query is empty', () async {
      final result = await searchRepository.search('');
      expect(result, isEmpty);
    });

    test('should return empty list when no matches found', () async {
      final result = await searchRepository.search('nonexistent');
      expect(result, isEmpty);
    });

    test('should find and sort results by match score', () async {
      final result = await searchRepository.search('test');

      expect(result.length, 2);
      expect(result[0].isTab, true);
      expect(result[1].isTab, false);
      expect(result[0].matchScore, greaterThan(result[1].matchScore));

      // Verify the content of the results
      final tabResult = result[0];
      expect(tabResult.item.title, 'Test Tab');
      expect(tabResult.item.subtitle, 'Test Subtitle');

      final entryResult = result[1];
      expect(entryResult.item.title, 'Test Entry');
      expect(entryResult.item.subtitle, 'Some Other Subtitle');
    });

    test('should find results in both title and subtitle', () async {
      final result = await searchRepository.search('subtitle');

      expect(
        result.length,
        4,
      ); // Should find all items with 'subtitle' in either title or subtitle
      expect(result.any((r) => r.item.title == 'Test Tab'), true);
      expect(result.any((r) => r.item.title == 'Another Tab'), true);
      expect(result.any((r) => r.item.title == 'Test Entry'), true);
      expect(result.any((r) => r.item.title == 'Another Entry'), true);
    });

    test('should handle case insensitive search', () async {
      final result = await searchRepository.search('TEST');

      expect(result.length, 2);
      expect(result[0].item.title, 'Test Tab');
      expect(result[1].item.title, 'Test Entry');
    });

    test('should handle partial matches', () async {
      final result = await searchRepository.search('test');

      expect(result.length, 2);
      expect(result[0].item.title, 'Test Tab');
      expect(result[1].item.title, 'Test Entry');
    });
  });
}
