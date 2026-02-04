import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:models/models.dart';

import '../../../mocks.mocks.dart';

void main() {
  late MockSearchRepository mockSearchRepository;
  late SearchBloc searchBloc;
  final fixedDate = DateTime(2020, 1, 1, 12, 0, 0);

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    searchBloc = SearchBloc(mockSearchRepository);
  });

  tearDown(() {
    searchBloc.close();
  });

  group('SearchBloc', () {
    test('initial state is SearchState.initial()', () {
      expect(searchBloc.state, equals(SearchState.initial()));
    });

    blocTest<SearchBloc, SearchState>(
      'emits empty results when search query is empty',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const SearchEvent.search('')),
      expect: () => [
        SearchState(
          results: [],
          isLoading: false,
          errorMessage: null,
          query: '',
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits loading state and then results when search is successful',
      build: () {
        final mockResults = [
          SearchResult(
            isTab: true,
            item: TabsDTO(
              id: 1,
              title: 'Test Tab',
              subtitle: 'Test Subtitle',
              timestamp: fixedDate,
              entries: [],
            ),
            matchScore: 0.8,
          ),
          SearchResult(
            isTab: false,
            item: EntryDTO(
              id: 1,
              tabId: 1,
              title: 'Test Entry',
              subtitle: 'Test Entry Subtitle',
              timestamp: fixedDate,
            ),
            matchScore: 0.6,
          ),
        ];
        when(
          mockSearchRepository.search('test'),
        ).thenAnswer((_) async => mockResults);
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchEvent.search('test')),
      expect: () => [
        predicate<SearchState>(
          (state) =>
              state.results.isEmpty &&
              state.isLoading == true &&
              state.errorMessage == null &&
              state.query == 'test',
        ),
        predicate<SearchState>((state) {
          if (state.results.length != 2 ||
              state.isLoading != false ||
              state.errorMessage != null ||
              state.query != 'test') {
            return false;
          }
          final firstResult = state.results[0];
          final secondResult = state.results[1];
          return firstResult.isTab == true &&
              firstResult.item is TabsDTO &&
              (firstResult.item as TabsDTO).id == 1 &&
              (firstResult.item as TabsDTO).title == 'Test Tab' &&
              (firstResult.item as TabsDTO).subtitle == 'Test Subtitle' &&
              firstResult.matchScore == 0.8 &&
              secondResult.isTab == false &&
              secondResult.item is EntryDTO &&
              (secondResult.item as EntryDTO).id == 1 &&
              (secondResult.item as EntryDTO).title == 'Test Entry' &&
              (secondResult.item as EntryDTO).subtitle ==
                  'Test Entry Subtitle' &&
              secondResult.matchScore == 0.6;
        }),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits error state when search fails',
      build: () {
        when(
          mockSearchRepository.search('test'),
        ).thenThrow(Exception('Search failed'));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchEvent.search('test')),
      expect: () => [
        SearchState(
          results: [],
          isLoading: true,
          errorMessage: null,
          query: 'test',
        ),
        SearchState(
          results: [],
          isLoading: false,
          errorMessage: 'Exception: Search failed',
          query: '',
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits initial state when clear is called',
      build: () => searchBloc,
      act: (bloc) async {
        bloc.add(const SearchEvent.search('test'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SearchEvent.clear());
      },
      expect: () => [
        SearchState(
          results: [],
          isLoading: true,
          errorMessage: null,
          query: 'test',
        ),
        SearchState(
          results: [],
          isLoading: false,
          errorMessage: null,
          query: 'test',
        ),
        SearchState.initial(),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'refreshes search results successfully',
      build: () {
        final mockResults = [
          SearchResult(
            isTab: true,
            item: TabsDTO(
              id: 1,
              title: 'Updated Tab',
              subtitle: 'Updated Subtitle',
              timestamp: fixedDate,
              entries: [],
            ),
            matchScore: 0.9,
          ),
        ];
        when(
          mockSearchRepository.search('test'),
        ).thenAnswer((_) async => mockResults);
        return searchBloc;
      },
      act: (bloc) async {
        bloc.add(const SearchEvent.search('test'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SearchEvent.refresh());
      },
      expect: () => [
        // Initial search loading state
        predicate<SearchState>(
          (state) =>
              state.results.isEmpty &&
              state.isLoading == true &&
              state.errorMessage == null &&
              state.query == 'test',
        ),
        // Initial search results
        predicate<SearchState>((state) {
          if (state.results.length != 1 ||
              state.isLoading != false ||
              state.errorMessage != null ||
              state.query != 'test') {
            return false;
          }
          final result = state.results[0];
          return result.isTab == true &&
              result.item is TabsDTO &&
              (result.item as TabsDTO).id == 1 &&
              (result.item as TabsDTO).title == 'Updated Tab' &&
              (result.item as TabsDTO).subtitle == 'Updated Subtitle' &&
              result.matchScore == 0.9;
        }),
        // Refresh loading state
        predicate<SearchState>((state) {
          if (state.results.length != 1 ||
              state.isLoading != true ||
              state.errorMessage != null ||
              state.query != 'test') {
            return false;
          }
          final result = state.results[0];
          return result.isTab == true &&
              result.item is TabsDTO &&
              (result.item as TabsDTO).id == 1 &&
              (result.item as TabsDTO).title == 'Updated Tab' &&
              (result.item as TabsDTO).subtitle == 'Updated Subtitle' &&
              result.matchScore == 0.9;
        }),
        // Final refresh results
        predicate<SearchState>((state) {
          if (state.results.length != 1 ||
              state.isLoading != false ||
              state.errorMessage != null ||
              state.query != 'test') {
            return false;
          }
          final result = state.results[0];
          return result.isTab == true &&
              result.item is TabsDTO &&
              (result.item as TabsDTO).id == 1 &&
              (result.item as TabsDTO).title == 'Updated Tab' &&
              (result.item as TabsDTO).subtitle == 'Updated Subtitle' &&
              result.matchScore == 0.9;
        }),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'does not refresh when query is empty',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const SearchEvent.refresh()),
      expect: () => <SearchState>[],
    );

    blocTest<SearchBloc, SearchState>(
      'clears error state on new search',
      build: () {
        when(
          mockSearchRepository.search('fail'),
        ).thenThrow(Exception('Search failed'));
        when(
          mockSearchRepository.search('success'),
        ).thenAnswer((_) async => []);
        return searchBloc;
      },
      act: (bloc) async {
        bloc.add(const SearchEvent.search('fail'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SearchEvent.search('success'));
      },
      expect: () => [
        SearchState(
          results: [],
          isLoading: true,
          errorMessage: null,
          query: 'fail',
        ),
        SearchState(
          results: [],
          isLoading: false,
          errorMessage: 'Exception: Search failed',
          query: '',
        ),
        SearchState(
          results: [],
          isLoading: true,
          errorMessage: null,
          query: 'success',
        ),
        SearchState(
          results: [],
          isLoading: false,
          errorMessage: null,
          query: 'success',
        ),
      ],
    );
  });
}
