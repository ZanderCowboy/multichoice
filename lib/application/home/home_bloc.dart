import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/models/dto/export_dto.dart';
import 'package:multichoice/repositories/interfaces/entry/i_entry_repository.dart';
import 'package:multichoice/repositories/interfaces/tabs/i_tabs_repository.dart';

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
        onFetchAll: (_) async {
          emit(state.copyWith(isLoading: true));

          final tabsDTO = await _tabsRepository.readTabs();
          final entriesDTO = await _entryRepository.readAllEntries();

          emit(
            state.copyWith(
              tabs: tabsDTO,
              entryCards: entriesDTO,
              isLoading: false,
            ),
          );
        },
        onGetTabs: (_) async {
          emit(state.copyWith(isLoading: true));

          final tabsDTO = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tabs: tabsDTO,
              isLoading: false,
            ),
          );
        },
        onGetAllEntryCards: (_) async {
          emit(state.copyWith(isLoading: true));

          emit(
            state.copyWith(
              entryCards: await _entryRepository.readAllEntries(),
              isLoading: false,
            ),
          );
        },
        onGetEntryCards: (value) async {
          emit(state.copyWith(isLoading: true));

          final tab = await _tabsRepository.getTab(value.tabId);

          emit(
            state.copyWith(
              tab: tab,
              entry: EntryDTO.empty().copyWith(tabId: value.tabId),
              entryCards: await _entryRepository.readEntries(value.tabId),
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

          final tabsDTO = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tab: TabDTO.empty(),
              tabs: tabsDTO,
              isLoading: false,
              isAdded: false,
              isValid: false,
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
          final entryCards = await _entryRepository.readEntries(value.tabId);

          emit(
            state.copyWith(
              entry: EntryDTO.empty(),
              entryCards: entryCards,
              isLoading: false,
              isAdded: false,
              isValid: false,
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
          final tabs = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tabs: tabs,
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
        onPressedDeleteEntries: (value) async {
          emit(state.copyWith(isLoading: true));

          final tabId = value.id;
          final entries = await _entryRepository.readEntries(tabId) ?? [];

          for (final entry in entries) {
            await _entryRepository.deleteEntry(tabId, entry.id);
          }

          emit(
            state.copyWith(
              // entryCards: [],
              isLoading: false,
            ),
          );
        },
        onPressedDeleteAll: (_) async {
          emit(state.copyWith(isLoading: true));

          final tabsContent = await _tabsRepository.readTabs();
          final tabs = tabsContent.tabs ?? [];

          for (final element in tabs) {
            await _tabsRepository.deleteTab(element.id);
          }

          emit(
            state.copyWith(
              tab: TabDTO.empty(),
              tabs: TabsDTO.empty(),
              entry: EntryDTO.empty(),
              entryCards: null,
              isLoading: false,
            ),
          );
        },
        onChangedTabTitle: (value) {
          final isValid = _validate(value.text);
          emit(
            state.copyWith(
              isLoading: true,
              isValid: isValid,
              errorMessage: null,
            ),
          );

          emit(
            state.copyWith(
              tab: state.tab.copyWith(title: value.text),
              isLoading: false,
            ),
          );
        },
        onChangedTabSubtitle: (value) {
          final isValid = _validate(value.text);

          emit(
            state.copyWith(
              isLoading: true,
              isValid: isValid,
              errorMessage: null,
            ),
          );

          emit(
            state.copyWith(
              tab: state.tab.copyWith(subtitle: value.text),
              isLoading: false,
            ),
          );
        },
        onChangedEntryTitle: (value) {
          final isValid = _validate(value.text);
          emit(
            state.copyWith(
              isLoading: true,
              isValid: isValid,
              errorMessage: null,
            ),
          );

          emit(
            state.copyWith(
              entry: state.entry.copyWith(title: value.text),
              isLoading: false,
            ),
          );
        },
        onChangedEntrySubtitle: (value) {
          final isValid = _validate(value.text);
          emit(
            state.copyWith(
              isLoading: true,
              isValid: isValid,
              errorMessage: null,
            ),
          );

          emit(
            state.copyWith(
              entry: state.entry.copyWith(subtitle: value.text),
              isLoading: false,
            ),
          );
        },
        onEditTab: (_) async {
          emit(state.copyWith(isLoading: true));

          final tab = state.tab;

          await _tabsRepository.updateTab(tab.id, tab.title, tab.subtitle);

          final tabsDTO = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tabs: tabsDTO,
              isLoading: false,
              isValid: false,
              errorMessage: null,
            ),
          );
        },
        onEditEntry: (_) async {
          emit(state.copyWith(isLoading: true));

          final entry = state.entry;

          await _entryRepository.updateEntry(
            entry.id,
            entry.tabId,
            entry.title,
            entry.subtitle,
          );

          final entryCards = await _entryRepository.readEntries(entry.tabId);

          emit(
            state.copyWith(
              entryCards: entryCards,
              isLoading: false,
              isValid: false,
              errorMessage: null,
            ),
          );
        },
        onPressedCancelTab: (_) async {
          emit(state.copyWith(isLoading: true));

          final id = state.tab.id;

          final originalTab = await _tabsRepository.getTab(id);

          emit(
            state.copyWith(
              tab: originalTab,
              isValid: false,
              errorMessage: null,
            ),
          );

          emit(state.copyWith(isLoading: false));
        },
        onPressedCancelEntry: (_) {
          emit(
            state.copyWith(
              entry: EntryDTO.empty(),
              isValid: false,
              errorMessage: null,
            ),
          );
        },
        onUpdateTab: (value) async {
          final tab = await _tabsRepository.getTab(value.tabId);
          final entries = await _entryRepository.readEntries(value.tabId);
          emit(
            state.copyWith(
              tab: tab,
              entryCards: entries,
            ),
          );
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

bool _validate(String value) {
  final regex = RegExp(r'^[a-zA-Z\s-?!,]+$');

  final result = value.isNotEmpty && regex.hasMatch(value);

  return result;
}
