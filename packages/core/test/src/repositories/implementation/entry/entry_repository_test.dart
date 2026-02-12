import 'package:core/src/repositories/implementation/entry/entry_repository.dart';
import 'package:core/src/repositories/implementation/tabs/tabs_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:models/models.dart';
import 'package:clock/clock.dart';

import '../../../../injection.dart';

void main() {
  late TabsRepository tabsRepository;
  late EntryRepository entryRepository;
  late Isar db;
  late Clock clock;

  setUpAll(() async {
    db = await configureIsarInstance();
    clock = Clock();
  });

  setUp(() async {
    if (!db.isOpen) {
      db = await configureIsarInstance();
    }
    tabsRepository = TabsRepository(db);
    entryRepository = EntryRepository(db);
  });

  tearDownAll(() {
    closeIsarInstance();
  });

  group('EntryRepository - addEntry', () {
    test('should return int when addEntry is called', () async {
      // Arrange
      await db.writeTxn(() => db.clear());

      // Act
      final result = await entryRepository.addEntry(
        tabId: 0,
        title: 'slayer',
        subtitle: 'you go queen',
      );

      // Assert
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'slayer');
      expect(result, entry.id);
    });

    test('should update entryIds for the tab when addEntry is called',
        () async {
      // Arrange
      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab(
        title: 'not a title',
        subtitle: 'not a subtitle',
      );
      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'not a title');

      // Act
      await entryRepository.addEntry(
        tabId: tab.id,
        title: 'slayer',
        subtitle: 'you go queen',
      );

      // Assert
      final entries = await db.entrys.where().findAll();
      final newTabs = await db.tabs.where().findAll();
      final newTab = newTabs.firstWhere((e) => e.id == tab.id);
      expect(entries.length, 1);
      expect(newTab.entryIds?.length, 1);
    });

    test('should throw an IsarError when addEntry is called', () async {
      // Arrange
      await db.close();

      // Act
      final result = await entryRepository.addEntry(
        tabId: 0,
        title: 'slayer',
        subtitle: 'you go queen',
      );

      // Assert
      expect(result, -1);
    });
  });

  group('EntryRepository - getEntry', () {
    setUp(() async {
      entryRepository = EntryRepository(db);
      tabsRepository = TabsRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab(
        title: 'another t',
        subtitle: 'another sub',
      );

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'another t');
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
      await entryRepository.addEntry(
        tabId: tab.id,
        title: 'apple',
        subtitle: 'pineapple',
      );
    });

    test('should return EntryDTO when getEntry is called', () async {
      // Arrange
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'apple');

      // Act
      final result = await entryRepository.getEntry(entryId: entry.id);

      // Assert
      expect(
        result,
        EntryDTO.empty().copyWith(
          id: entry.id,
          tabId: entry.tabId,
          title: 'apple',
          subtitle: 'pineapple',
          timestamp: entry.timestamp ?? clock.now(),
        ),
      );
    });
  });

  group('EntryRepository - readEntries', () {
    setUp(() async {
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab(
        title: 'another t',
        subtitle: 'another sub',
      );

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.first;
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

    test(
        'should return List<EntryDTO> when readEntries is called for a given tabId',
        () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tab = tabs.first;
      final tabOne = tabs.firstWhere((e) => e.title == 'another t');
      final entries = await db.entrys.where().findAll();

      final entriesDTO = <EntryDTO>[
        EntryDTO.empty().copyWith(
          id: entries.firstWhere((e) => e.title == 'entry title').id,
          tabId: tabOne.id,
          title: 'entry title',
          subtitle: 'entry subtitle',
          timestamp:
              entries.firstWhere((e) => e.title == 'entry title').timestamp ??
                  DateTime.now(),
        ),
        EntryDTO.empty().copyWith(
          id: entries.firstWhere((e) => e.title == 'wonderful day').id,
          tabId: tabOne.id,
          title: 'wonderful day',
          subtitle: 'have a laugh',
          timestamp:
              entries.firstWhere((e) => e.title == 'wonderful day').timestamp ??
                  DateTime.now(),
        ),
      ];

      // Act
      final result = await entryRepository.readEntries(tabId: tab.id);

      // Assert
      expect(result, entriesDTO);
    });
  });

  group('EntryRepository - readAllEntries', () {
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
      final tab = tabs.firstWhere((e) => e.title == 'another t');
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

    test('should return List<EntryDTO> when readAllEntries is called',
        () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tempTab = tabs.firstWhere((e) => e.title == 'title');
      await entryRepository.addEntry(
        tabId: tempTab.id,
        title: 'fernando',
        subtitle: 'say my name',
      );

      final tab = tabs.firstWhere((e) => e.title == 'another t');
      final entries = await db.entrys.where().findAll();

      final entriesDTO = <EntryDTO>[
        EntryDTO.empty().copyWith(
          id: entries.firstWhere((e) => e.title == 'entry title').id,
          tabId: tab.id,
          title: 'entry title',
          subtitle: 'entry subtitle',
          timestamp:
              entries.firstWhere((e) => e.title == 'entry title').timestamp ??
                  DateTime.now(),
        ),
        EntryDTO.empty().copyWith(
          id: entries.firstWhere((e) => e.title == 'wonderful day').id,
          tabId: tab.id,
          title: 'wonderful day',
          subtitle: 'have a laugh',
          timestamp:
              entries.firstWhere((e) => e.title == 'wonderful day').timestamp ??
                  DateTime.now(),
        ),
        EntryDTO.empty().copyWith(
          id: entries.firstWhere((e) => e.title == 'fernando').id,
          tabId: tempTab.id,
          title: 'fernando',
          subtitle: 'say my name',
          timestamp:
              entries.firstWhere((e) => e.title == 'fernando').timestamp ??
                  DateTime.now(),
        ),
      ];

      // Act
      final result = await entryRepository.readAllEntries();

      // Assert
      expect(result, entriesDTO);
    });
  });

  group('EntryRepository - updateEntry', () {
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
      final tab = tabs.firstWhere((e) => e.title == 'another t');
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

    test('should return int when updateEntry is called', () async {
      // Arrange
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'entry title');

      // Act
      final result = await entryRepository.updateEntry(
        id: entry.id,
        tabId: 0,
        title: 'sunshine',
        subtitle: 'under the day sky',
      );

      // Assert
      expect(result, entry.id);
    });

    test('should update Entry when updateEntry is called', () async {
      // Arrange

      final entries = await db.entrys.where().findAll();
      final entryOne = entries.firstWhere((e) => e.title == 'entry title');
      final entryTwo = entries.firstWhere((e) => e.title == 'wonderful day');

      final updatedEntries = <Entry>[
        Entry.empty().copyWith(
          uuid: entryOne.uuid,
          tabId: entryOne.tabId,
          title: 'entry title',
          subtitle: 'entry subtitle',
          timestamp: entryOne.timestamp ?? DateTime.now(),
        ),
        Entry.empty().copyWith(
          uuid: entryTwo.uuid,
          tabId: entryTwo.tabId,
          title: 'moonshine',
          subtitle: 'under the night sky',
          timestamp: entryTwo.timestamp ?? DateTime.now(),
        ),
      ];

      // Act
      await entryRepository.updateEntry(
        id: entryTwo.id,
        tabId: 0,
        title: 'moonshine',
        subtitle: 'under the night sky',
      );

      // Assert
      final result = await db.entrys.where().sortByTimestamp().findAll();
      expect(result, updatedEntries);
    });
  });

  group('EntryRepository - deleteEntry', () {
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
      final tab = tabs.firstWhere((e) => e.title == 'another t');
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

    test('should return bool when deleteEntry is called', () async {
      // Arrange
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'entry title');

      // Act
      final result = await entryRepository.deleteEntry(
        tabId: 0,
        entryId: entry.id,
      );

      // Assert
      expect(result, true);
    });

    test('should update Tabs and Entries DB when deleteEntry is called',
        () async {
      // Arrange
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'entry title');
      final entryTwo = entries.firstWhere((e) => e.title == 'wonderful day');
      final entriesDTO = <EntryDTO>[
        EntryDTO.empty().copyWith(
          id: entryTwo.id,
          tabId: entryTwo.tabId,
          title: 'wonderful day',
          subtitle: 'have a laugh',
          timestamp: entryTwo.timestamp ?? DateTime.now(),
        ),
      ];

      // Act
      await entryRepository.deleteEntry(
        tabId: entry.tabId,
        entryId: entry.id,
      );

      // Assert
      final tab = await tabsRepository.getTab(tabId: entryTwo.tabId);
      final tabResult = tab.entries.length;
      expect(await entryRepository.readAllEntries(), entriesDTO);
      expect(tabResult, 1);
    });
  });

  group('EntryRepository - deleteEntries', () {
    setUp(() async {
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab(
        title: 'another t',
        subtitle: 'another sub',
      );
      await tabsRepository.addTab(
        title: 'test',
        subtitle: 'sub test',
      );

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'another t');
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
      final tabTwo = tabs.firstWhere((e) => e.title == 'test');
      await entryRepository.addEntry(
        tabId: tabTwo.id,
        title: 'neon',
        subtitle: 'moon',
      );
    });

    test('should return bool when deleteEntries is called', () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'another t');

      // Act
      final result = await entryRepository.deleteEntries(tabId: tab.id);

      // Assert
      expect(result, true);
    });

    test(
        'should delete all entries for a given tab when deleteEntries is called',
        () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'test');

      // Act
      await entryRepository.deleteEntries(tabId: tab.id);

      // Assert
      final newTabs = await db.tabs.where().findAll();
      final newTab = newTabs.firstWhere((e) => e.title == 'test');
      final tabResult = newTab.entryIds;
      expect(tabResult, null);
    });
  });

  group('EntryRepository - moveEntryToTab', () {
    setUp(() async {
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());

      await tabsRepository.addTab(
        title: 'Source Tab',
        subtitle: 'source',
      );
      await tabsRepository.addTab(
        title: 'Destination Tab',
        subtitle: 'destination',
      );

      final tabs = await db.tabs.where().findAll();
      final sourceTab = tabs.firstWhere((e) => e.title == 'Source Tab');

      await entryRepository.addEntry(
        tabId: sourceTab.id,
        title: 'entry title',
        subtitle: 'entry subtitle',
      );
    });

    test(
        'should move entry between tabs and update entryIds and entry.tabId when moveEntryToTab is called',
        () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final sourceTab = tabs.firstWhere((e) => e.title == 'Source Tab');
      final destinationTab =
          tabs.firstWhere((e) => e.title == 'Destination Tab');
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'entry title');

      // Act
      final result = await entryRepository.moveEntryToTab(
        entryId: entry.id,
        fromTabId: sourceTab.id,
        toTabId: destinationTab.id,
        insertIndex: 0,
      );

      // Assert
      expect(result, true);

      final updatedSourceTab =
          (await db.tabs.where().findAll()).firstWhere((e) => e.id == sourceTab.id);
      final updatedDestinationTab =
          (await db.tabs.where().findAll()).firstWhere((e) => e.id == destinationTab.id);
      final updatedEntry =
          (await db.entrys.where().findAll()).firstWhere((e) => e.id == entry.id);

      expect(updatedSourceTab.entryIds, isEmpty);
      expect(updatedDestinationTab.entryIds, [entry.id]);
      expect(updatedEntry.tabId, destinationTab.id);
    });

    test(
        'should not move entry when fromTabId does not match entry.tabId and return false',
        () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final sourceTab = tabs.firstWhere((e) => e.title == 'Source Tab');
      final destinationTab =
          tabs.firstWhere((e) => e.title == 'Destination Tab');
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'entry title');

      // Act
      final result = await entryRepository.moveEntryToTab(
        entryId: entry.id,
        fromTabId: destinationTab.id,
        toTabId: sourceTab.id,
        insertIndex: 0,
      );

      // Assert
      expect(result, false);

      final updatedSourceTab =
          (await db.tabs.where().findAll()).firstWhere((e) => e.id == sourceTab.id);
      final updatedDestinationTab =
          (await db.tabs.where().findAll()).firstWhere((e) => e.id == destinationTab.id);
      final updatedEntry =
          (await db.entrys.where().findAll()).firstWhere((e) => e.id == entry.id);

      // Original relations should remain unchanged.
      expect(updatedSourceTab.entryIds, isNotEmpty);
      expect(updatedDestinationTab.entryIds, isEmpty);
      expect(updatedEntry.tabId, sourceTab.id);
    });
  });
}
