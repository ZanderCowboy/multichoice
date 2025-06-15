import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/src/repositories/implementation/entry/entry_repository.dart';
import 'package:core/src/repositories/implementation/tabs/tabs_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:clock/clock.dart';
import '../../helpers/fake_path_provider_platform.dart';

import '../../injection.dart';
import '../../mocks.mocks.dart';

final getit = GetIt.instance;

void main() {
  late HomeBloc homeBloc;
  late MockTabsRepository mockTabsRepository;
  late MockEntryRepository mockEntryRepository;
  late Isar db;
  late Clock clock;

  final timestamp = DateTime(2025, 03, 01, 12, 00, 00, 00, 00);

  setUpAll(() async {
    db = await configureIsarInstance();
    await getit.registerSingleton<Clock>(Clock.fixed(timestamp));
    clock = getit<Clock>();

    getit.registerLazySingleton(() => TabsRepository(db));
    getit.registerLazySingleton(() => EntryRepository(db));
    getit.registerLazySingleton(() => FakePathProviderPlatform());
  });

  setUp(() {
    mockTabsRepository = MockTabsRepository();
    mockEntryRepository = MockEntryRepository();
    clock = Clock.fixed(timestamp);
    homeBloc = HomeBloc(mockTabsRepository, mockEntryRepository);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc Get Events', () {
    final tab1 = Tabs(
      uuid: 'uuid1',
      title: 'title',
      subtitle: 'subtitle',
      timestamp: timestamp,
      entryIds: [1, 2],
    );
    final tab2 = Tabs(
      uuid: 'uuid2',
      title: 'another title',
      subtitle: 'another subtitle',
      timestamp: timestamp,
      entryIds: [],
    );
    final entry1 = Entry(
      uuid: 'uuid3',
      tabId: 123,
      title: 'title',
      subtitle: 'subtitle',
      timestamp: timestamp,
    );
    final entry2 = Entry(
      uuid: 'uuid4',
      tabId: 345,
      title: 'title',
      subtitle: 'subtitle',
      timestamp: timestamp,
    );

    final tabsDTO = TabsDTO(
      id: 1,
      title: 'title',
      subtitle: 'subtitle',
      timestamp: timestamp,
      entries: [],
    );

    final initial = HomeState(
      tab: TabsDTO.empty(),
      tabs: null,
      entry: EntryDTO.empty(),
      entryCards: null,
      isLoading: false,
      isDeleted: false,
      isAdded: false,
      isValid: false,
      errorMessage: '',
    );

    setUp(() async {
      await db.writeTxn(() => db.clear());
      await db.writeTxn(() async {
        db.tabs.putAll([tab1, tab2]);
        db.entrys.putAll([entry1, entry2]);
      });
    });

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tabs: List<TabsDTO>, isLoading: false] when onGetTabs is added',
      seed: () => initial,
      build: () {
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => [tabsDTO]);
        return homeBloc;
      },
      act: (bloc) => withClock(Clock.fixed(timestamp), () {
        bloc.add(HomeEvent.onGetTabs());
      }),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>().having((s) => s.tabs, 'tabs', [tabsDTO]).having(
            (s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [tab: TabsDTO] when onGetTab is added',
      seed: () => initial,
      build: () {
        when(mockTabsRepository.getTab(tabId: anyNamed('tabId')))
            .thenAnswer((_) async => tabsDTO);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onGetTab(123)),
      expect: () => [
        isA<HomeState>().having((s) => s.tab, 'tab', tabsDTO),
      ],
    );
  });

  group('HomeBloc Add Events', () {
    final initialState = HomeState(
      tab: TabsDTO(
          id: 456,
          title: 'title',
          subtitle: 'subtitle',
          timestamp: timestamp,
          entries: []),
      tabs: [],
      entry: EntryDTO(
          id: 123,
          tabId: 456,
          title: 'title',
          subtitle: 'subtitle',
          timestamp: timestamp),
      entryCards: [],
      isLoading: false,
      isDeleted: false,
      isAdded: false,
      isValid: false,
      errorMessage: '',
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, isAdded: true, tab: TabsDTO.empty(), tabs: List<TabsDTO>, isLoading: false, isAdded: false] when onPressedAddTab is added',
      seed: () => initialState,
      build: () {
        when(mockTabsRepository.addTab(
                title: anyNamed('title'), subtitle: anyNamed('subtitle')))
            .thenAnswer((_) async => 0);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => withClock(clock, () {
        bloc.add(HomeEvent.onPressedAddTab());
      }),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.isAdded, 'isAdded', true),
        isA<HomeState>()
            .having((s) => s.tab.id, 'tab.id', 0)
            .having((s) => s.tab.title, 'tab.title', '')
            .having((s) => s.tab.subtitle, 'tab.subtitle', '')
            .having((s) => s.tabs, 'tabs', <TabsDTO>[])
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isAdded, 'isAdded', false),
      ],
      verify: (bloc) {
        verify(mockTabsRepository.addTab(
                title: anyNamed('title'), subtitle: anyNamed('subtitle')))
            .called(1);
        verify(mockTabsRepository.readTabs()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, isAdded: true, entry: EntryDTO.empty(), tabs: List<TabsDTO>, isLoading: false, isAdded: false] when onPressedAddEntry is added',
      seed: () => initialState,
      build: () {
        when(mockEntryRepository.addEntry(
                tabId: anyNamed('tabId'),
                title: anyNamed('title'),
                subtitle: anyNamed('subtitle')))
            .thenAnswer((_) async => 1);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => withClock(Clock.fixed(timestamp), () {
        bloc.add(HomeEvent.onPressedAddEntry());
      }),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.isAdded, 'isAdded', true),
        isA<HomeState>()
            .having((s) => s.entry.id, 'entry.id', 0)
            .having((s) => s.entry.tabId, 'entry.tabId', 0)
            .having((s) => s.entry.title, 'entry.title', '')
            .having((s) => s.entry.subtitle, 'entry.subtitle', '')
            .having((s) => s.tabs, 'tabs', <TabsDTO>[])
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isAdded, 'isAdded', false),
      ],
      verify: (bloc) {
        verify(mockEntryRepository.addEntry(
                tabId: anyNamed('tabId'),
                title: anyNamed('title'),
                subtitle: anyNamed('subtitle')))
            .called(1);
        verify(mockTabsRepository.readTabs()).called(1);
      },
    );
  });

  group('HomeBloc Delete Events', () {
    final initialState = HomeState(
      tab: TabsDTO.empty(),
      tabs: [],
      entry: EntryDTO.empty(),
      entryCards: [],
      isLoading: false,
      isDeleted: false,
      isAdded: false,
      isValid: false,
      errorMessage: '',
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, isDeleted: true, tabs: [], entryCards: [], isLoading: false, isDeleted: false] when onLongPressedDeleteTab is added',
      seed: () => initialState,
      build: () {
        when(mockTabsRepository.deleteTab(tabId: anyNamed('tabId')))
            .thenAnswer((_) async => true);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onLongPressedDeleteTab(4)),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.isDeleted, 'isDeleted', true),
        isA<HomeState>()
            .having((s) => s.tabs, 'tabs', <TabsDTO>[])
            .having((s) => s.entryCards, 'entryCards', <EntryDTO>[])
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isDeleted, 'isDeleted', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, isDeleted: true, tabs: [], entryCards: [], isLoading: false, isDeleted: false] when onLongPressedDeleteEntry is added',
      seed: () => initialState,
      build: () {
        when(mockEntryRepository.deleteEntry(
                tabId: anyNamed('tabId'), entryId: anyNamed('entryId')))
            .thenAnswer((_) async => true);
        when(mockEntryRepository.readEntries(tabId: anyNamed('tabId')))
            .thenAnswer((_) async => []);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onLongPressedDeleteEntry(1, 2)),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.isDeleted, 'isDeleted', true),
        isA<HomeState>()
            .having((s) => s.tabs, 'tabs', <TabsDTO>[])
            .having((s) => s.entryCards, 'entryCards', <EntryDTO>[])
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isDeleted, 'isDeleted', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tabs: [], entryCards: [], isLoading: false] when onPressedDeleteAllEntries is added',
      seed: () => initialState,
      build: () {
        when(mockEntryRepository.deleteEntries(tabId: anyNamed('tabId')))
            .thenAnswer((_) async => true);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onPressedDeleteAllEntries(1)),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>().having((s) => s.tabs, 'tabs', <TabsDTO>[]).having(
            (s) => s.entryCards,
            'entryCards',
            <EntryDTO>[]).having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tab: TabsDTO.empty(), tabs: null, entry: EntryDTO.empty(), entryCards: null, isLoading: false, isValid: false] when onPressedDeleteAll is added',
      seed: () => initialState,
      build: () {
        when(mockTabsRepository.deleteTabs()).thenAnswer((_) async => true);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onPressedDeleteAll()),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.tab.id, 'tab.id', 0)
            .having((s) => s.tab.title, 'tab.title', '')
            .having((s) => s.tab.subtitle, 'tab.subtitle', '')
            .having((s) => s.tabs, 'tabs', null)
            .having((s) => s.entry.id, 'entry.id', 0)
            .having((s) => s.entry.tabId, 'entry.tabId', 0)
            .having((s) => s.entry.title, 'entry.title', '')
            .having((s) => s.entry.subtitle, 'entry.subtitle', '')
            .having((s) => s.entryCards, 'entryCards', null)
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );
  });

  group('HomeBloc Change Events', () {
    final initialState = HomeState(
      tab: TabsDTO.empty(),
      tabs: null,
      entry: EntryDTO.empty(),
      entryCards: null,
      isLoading: false,
      isDeleted: false,
      isAdded: false,
      isValid: false,
      errorMessage: '',
    );

    blocTest<HomeBloc, HomeState>(
      'emits [tab: updatedTab, isValid: isValid] when onChangedTabTitle is added',
      seed: () => initialState,
      build: () => homeBloc,
      act: (bloc) => bloc.add(HomeEvent.onChangedTabTitle('New Title')),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.tab.title, 'tab.title', 'New Title')
            .having((s) => s.isValid, 'isValid',
                Validator.isValidInput('New Title')),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [tab: updatedTab, isValid: isValid] when onChangedTabSubtitle is added',
      seed: () => initialState,
      build: () => homeBloc,
      act: (bloc) => bloc.add(HomeEvent.onChangedTabSubtitle('New Subtitle')),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.tab.subtitle, 'tab.subtitle', 'New Subtitle')
            .having((s) => s.isValid, 'isValid',
                Validator.isValidSubtitle('New Subtitle')),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [entry: updatedEntry, isValid: isValid] when onChangedEntryTitle is added',
      seed: () => initialState,
      build: () => homeBloc,
      act: (bloc) => bloc.add(HomeEvent.onChangedEntryTitle('New Entry Title')),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.entry.title, 'entry.title', 'New Entry Title')
            .having((s) => s.isValid, 'isValid',
                Validator.isValidInput('New Entry Title')),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [entry: updatedEntry, isValid: isValid] when onChangedEntrySubtitle is added',
      seed: () => initialState,
      build: () => homeBloc,
      act: (bloc) =>
          bloc.add(HomeEvent.onChangedEntrySubtitle('New Entry Subtitle')),
      expect: () => [
        isA<HomeState>()
            .having(
                (s) => s.entry.subtitle, 'entry.subtitle', 'New Entry Subtitle')
            .having((s) => s.isValid, 'isValid',
                Validator.isValidSubtitle('New Entry Subtitle')),
      ],
    );
  });

  group('HomeBloc Submit Events', () {
    final initialState = HomeState(
      tab: TabsDTO(
          id: 456,
          title: 'title',
          subtitle: 'subtitle',
          timestamp: timestamp,
          entries: []),
      tabs: [],
      entry: EntryDTO(
          id: 123,
          tabId: 456,
          title: 'title',
          subtitle: 'subtitle',
          timestamp: timestamp),
      entryCards: [],
      isLoading: false,
      isDeleted: false,
      isAdded: false,
      isValid: false,
      errorMessage: '',
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tab: TabsDTO.empty(), tabs: [], isLoading: false, isValid: false] when onSubmitEditTab is added',
      seed: () => initialState,
      build: () {
        when(mockTabsRepository.updateTab(
                id: anyNamed('id'),
                title: anyNamed('title'),
                subtitle: anyNamed('subtitle')))
            .thenAnswer((_) async => 1);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onSubmitEditTab()),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.tab.id, 'tab.id', 0)
            .having((s) => s.tab.title, 'tab.title', '')
            .having((s) => s.tab.subtitle, 'tab.subtitle', '')
            .having((s) => s.tabs, 'tabs', <TabsDTO>[])
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, entry: EntryDTO.empty(), tabs: [], entryCards: [], isLoading: false, isValid: false] when onSubmitEditEntry is added',
      seed: () => initialState,
      build: () {
        when(mockEntryRepository.updateEntry(
                id: anyNamed('id'),
                tabId: anyNamed('tabId'),
                title: anyNamed('title'),
                subtitle: anyNamed('subtitle')))
            .thenAnswer((_) async => 1);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        when(mockEntryRepository.readEntries(tabId: anyNamed('tabId')))
            .thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onSubmitEditEntry()),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.entry.id, 'entry.id', 0)
            .having((s) => s.entry.tabId, 'entry.tabId', 0)
            .having((s) => s.entry.title, 'entry.title', '')
            .having((s) => s.entry.subtitle, 'entry.subtitle', ''),
      ],
    );
  });

  group('HomeBloc Cancel Events', () {
    final initialState = HomeState(
      tab: TabsDTO(
          id: 456,
          title: 'title',
          subtitle: 'subtitle',
          timestamp: timestamp,
          entries: []),
      tabs: [],
      entry: EntryDTO(
          id: 123,
          tabId: 456,
          title: 'title',
          subtitle: 'subtitle',
          timestamp: timestamp),
      entryCards: [],
      isLoading: false,
      isDeleted: false,
      isAdded: false,
      isValid: false,
      errorMessage: '',
    );

    blocTest<HomeBloc, HomeState>(
      'emits [tab: TabsDTO.empty(), entry: EntryDTO.empty(), isValid: false] when onPressedCancel is added',
      seed: () => initialState,
      build: () => homeBloc,
      act: (bloc) => bloc.add(HomeEvent.onPressedCancel()),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.tab.id, 'tab.id', 0)
            .having((s) => s.tab.title, 'tab.title', '')
            .having((s) => s.tab.subtitle, 'tab.subtitle', '')
            .having((s) => s.entry.id, 'entry.id', 0)
            .having((s) => s.entry.tabId, 'entry.tabId', 0)
            .having((s) => s.entry.title, 'entry.title', '')
            .having((s) => s.entry.subtitle, 'entry.subtitle', '')
            .having((s) => s.isValid, 'isValid', false),
      ],
    );
  });

  group('HomeBloc Update Events', () {
    final initialState = HomeState(
      tab: TabsDTO.empty(),
      tabs: null,
      entry: EntryDTO.empty(),
      entryCards: null,
      isLoading: false,
      isDeleted: false,
      isAdded: false,
      isValid: false,
      errorMessage: '',
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tab: TabsDTO.empty(), isValid: false, isLoading: false] when onUpdateTabId is added',
      seed: () => initialState,
      build: () {
        when(mockTabsRepository.getTab(tabId: anyNamed('tabId')))
            .thenAnswer((_) async => TabsDTO.empty());
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onUpdateTabId(1)),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.tab.id, 'tab.id', 0)
            .having((s) => s.tab.title, 'tab.title', '')
            .having((s) => s.tab.subtitle, 'tab.subtitle', '')
            .having((s) => s.tabs, 'tabs', null)
            .having((s) => s.entry.id, 'entry.id', 0)
            .having((s) => s.entry.tabId, 'entry.tabId', 0)
            .having((s) => s.entry.title, 'entry.title', '')
            .having((s) => s.entry.subtitle, 'entry.subtitle', '')
            .having((s) => s.entryCards, 'entryCards', null)
            .having((s) => s.isDeleted, 'isDeleted', false)
            .having((s) => s.isAdded, 'isAdded', false)
            .having((s) => s.isValid, 'isValid', false)
            .having((s) => s.errorMessage, 'errorMessage', ''),
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.tab.id, 'tab.id', 0)
            .having((s) => s.tab.title, 'tab.title', '')
            .having((s) => s.tab.subtitle, 'tab.subtitle', '')
            .having((s) => s.tabs, 'tabs', null)
            .having((s) => s.entry.id, 'entry.id', 0)
            .having((s) => s.entry.tabId, 'entry.tabId', 0)
            .having((s) => s.entry.title, 'entry.title', '')
            .having((s) => s.entry.subtitle, 'entry.subtitle', '')
            .having((s) => s.entryCards, 'entryCards', null)
            .having((s) => s.isDeleted, 'isDeleted', false)
            .having((s) => s.isAdded, 'isAdded', false)
            .having((s) => s.isValid, 'isValid', false)
            .having((s) => s.errorMessage, 'errorMessage', ''),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [entry: EntryDTO.empty()] when onUpdateEntry is added',
      seed: () => initialState,
      build: () {
        when(mockEntryRepository.getEntry(entryId: anyNamed('entryId')))
            .thenAnswer((_) async => EntryDTO.empty());
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onUpdateEntry(1)),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.entry.id, 'entry.id', 0)
            .having((s) => s.entry.tabId, 'entry.tabId', 0)
            .having((s) => s.entry.title, 'entry.title', '')
            .having((s) => s.entry.subtitle, 'entry.subtitle', ''),
      ],
    );
  });
}
