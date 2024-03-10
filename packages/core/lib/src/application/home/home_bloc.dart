import 'package:bloc/bloc.dart';
import 'package:core/src/repositories/interfaces/entry/i_entry_repository.dart';
import 'package:core/src/repositories/interfaces/tabs/i_tabs_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

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
          emit(
            state.copyWith(
              isLoading: true,
            ),
          );

          final tabs = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tabs: tabs,
              isLoading: false,
            ),
          );
        },
        onGetTab: (value) async {
          emit(state.copyWith(isLoading: true));

          final tab = await _tabsRepository.getTab(value.tabId);

          emit(
            state.copyWith(
              tab: tab,
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
          final tabs = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tab: TabsDTO.empty(),
              tabs: tabs,
              isLoading: false,
              isAdded: false,
            ),
          );
        },
        onPressedAddEntry: (_) async {
          emit(
            state.copyWith(
              isLoading: true,
              isAdded: true,
            ),
          );

          final tab = state.tab;
          final entry = state.entry;

          await _entryRepository.addEntry(
            tab.id,
            entry.title,
            entry.subtitle,
          );

          final tabs = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tab: TabsDTO.empty(),
              tabs: tabs,
              entry: EntryDTO.empty(),
              isLoading: false,
              isAdded: false,
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
              entryCards: [],
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

          final entryCards = await _entryRepository.readEntries(value.tabId);
          final tabs = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tabs: tabs,
              entryCards: entryCards,
              isLoading: false,
              isDeleted: false,
            ),
          );
        },
        onPressedDeleteAllEntries: (value) async {
          emit(state.copyWith(isLoading: true));

          final result = await _entryRepository.deleteEntries(value.tabId);
          final tabs = await _tabsRepository.readTabs();

          if (result) {
            emit(
              state.copyWith(
                tabs: tabs,
                entryCards: [],
                isLoading: false,
              ),
            );
          } else {
            emit(
              state.copyWith(
                errorMessage: 'Tab entries failed to delete.',
              ),
            );
          }
        },
        onPressedDeleteAll: (_) async {
          emit(state.copyWith(isLoading: true));

          final result = await _tabsRepository.deleteTabs();

          if (result) {
            emit(
              state.copyWith(
                tab: TabsDTO.empty(),
                tabs: [],
                entry: EntryDTO.empty(),
                entryCards: null,
                isLoading: false,
                isValid: false,
              ),
            );
          } else {
            emit(state.copyWith(errorMessage: 'Failed to delete all tabs.'));
          }
        },
        onChangedTabTitle: (value) {
          final isValid = _validate(value.text);

          emit(
            state.copyWith(
              tab: state.tab.copyWith(title: value.text),
              isValid: isValid,
            ),
          );
        },
        onChangedTabSubtitle: (value) {
          var isValid = _validate(value.text);

          if (value.text.isEmpty) {
            isValid = true;
          }

          emit(
            state.copyWith(
              tab: state.tab.copyWith(subtitle: value.text),
              isValid: isValid,
            ),
          );
        },
        onChangedEntryTitle: (value) {
          final isValid = _validate(value.text);

          emit(
            state.copyWith(
              entry: state.entry.copyWith(title: value.text),
              isValid: isValid,
            ),
          );
        },
        onChangedEntrySubtitle: (value) {
          var isValid = _validate(value.text);

          if (value.text.isEmpty) {
            isValid = true;
          }

          emit(
            state.copyWith(
              entry: state.entry.copyWith(subtitle: value.text),
              isValid: isValid,
            ),
          );
        },
        onSubmitEditTab: (OnSubmitEditTab value) async {
          emit(state.copyWith(isLoading: true));

          final tab = state.tab;

          await _tabsRepository.updateTab(tab.id, tab.title, tab.subtitle);

          final tabs = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tab: TabsDTO.empty(),
              tabs: tabs,
              isLoading: false,
              isValid: false,
            ),
          );
        },
        onSubmitEditEntry: (OnSubmitEditEntry value) async {
          emit(state.copyWith(isLoading: true));

          final entry = state.entry;

          await _entryRepository.updateEntry(
            entry.id,
            entry.tabId,
            entry.title,
            entry.subtitle,
          );

          final tabs = await _tabsRepository.readTabs();
          final entryCards = await _entryRepository.readEntries(entry.tabId);

          emit(
            state.copyWith(
              tabs: tabs,
              entry: EntryDTO.empty(),
              entryCards: entryCards,
              isLoading: false,
              isValid: false,
            ),
          );
        },
        onPressedCancel: (_) {
          emit(
            state.copyWith(
              tab: TabsDTO.empty(),
              entry: EntryDTO.empty(),
              isValid: false,
            ),
          );
        },
        onUpdateTabId: (value) async {
          final tab = await _tabsRepository.getTab(value.id);
          emit(state.copyWith(tab: tab, isValid: false));
        },
        onUpdateEntry: (value) async {
          final entry = await _entryRepository.getEntry(value.id);
          emit(state.copyWith(entry: entry, isValid: false));
        },
      );
    });
  }

  final ITabsRepository _tabsRepository;
  final IEntryRepository _entryRepository;
}

bool _validate(String value) {
  final regex = RegExp(r'^[a-zA-Z0-9\s-?!,]+$');

  final result = value.isNotEmpty && regex.hasMatch(value);

  return result;
}
