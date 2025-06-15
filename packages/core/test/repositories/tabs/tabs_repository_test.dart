import 'package:core/src/repositories/implementation/entry/entry_repository.dart';
import 'package:core/src/repositories/implementation/tabs/tabs_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../injection.dart';
import '../../mocks.mocks.dart';

void main() {
  late TabsRepository tabsRepository;
  late EntryRepository entryRepository;
  late MockTabsRepository mockTabsRepository;
  late Isar db;

  setUpAll(() async {
    db = await configureIsarInstance();
  });

  setUp(() async {
    if (!db.isOpen) {
      db = await configureIsarInstance();
    }
    tabsRepository = TabsRepository(db);
    entryRepository = EntryRepository(db);
    mockTabsRepository = MockTabsRepository();
  });

  tearDownAll(() {
    closeIsarInstance();
  });

  group('TabsRepository - addTab', () {
    test('should return int when addTab is called', () async {
      // Arrange
      await db.writeTxn(() => db.clear());

      // Act
      await tabsRepository.addTab(
        title: 'new title',
        subtitle: 'new subtitle',
      );
      final tabs = await db.tabs.where().findAll();
      final result = tabs.length;

      // Assert
      expect(result, 1);
    });

    test('should add a new tab when addTab is called', () async {
      // Arrange
      const title = 'Test Title';
      const subtitle = 'Test Subtitle';

      // Act
      final result = await tabsRepository.addTab(
        title: title,
        subtitle: subtitle,
      );

      // Assert
      final tabs = await db.tabs.where().findAll();
      expect(result, tabs.firstWhere((element) => element.title == title).id);
    });
  });

  group('TabsRepository - readTabs', () {
    setUp(() async {
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab(
        title: 'title',
        subtitle: 'subtitle',
      );
      await tabsRepository.addTab(
        title: 'not a title',
        subtitle: 'not a subtitle',
      );
      await tabsRepository.addTab(
        title: 'another t',
        subtitle: 'another sub',
      );

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((element) => element.title == 'another t');
      await entryRepository.addEntry(
        tabId: tab.id,
        title: 'entry title',
        subtitle: 'entry subtitle',
      );
      await entryRepository.addEntry(
        tabId: tab.id,
        title: 'wonderful day',
        subtitle: 'have a laugh',
      );
    });

    test('should return List<TabsDTO> when readTabs is called', () async {
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
    setUp(() async {
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab(
        title: 'title',
        subtitle: 'subtitle',
      );
      await tabsRepository.addTab(
        title: 'not a title',
        subtitle: 'not a subtitle',
      );
      await tabsRepository.addTab(
        title: 'another t',
        subtitle: 'another sub',
      );
    });

    test('should return a TabsDTO instance when getTab is called', () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((element) => element.title == 'not a title');

      // Act
      final result = await tabsRepository.getTab(tabId: tab.id);

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

  group('TabsRepository - updateTab', () {
    setUp(() async {
      tabsRepository = TabsRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab(
        title: 'title',
        subtitle: 'subtitle',
      );
    });

    test('should return int when updateTab is called', () async {
      // Arrange
      final tab = (await db.tabs.where().findAll()).first;

      // Act
      final result = await tabsRepository.updateTab(
        id: tab.id,
        title: 'who let the dogs out',
        subtitle: 'me',
      );

      // Assert
      expect(result, tab.id);
    });
  });

  group('TabsRepository - deleteTab', () {
    setUp(() async {
      tabsRepository = TabsRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab(
        title: 'title',
        subtitle: 'subtitle',
      );
      await tabsRepository.addTab(
        title: 'not a title',
        subtitle: 'not a subtitle',
      );

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((element) => element.title == 'not a title');
      await entryRepository.addEntry(
        tabId: tab.id,
        title: 'entry title',
        subtitle: 'entry subtitle',
      );
      await entryRepository.addEntry(
        tabId: tab.id,
        title: 'wonderful day',
        subtitle: 'have a laugh',
      );
    });

    test('should return bool when deleteTab is called', () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((element) => element.title == 'title');

      // Act
      final result = await tabsRepository.deleteTab(tabId: tab.id);

      // Assert
      expect(result, true);
    });

    test(
        "should delete a tab and all it's entries and return a bool when deleteTab is called",
        () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tabId =
          tabs.firstWhere((element) => element.title == 'not a title').id;

      // Act
      final result = await tabsRepository.deleteTab(tabId: tabId);

      // Assert
      final entries = await db.entrys.where().findAll();
      expect(result, true);
      expect(entries.length, 0);
    });

    test('should return false when deleteTab is called on a tab not in the db',
        () async {
      // Arrange
      const tabId = 5;

      when(mockTabsRepository.deleteTab(tabId: any))
          .thenAnswer((_) => Future.value(true));

      // Act
      final result = await tabsRepository.deleteTab(tabId: tabId);

      // Assert
      expect(result, false);
    });
  });

  group('TabsRepository - deleteTabs', () {
    setUp(() async {
      tabsRepository = TabsRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab(
        title: 'title',
        subtitle: 'subtitle',
      );
      await tabsRepository.addTab(
        title: 'not a title',
        subtitle: 'not a subtitle',
      );
      await tabsRepository.addTab(
        title: 'another t',
        subtitle: 'another sub',
      );
    });

    test('should return bool when deleteTabs is called', () async {
      // Arrange

      // Act
      final result = await tabsRepository.deleteTabs();

      // Assert
      expect(result, true);
    });

    test('should delete all the entries and all the tabs', () async {
      // Arrange

      // Act
      await tabsRepository.deleteTabs();

      // Assert
      expect(await db.tabs.count(), 0);
      expect(await db.entrys.count(), 0);
    });
  });
}
