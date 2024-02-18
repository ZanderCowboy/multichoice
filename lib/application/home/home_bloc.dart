import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/domain/export_domain.dart';
import 'package:multichoice/repositories/interfaces/i_entry_repository.dart';
import 'package:multichoice/repositories/interfaces/i_tabs_repository.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._tabsRepository,
    this._entryRepository,
  ) : super(HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      await event.map(
        onGetTabs: (_) async {
          emit(state.copyWith(isLoading: true));

          final tabs = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tabs: tabs,
              isLoading: false,
            ),
          );
        },
        onGetAllEntryCards: (_) async {
          emit(state.copyWith(isLoading: true));

          final entries = await _entryRepository.readAllEntries();

          emit(
            state.copyWith(
              entryCards: entries,
              isLoading: false,
            ),
          );
        },
        onGetEntryCards: (value) async {
          emit(state.copyWith(isLoading: true));

          final entryCards = await _entryRepository.readEntries(value.tabId);

          emit(
            state.copyWith(
              tab: await _tabsRepository.getTab(value.tabId),
              entry: Entry.empty().copyWith(tabId: value.tabId),
              entryCards: entryCards,
              isLoading: false,
            ),
          );
        },
        onPressedAddTab: (_) async {
          emit(
            state.copyWith(
              isLoading: true,
              isAdded: true,
            ),
          );

          final tab = state.tab;
          await _tabsRepository.addTab(tab.title, tab.subtitle);

          emit(
            state.copyWith(
              tabs: await _tabsRepository.readTabs(),
              isLoading: false,
              isAdded: false,
              errorMessage: null,
            ),
          );
        },
        onPressedAddEntry: (value) async {
          emit(
            state.copyWith(
              isLoading: true,
              isAdded: true,
            ),
          );

          final entry = state.entry;

          await _entryRepository.addEntry(
            value.tabId,
            entry.title,
            entry.subtitle,
          );

          emit(
            state.copyWith(
              entryCards: await _entryRepository.readEntries(value.tabId),
              isLoading: false,
              isAdded: false,
              errorMessage: null,
            ),
          );
        },
        onLongPressedDeleteTab: (value) async {
          emit(
            state.copyWith(
              isLoading: true,
              isDeleted: true,
            ),
          );

          await _tabsRepository.deleteTab(value.tabId);

          emit(
            state.copyWith(
              tabs: await _tabsRepository.readTabs(),
              isLoading: false,
              isDeleted: false,
            ),
          );
        },
        onLongPressedDeleteEntry: (value) async {
          emit(
            state.copyWith(
              isLoading: true,
              isDeleted: true,
            ),
          );

          await _entryRepository.deleteEntry(
            value.tabId,
            value.entryId,
          );

          emit(
            state.copyWith(
              entryCards: await _entryRepository.readEntries(value.tabId),
              isLoading: false,
              isDeleted: false,
            ),
          );
        },
        onPressedDeleteAll: (_) async {
          emit(state.copyWith(isLoading: true));

          final tabs = await _tabsRepository.readTabs();

          for (final element in tabs) {
            await _tabsRepository.deleteTab(element.id);
          }

          emit(
            state.copyWith(
              tabs: null,
              entryCards: null,
              isLoading: false,
            ),
          );
        },
        onChangedTabTitle: (value) {
          emit(state.copyWith(isLoading: true, errorMessage: null));

          emit(
            state.copyWith(
              tab: state.tab.copyWith(title: value.text),
              isLoading: false,
            ),
          );
        },
        onChangedTabSubtitle: (value) {
          emit(state.copyWith(isLoading: true, errorMessage: null));

          emit(
            state.copyWith(
              tab: state.tab.copyWith(subtitle: value.text),
              isLoading: false,
            ),
          );
        },
        onChangedEntryTitle: (value) {
          emit(state.copyWith(isLoading: true, errorMessage: null));

          emit(
            state.copyWith(
              entry: state.entry.copyWith(title: value.text),
              isLoading: false,
            ),
          );
        },
        onChangedEntrySubtitle: (value) {
          emit(state.copyWith(isLoading: true, errorMessage: null));

          emit(
            state.copyWith(
              entry: state.entry.copyWith(subtitle: value.text),
              isLoading: false,
            ),
          );
        },
        onPressedCancel: (_) {
          emit(
            state.copyWith(
              tab: Tabs.empty(),
              entry: Entry.empty(),
              errorMessage: null,
            ),
          );
        },
        onUpdateTab: (value) async {
          final tab = await _tabsRepository.getTab(value.tabId);
          emit(state.copyWith(tab: tab));
        },
        onUpdateEntry: (value) async {
          final entry =
              await _entryRepository.getEntry(value.tabId, value.entryId);
          emit(state.copyWith(entry: entry));
        },
      );
    });
  }

  final ITabsRepository _tabsRepository;
  final IEntryRepository _entryRepository;
}
