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
  TestWidgetsFlutterBinding.ensureInitialized();

  late HomeBloc homeBloc;
  late MockTabsRepository mockTabsRepository;
  late MockEntryRepository mockEntryRepository;
  late Isar db;
  late Clock clock;

  final timestamp = DateTime(2025, 03, 01, 12, 00, 00, 00, 00);

  setUpAll(() async {
    db = await configureTestCoreDependencies();
    await getit.registerSingleton<Clock>(Clock.fixed(timestamp));
    clock = getit<Clock>();

    getit.registerLazySingleton(() => TabsRepository(db, clock));
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
    final entryDTO = EntryDTO(
      id: 123,
      tabId: 123,
      title: 'title',
      subtitle: 'subtitle',
      timestamp: timestamp,
    );

    final initial = HomeState(
      tab: tabsDTO,
      tabs: null,
      entry: entryDTO,
      entryCards: null,
      isLoading: false,
      isDeleted: false,
      isAdded: false,
      isValid: false,
      errorMessage: 'errorMessage',
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
        isA<HomeState>()
            .having((s) => s.tabs, 'tabs', isA<List<TabsDTO>>())
            .having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tab: TabsDTO, isLoading: false] when onGetTab is added',
      build: () {
        when(mockTabsRepository.getTab(any)).thenAnswer((_) async => tabsDTO);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onGetTab(123)),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.tab, 'tab', isA<TabsDTO>())
            .having((s) => s.isLoading, 'isLoading', false),
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
        errorMessage: 'errorMessage');

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, isAdded: true, tab: TabsDTO, tabs: List<TabsDTO>, isLoading: false, isAdded: false] when onPressedAddTab is added',
      seed: () => initialState,
      build: () {
        when(mockTabsRepository.addTab(any, any)).thenAnswer((_) async => 0);
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
            .having((s) => s.tab, 'tab', isA<TabsDTO>())
            .having((s) => s.tabs, 'tabs', isA<List<TabsDTO>>())
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isAdded, 'isAdded', false),
      ],
      verify: (bloc) {
        verify(mockTabsRepository.addTab(any, any)).called(1);
        verify(mockTabsRepository.readTabs()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, isAdded: true, entry: EntryDTO, tabs: List<TabsDTO>, isLoading: false, isAdded: false] when onPressedAddEntry is added',
      build: () {
        when(mockEntryRepository.addEntry(any, any, any))
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
            .having((s) => s.entry, 'entry', isA<EntryDTO>())
            .having((s) => s.tabs, 'tabs', isA<List<TabsDTO>>())
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isAdded, 'isAdded', false),
      ],
      verify: (bloc) {
        verify(mockEntryRepository.addEntry(any, any, any)).called(1);
        verify(mockTabsRepository.readTabs()).called(1);
      },
    );
  });

  group('HomeBloc Delete Events', () {
    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, isDeleted: true, tabs: tabs, entryCards: [], isLoading: false, isDeleted: false] when onLongPressedDeleteTab is added',
      build: () {
        when(mockTabsRepository.deleteTab(any)).thenAnswer((_) async => true);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onLongPressedDeleteTab(4)),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.isDeleted, 'isDeleted', true),
        isA<HomeState>()
            .having((s) => s.tabs, 'tabs', isA<List<TabsDTO>>())
            .having((s) => s.entryCards, 'entryCards', isA<List<EntryDTO>>())
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isDeleted, 'isDeleted', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, isDeleted: true, tabs: tabs, entryCards: entryCards, isLoading: false, isDeleted: false] when onLongPressedDeleteEntry is added',
      build: () {
        when(mockEntryRepository.deleteEntry(any, any))
            .thenAnswer((_) async => true);
        when(mockEntryRepository.readEntries(any)).thenAnswer((_) async => []);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onLongPressedDeleteEntry(1, 2)),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.isDeleted, 'isDeleted', true),
        isA<HomeState>()
            .having((s) => s.tabs, 'tabs', isA<List<TabsDTO>>())
            .having((s) => s.entryCards, 'entryCards', isA<List<EntryDTO>>())
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isDeleted, 'isDeleted', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tabs: tabs, entryCards: [], isLoading: false] when onPressedDeleteAllEntries is added',
      build: () {
        when(mockEntryRepository.deleteEntries(any))
            .thenAnswer((_) async => true);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onPressedDeleteAllEntries(1)),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.tabs, 'tabs', isA<List<TabsDTO>>())
            .having((s) => s.entryCards, 'entryCards', isA<List<EntryDTO>>())
            .having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tab: TabsDTO.empty(), tabs: null, entry: EntryDTO.empty(), entryCards: null, isLoading: false, isValid: false] when onPressedDeleteAll is added',
      build: () {
        when(mockTabsRepository.deleteTabs()).thenAnswer((_) async => true);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onPressedDeleteAll()),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>(),
      ],
    );
  });

  group('HomeBloc Change Events', () {
    blocTest<HomeBloc, HomeState>(
      'emits [tab: updatedTab, isValid: isValid] when onChangedTabTitle is added',
      build: () => homeBloc,
      act: (bloc) => bloc.add(HomeEvent.onChangedTabTitle('New Title')),
      expect: () => [
        isA<HomeState>().having((s) => s.tab, 'tab', isA<TabsDTO>()).having(
            (s) => s.isValid, 'isValid', Validator.isValidInput('New Title')),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [tab: updatedTab, isValid: isValid] when onChangedTabSubtitle is added',
      build: () => homeBloc,
      act: (bloc) => bloc.add(HomeEvent.onChangedTabSubtitle('New Subtitle')),
      expect: () => [
        isA<HomeState>().having((s) => s.tab, 'tab', isA<TabsDTO>()).having(
            (s) => s.isValid,
            'isValid',
            Validator.isValidSubtitle('New Subtitle')),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [entry: updatedEntry, isValid: isValid] when onChangedEntryTitle is added',
      build: () => homeBloc,
      act: (bloc) => bloc.add(HomeEvent.onChangedEntryTitle('New Entry Title')),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.entry, 'entry', isA<EntryDTO>())
            .having((s) => s.isValid, 'isValid',
                Validator.isValidInput('New Entry Title')),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [entry: updatedEntry, isValid: isValid] when onChangedEntrySubtitle is added',
      build: () => homeBloc,
      act: (bloc) =>
          bloc.add(HomeEvent.onChangedEntrySubtitle('New Entry Subtitle')),
      expect: () => [
        isA<HomeState>()
            .having((s) => s.entry, 'entry', isA<EntryDTO>())
            .having((s) => s.isValid, 'isValid',
                Validator.isValidSubtitle('New Entry Subtitle')),
      ],
    );
  });

  group('HomeBloc Submit Events', () {
    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tab: TabsDTO.empty(), tabs: tabs, isLoading: false, isValid: false] when onSubmitEditTab is added',
      build: () {
        when(mockTabsRepository.updateTab(any, any, any))
            .thenAnswer((_) async => 1);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onSubmitEditTab()),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.tabs, 'tabs', isA<List<TabsDTO>>())
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, entry: EntryDTO.empty(), tabs: tabs, entryCards: entryCards, isLoading: false, isValid: false] when onSubmitEditEntry is added',
      build: () {
        when(mockEntryRepository.updateEntry(any, any, any, any))
            .thenAnswer((_) async => 1);
        when(mockTabsRepository.readTabs()).thenAnswer((_) async => []);
        when(mockEntryRepository.readEntries(any)).thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onSubmitEditEntry()),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.tabs, 'tabs', isA<List<TabsDTO>>())
            .having((s) => s.entryCards, 'entryCards', isA<List<EntryDTO>>())
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isValid, 'isValid', false),
      ],
    );
  });

  group('HomeBloc Cancel Events', () {
    blocTest<HomeBloc, HomeState>(
      'emits [tab: TabsDTO.empty(), entry: EntryDTO.empty(), isValid: false] when onPressedCancel is added',
      build: () => homeBloc,
      act: (bloc) => bloc.add(HomeEvent.onPressedCancel()),
      expect: () => [
        isA<HomeState>().having((s) => s.isValid, 'isValid', false),
      ],
    );
  });

  group('HomeBloc Update Events', () {
    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, tab: tab, isValid: false, isLoading: false] when onUpdateTabId is added',
      build: () {
        when(mockTabsRepository.getTab(any))
            .thenAnswer((_) async => TabsDTO.empty());
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onUpdateTabId(1)),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.isValid, 'isValid', false)
            .having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [isLoading: true, entry: entry, isValid: false, isLoading: false] when onUpdateEntry is added',
      build: () {
        when(mockEntryRepository.getEntry(any))
            .thenAnswer((_) async => EntryDTO.empty());
        return homeBloc;
      },
      act: (bloc) => bloc.add(HomeEvent.onUpdateEntry(1)),
      expect: () => [
        isA<HomeState>().having((s) => s.isLoading, 'isLoading', true),
        isA<HomeState>()
            .having((s) => s.isValid, 'isValid', false)
            .having((s) => s.isLoading, 'isLoading', false),
      ],
    );
  });
}
