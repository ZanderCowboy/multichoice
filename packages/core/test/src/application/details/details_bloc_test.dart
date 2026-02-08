import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late DetailsBloc detailsBloc;
  late MockTabsRepository mockTabsRepository;
  late MockEntryRepository mockEntryRepository;
  final fixedTimestamp = DateTime(2024, 1, 1);

  setUp(() {
    mockTabsRepository = MockTabsRepository();
    mockEntryRepository = MockEntryRepository();
    detailsBloc = DetailsBloc(
      tabsRepository: mockTabsRepository,
      entryRepository: mockEntryRepository,
    );
  });

  tearDown(() {
    detailsBloc.close();
  });

  group('DetailsBloc', () {
    test('initial state is correct', () {
      expect(detailsBloc.state, isA<DetailsState>());
      expect(detailsBloc.state.title, '');
      expect(detailsBloc.state.subtitle, '');
      expect(detailsBloc.state.isValid, false);
      expect(detailsBloc.state.isLoading, false);
      expect(detailsBloc.state.isEditingMode, false);
      expect(detailsBloc.state.parent, null);
      expect(detailsBloc.state.children, null);
      expect(detailsBloc.state.deleteChildren, <int>[]);
      expect(detailsBloc.state.tabId, null);
      expect(detailsBloc.state.entryId, null);
    });

    group('OnPopulate', () {
      final testTab = TabsDTO(
        id: 1,
        title: 'Test Tab',
        subtitle: 'Test Subtitle',
        timestamp: fixedTimestamp,
        entries: [],
        order: 0,
      );

      final testEntry = EntryDTO(
        id: 1,
        tabId: 1,
        title: 'Test Entry',
        subtitle: 'Test Entry Subtitle',
        timestamp: fixedTimestamp,
      );

      final testChildren = [
        EntryDTO(
          id: 1,
          tabId: 1,
          title: 'Child 1',
          subtitle: 'Subtitle 1',
          timestamp: fixedTimestamp,
        ),
        EntryDTO(
          id: 2,
          tabId: 1,
          title: 'Child 2',
          subtitle: 'Subtitle 2',
          timestamp: fixedTimestamp,
        ),
      ];

      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when populating with tab',
        build: () {
          when(mockEntryRepository.readEntries(tabId: testTab.id))
              .thenAnswer((_) async => testChildren);
          return detailsBloc;
        },
        act: (bloc) => bloc.add(DetailsEvent.onPopulate(
          SearchResult(isTab: true, item: testTab, matchScore: 1.0),
        )),
        expect: () => [
          isA<DetailsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<DetailsState>()
              .having((s) => s.title, 'title', testTab.title)
              .having((s) => s.subtitle, 'subtitle', testTab.subtitle)
              .having((s) => s.timestamp, 'timestamp', testTab.timestamp)
              .having((s) => s.parent, 'parent', null)
              .having((s) => s.children, 'children', testChildren)
              .having((s) => s.tabId, 'tabId', testTab.id)
              .having((s) => s.entryId, 'entryId', null)
              .having((s) => s.isLoading, 'isLoading', false),
        ],
      );

      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when populating with entry',
        build: () {
          when(mockTabsRepository.getTab(tabId: testEntry.tabId))
              .thenAnswer((_) async => testTab);
          return detailsBloc;
        },
        act: (bloc) => bloc.add(DetailsEvent.onPopulate(
          SearchResult(isTab: false, item: testEntry, matchScore: 1.0),
        )),
        expect: () => [
          isA<DetailsState>().having((s) => s.isLoading, 'isLoading', true),
          isA<DetailsState>()
              .having((s) => s.title, 'title', testEntry.title)
              .having((s) => s.subtitle, 'subtitle', testEntry.subtitle)
              .having((s) => s.timestamp, 'timestamp', testEntry.timestamp)
              .having((s) => s.parent, 'parent', testTab)
              .having((s) => s.children, 'children', null)
              .having((s) => s.tabId, 'tabId', testTab.id)
              .having((s) => s.entryId, 'entryId', testEntry.id)
              .having((s) => s.isLoading, 'isLoading', false),
        ],
      );
    });

    group('OnChangeTitle', () {
      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when changing title',
        build: () => detailsBloc,
        act: (bloc) => bloc.add(const DetailsEvent.onChangeTitle('New Title')),
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.title, 'title', 'New Title')
              .having((s) => s.isValid, 'isValid', true),
        ],
      );

      blocTest<DetailsBloc, DetailsState>(
        'emits invalid state when changing title to empty',
        build: () => detailsBloc,
        act: (bloc) => bloc.add(const DetailsEvent.onChangeTitle('')),
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.title, 'title', '')
              .having((s) => s.isValid, 'isValid', false),
        ],
      );
    });

    group('OnChangeSubtitle', () {
      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when changing subtitle',
        build: () => detailsBloc,
        act: (bloc) =>
            bloc.add(const DetailsEvent.onChangeSubtitle('New Subtitle')),
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.subtitle, 'subtitle', 'New Subtitle'),
        ],
      );
    });

    group('OnToggleEditMode', () {
      final testTab = TabsDTO(
        id: 1,
        title: 'Test Tab',
        subtitle: 'Test Subtitle',
        timestamp: fixedTimestamp,
        entries: [],
        order: 0,
      );

      final testEntry = EntryDTO(
        id: 1,
        tabId: 1,
        title: 'Test Entry',
        subtitle: 'Test Entry Subtitle',
        timestamp: fixedTimestamp,
      );

      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when entering edit mode',
        seed: () => DetailsState.initial(),
        build: () => detailsBloc,
        act: (bloc) => bloc.add(const DetailsEvent.onToggleEditMode()),
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.isEditingMode, 'isEditingMode', true),
        ],
      );

      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when exiting edit mode for tab',
        seed: () => DetailsState(
          title: 'Modified Title',
          subtitle: 'Modified Subtitle',
          timestamp: fixedTimestamp,
          isValid: true,
          isLoading: false,
          isEditingMode: true,
          parent: null,
          children: [],
          deleteChildren: [],
          tabId: 1,
          entryId: null,
        ),
        build: () {
          when(mockTabsRepository.getTab(tabId: 1))
              .thenAnswer((_) async => testTab);
          when(mockEntryRepository.readEntries(tabId: 1))
              .thenAnswer((_) async => []);
          return detailsBloc;
        },
        act: (bloc) => bloc.add(const DetailsEvent.onToggleEditMode()),
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.title, 'title', testTab.title)
              .having((s) => s.subtitle, 'subtitle', testTab.subtitle)
              .having((s) => s.isEditingMode, 'isEditingMode', false)
              .having((s) => s.deleteChildren, 'deleteChildren', <int>[]),
        ],
      );

      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when exiting edit mode for entry',
        seed: () => DetailsState(
          title: 'Modified Title',
          subtitle: 'Modified Subtitle',
          timestamp: fixedTimestamp,
          isValid: true,
          isLoading: false,
          isEditingMode: true,
          parent: testTab,
          children: null,
          deleteChildren: [],
          tabId: 1,
          entryId: 1,
        ),
        build: () {
          when(mockEntryRepository.getEntry(entryId: 1))
              .thenAnswer((_) async => testEntry);
          return detailsBloc;
        },
        act: (bloc) => bloc.add(const DetailsEvent.onToggleEditMode()),
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.title, 'title', testEntry.title)
              .having((s) => s.subtitle, 'subtitle', testEntry.subtitle)
              .having((s) => s.isEditingMode, 'isEditingMode', false),
        ],
      );
    });

    group('OnDeleteChild', () {
      final testChildren = [
        EntryDTO(
          id: 1,
          tabId: 1,
          title: 'Child 1',
          subtitle: 'Subtitle 1',
          timestamp: fixedTimestamp,
        ),
        EntryDTO(
          id: 2,
          tabId: 1,
          title: 'Child 2',
          subtitle: 'Subtitle 2',
          timestamp: fixedTimestamp,
        ),
      ];

      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when marking child for deletion',
        seed: () => DetailsState(
          title: 'Test',
          subtitle: 'Test',
          timestamp: fixedTimestamp,
          isValid: true,
          isLoading: false,
          isEditingMode: true,
          parent: null,
          children: testChildren,
          deleteChildren: [],
          tabId: 1,
          entryId: null,
        ),
        build: () => detailsBloc,
        act: (bloc) => bloc.add(const DetailsEvent.onDeleteChild(1)),
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.deleteChildren, 'deleteChildren', [1]).having(
                  (s) => s.children?.length, 'children.length', 1),
        ],
      );

      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when unmarking child for deletion',
        seed: () {
          print(
              'Test children: ${testChildren.map((e) => '${e.id}: ${e.title}').join(', ')}');
          return DetailsState(
            title: 'Test',
            subtitle: 'Test',
            timestamp: fixedTimestamp,
            isValid: true,
            isLoading: false,
            isEditingMode: true,
            parent: null,
            children: testChildren,
            deleteChildren: [1],
            tabId: 1,
            entryId: null,
          );
        },
        build: () => detailsBloc,
        act: (bloc) {
          print(
              'Current state children: ${bloc.state.children?.map((e) => '${e.id}: ${e.title}').join(', ')}');
          print('Current state deleteChildren: ${bloc.state.deleteChildren}');
          bloc.add(const DetailsEvent.onDeleteChild(1));
        },
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.deleteChildren, 'deleteChildren', <EntryDTO>[])
              .having((s) => s.children?.length, 'children.length', 2)
              .having((s) => s.children?[0].id, 'children[0].id', 1)
              .having((s) => s.children?[1].id, 'children[1].id', 2),
        ],
      );
    });

    group('OnSubmit', () {
      final testTab = TabsDTO(
        id: 1,
        title: 'Test Tab',
        subtitle: 'Test Subtitle',
        timestamp: fixedTimestamp,
        entries: [],
        order: 0,
      );

      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when submitting tab changes',
        seed: () => DetailsState(
          title: 'Modified Title',
          subtitle: 'Modified Subtitle',
          timestamp: fixedTimestamp,
          isValid: true,
          isLoading: false,
          isEditingMode: true,
          parent: null,
          children: [],
          deleteChildren: [2],
          tabId: 1,
          entryId: null,
        ),
        build: () {
          when(mockTabsRepository.updateTab(
            id: 1,
            title: 'Modified Title',
            subtitle: 'Modified Subtitle',
          )).thenAnswer((_) async => 1);
          when(mockEntryRepository.deleteEntry(
            tabId: 1,
            entryId: 2,
          )).thenAnswer((_) async => true);
          return detailsBloc;
        },
        act: (bloc) => bloc.add(const DetailsEvent.onSubmit()),
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.isEditingMode, 'isEditingMode', false),
          isA<DetailsState>().having((s) => s.isLoading, 'isLoading', false),
        ],
      );

      blocTest<DetailsBloc, DetailsState>(
        'emits correct state when submitting entry changes',
        seed: () => DetailsState(
          title: 'Modified Title',
          subtitle: 'Modified Subtitle',
          timestamp: fixedTimestamp,
          isValid: true,
          isLoading: false,
          isEditingMode: true,
          parent: testTab,
          children: null,
          deleteChildren: [],
          tabId: 1,
          entryId: 1,
        ),
        build: () {
          when(mockEntryRepository.updateEntry(
            id: 1,
            tabId: 1,
            title: 'Modified Title',
            subtitle: 'Modified Subtitle',
          )).thenAnswer((_) async => 1);
          return detailsBloc;
        },
        act: (bloc) => bloc.add(const DetailsEvent.onSubmit()),
        expect: () => [
          isA<DetailsState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.isEditingMode, 'isEditingMode', false),
          isA<DetailsState>().having((s) => s.isLoading, 'isLoading', false),
        ],
      );
    });
  });
}
