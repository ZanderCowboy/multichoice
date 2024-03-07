import 'package:core/src/repositories/export_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../mocks.mocks.dart';

void main() {
  late TabsRepository tabsRepository;
  late EntryRepository entryRepository;
  late MockTabsRepository mockTabsRepository;
  late Isar db;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    db = await Isar.open([TabsSchema, EntrySchema], directory: '');
  });

  setUp(() async {
    if (!db.isOpen) {
      db = await Isar.open([TabsSchema, EntrySchema], directory: '');
    }
    tabsRepository = TabsRepository(db);
    entryRepository = EntryRepository(db);
    mockTabsRepository = MockTabsRepository();

    await db.writeTxn(() => db.clear());
    await tabsRepository.addTab('title', 'subtitle');
    await tabsRepository.addTab('not a title', 'not a subtitle');
    await tabsRepository.addTab('another t', 'another sub');

    final tabs = await db.tabs.where().findAll();
    final tab = tabs.firstWhere((element) => element.title == 'another t');
    await entryRepository.addEntry(tab.id, 'entry title', 'entry subtitle');
    await entryRepository.addEntry(tab.id, 'wonderful day', 'have a laugh');
  });

  group('TabsRepository - addTab', () {
    test('should return int when addTab is called', () async {
      // Arrange
      // Act
      await tabsRepository.addTab('new title', 'new subtitle');
      final tabs = await tabsRepository.readTabs();
      final result = tabs.length;

      // Assert
      expect(result, 4);
    });

    test('should add a new tab when addTab is called', () async {
      // Arrange
      const title = 'Test Title';
      const subtitle = 'Test Subtitle';

      when(mockTabsRepository.addTab(title, subtitle))
          .thenAnswer((_) => Future.value(1));

      // Act
      final result = await tabsRepository.addTab(title, subtitle);

      // Assert
      final tabs = await db.tabs.where().findAll();
      expect(result, tabs.firstWhere((element) => element.title == title).id);
    });

    test('should throw an error wehn addTab is called', () async {
      // Arrange
      // Act
      // Assert
    });
  });

  group('TabsRepository - readTabs', () {
    setUp(() async {});
    test('should return a list of TabsDTO when readTabs is called', () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final entries = await db.entrys.where().findAll();

      final tabsDTO = <TabsDTO>[
        TabsDTO.empty().copyWith(
          id: tabs.firstWhere((e) => e.title == 'title').id,
          title: 'title',
          subtitle: 'subtitle',
          timestamp: tabs.firstWhere((e) => e.title == 'title').timestamp ??
              DateTime.now(),
          entries: [],
        ),
        TabsDTO.empty().copyWith(
          id: tabs.firstWhere((e) => e.title == 'not a title').id,
          title: 'not a title',
          subtitle: 'not a subtitle',
          timestamp:
              tabs.firstWhere((e) => e.title == 'not a title').timestamp ??
                  DateTime.now(),
          entries: [],
        ),
        TabsDTO.empty().copyWith(
          id: tabs.firstWhere((e) => e.title == 'another t').id,
          title: 'another t',
          subtitle: 'another sub',
          timestamp: tabs.firstWhere((e) => e.title == 'another t').timestamp ??
              DateTime.now(),
          entries: <EntryDTO>[
            EntryDTO.empty().copyWith(
              id: entries.firstWhere((e) => e.title == 'entry title').id,
              tabId: tabs.firstWhere((e) => e.title == 'another t').id,
              title: 'entry title',
              subtitle: 'entry subtitle',
              timestamp: entries
                      .firstWhere((e) => e.title == 'entry title')
                      .timestamp ??
                  DateTime.now(),
            ),
            EntryDTO.empty().copyWith(
              id: entries.firstWhere((e) => e.title == 'wonderful day').id,
              tabId: tabs.firstWhere((e) => e.title == 'another t').id,
              title: 'wonderful day',
              subtitle: 'have a laugh',
              timestamp: entries
                      .firstWhere((e) => e.title == 'wonderful day')
                      .timestamp ??
                  DateTime.now(),
            ),
          ],
        ),
      ];

      // Act
      final result = await tabsRepository.readTabs();
      // Assert
      expect(result, tabsDTO);
    });
  });

  group('TabsRepository - getTab', () {
    test('should return a TabsDTO instance when getTab is called', () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((element) => element.title == 'not a title');

      // Act
      final result = await tabsRepository.getTab(tab.id);

      // Assert
      expect(
        result,
        TabsDTO.empty().copyWith(
          id: tab.id,
          title: 'not a title',
          subtitle: 'not a subtitle',
          timestamp: tab.timestamp ?? DateTime.now(),
          entries: [],
        ),
      );
    });
  });

  group('TabsRepository - deleteTab', () {
    test(
        "should delete a tab and all it's entries and return a bool when deleteTab is called",
        () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tabId =
          tabs.firstWhere((element) => element.title == 'another t').id;

      when(mockTabsRepository.deleteTab(any))
          .thenAnswer((_) => Future.value(true));

      // Act
      final result = await tabsRepository.deleteTab(tabId);

      // Assert
      expect(result, true);
    });

    test('should return false when deleteTab is called on a tab not in the db',
        () async {
      // Arrange
      const tabId = 5;

      when(mockTabsRepository.deleteTab(any))
          .thenAnswer((_) => Future.value(true));

      // Act
      final result = await tabsRepository.deleteTab(tabId);

      // Assert
      expect(result, false);
    });
  });
}
