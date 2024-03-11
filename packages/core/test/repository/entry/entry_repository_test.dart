import 'package:core/src/repositories/export_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:models/models.dart';

void main() {
  late TabsRepository tabsRepository;
  late EntryRepository entryRepository;
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
  });

  group('EntryRepository - addEntry', () {
    test('should return int when addEntry is called', () async {
      // Arrange
      await db.writeTxn(() => db.clear());

      // Act
      final result =
          await entryRepository.addEntry(0, 'slayer', 'you go queen');

      // Assert
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'slayer');
      expect(result, entry.id);
    });

    test('should update entryIds for the tab when addEntry is called',
        () async {
      // Arrange
      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab('not a title', 'not a subtitle');
      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'not a title');

      // Act
      await entryRepository.addEntry(tab.id, 'slayer', 'you go queen');

      // Assert
      final entries = await db.entrys.where().findAll();
      final newTabs = await db.tabs.where().findAll();
      final newTab = newTabs.firstWhere((e) => e.id == tab.id);
      expect(entries.length, 1);
      expect(newTab.entryIds?.length, 1);
    });
  });

  group('EntryRepository - getEntry', () {
    setUp(() async {
      if (!db.isOpen) {
        db = await Isar.open([TabsSchema, EntrySchema], directory: '');
      }
      entryRepository = EntryRepository(db);
      tabsRepository = TabsRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab('another t', 'another sub');

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'another t');
      await entryRepository.addEntry(tab.id, 'entry title', 'entry subtitle');
      await entryRepository.addEntry(tab.id, 'wonderful day', 'have a laugh');
      await entryRepository.addEntry(tab.id, 'apple', 'pineapple');
    });

    test('should return EntryDTO when getEntry is called', () async {
      // Arrange
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'apple');

      // Act
      final result = await entryRepository.getEntry(entry.id);

      // Assert
      expect(
        result,
        EntryDTO.empty().copyWith(
          id: entry.id,
          tabId: entry.tabId,
          title: 'apple',
          subtitle: 'pineapple',
          timestamp: entry.timestamp ?? DateTime.now(),
        ),
      );
    });
  });

  group('EntryRepository - readEntries', () {
    setUp(() async {
      if (!db.isOpen) {
        db = await Isar.open([TabsSchema, EntrySchema], directory: '');
      }
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab('another t', 'another sub');

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.first;
      await entryRepository.addEntry(tab.id, 'entry title', 'entry subtitle');
      await entryRepository.addEntry(tab.id, 'wonderful day', 'have a laugh');
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
      final result = await entryRepository.readEntries(tab.id);

      // Assert
      expect(result, entriesDTO);
    });
  });

  group('EntryRepository - readAllEntries', () {
    setUp(() async {
      if (!db.isOpen) {
        db = await Isar.open([TabsSchema, EntrySchema], directory: '');
      }
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab('title', 'subtitle');
      await tabsRepository.addTab('not a title', 'not a subtitle');
      await tabsRepository.addTab('another t', 'another sub');

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'another t');
      await entryRepository.addEntry(tab.id, 'entry title', 'entry subtitle');
      await entryRepository.addEntry(tab.id, 'wonderful day', 'have a laugh');
    });

    test('should return List<EntryDTO> when readAllEntries is called',
        () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tempTab = tabs.firstWhere((e) => e.title == 'title');
      await entryRepository.addEntry(tempTab.id, 'fernando', 'say my name');

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
      if (!db.isOpen) {
        db = await Isar.open([TabsSchema, EntrySchema], directory: '');
      }
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab('title', 'subtitle');
      await tabsRepository.addTab('not a title', 'not a subtitle');
      await tabsRepository.addTab('another t', 'another sub');

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'another t');
      await entryRepository.addEntry(tab.id, 'entry title', 'entry subtitle');
      await entryRepository.addEntry(tab.id, 'wonderful day', 'have a laugh');
    });

    test('should return int when updateEntry is called', () async {
      // Arrange
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'entry title');

      // Act
      final result = await entryRepository.updateEntry(
        entry.id,
        0,
        'sunshine',
        'under the day sky',
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
        entryTwo.id,
        0,
        'moonshine',
        'under the night sky',
      );

      // Assert
      final result = await db.entrys.where().sortByTimestamp().findAll();
      expect(result, updatedEntries);
    });
  });

  group('EntryRepository - deleteEntry', () {
    setUp(() async {
      if (!db.isOpen) {
        db = await Isar.open([TabsSchema, EntrySchema], directory: '');
      }
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab('title', 'subtitle');
      await tabsRepository.addTab('not a title', 'not a subtitle');
      await tabsRepository.addTab('another t', 'another sub');

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'another t');
      await entryRepository.addEntry(tab.id, 'entry title', 'entry subtitle');
      await entryRepository.addEntry(tab.id, 'wonderful day', 'have a laugh');
    });

    test('should return bool when deleteEntry is called', () async {
      // Arrange
      final entries = await db.entrys.where().findAll();
      final entry = entries.firstWhere((e) => e.title == 'entry title');

      // Act
      final result = await entryRepository.deleteEntry(0, entry.id);

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
      await entryRepository.deleteEntry(entry.tabId, entry.id);

      // Assert
      final tab = await tabsRepository.getTab(entryTwo.tabId);
      final tabResult = tab.entries.length;
      expect(await entryRepository.readAllEntries(), entriesDTO);
      expect(tabResult, 1);
    });
  });

  group('EntryRepository - deleteEntries', () {
    setUp(() async {
      if (!db.isOpen) {
        db = await Isar.open([TabsSchema, EntrySchema], directory: '');
      }
      tabsRepository = TabsRepository(db);
      entryRepository = EntryRepository(db);

      await db.writeTxn(() => db.clear());
      await tabsRepository.addTab('another t', 'another sub');
      await tabsRepository.addTab('test', 'sub test');

      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'another t');
      await entryRepository.addEntry(tab.id, 'entry title', 'entry subtitle');
      await entryRepository.addEntry(tab.id, 'wonderful day', 'have a laugh');
      final tabTwo = tabs.firstWhere((e) => e.title == 'test');
      await entryRepository.addEntry(tabTwo.id, 'neon', 'moon');
    });

    test('should return bool when deleteEntries is called', () async {
      // Arrange
      final tabs = await db.tabs.where().findAll();
      final tab = tabs.firstWhere((e) => e.title == 'another t');

      // Act
      final result = await entryRepository.deleteEntries(tab.id);

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
      await entryRepository.deleteEntries(tab.id);

      // Assert
      final newTabs = await db.tabs.where().findAll();
      final newTab = newTabs.firstWhere((e) => e.title == 'test');
      final tabResult = newTab.entryIds;
      expect(tabResult, null);
    });
  });
}
