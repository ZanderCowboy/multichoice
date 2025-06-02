import 'package:bloc/bloc.dart';
import 'package:core/src/repositories/interfaces/entry/i_entry_repository.dart';
import 'package:core/src/repositories/interfaces/tabs/i_tabs_repository.dart';
import 'package:core/src/utils/validator/validator.dart';
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
    on<HomeEvent>(
      (event, emit) async {
        switch (event) {
          case OnGetTabs():
            emit(state.copyWith(isLoading: true));

            final tabs = await _tabsRepository.readTabs();

            emit(
              state.copyWith(
                tabs: tabs,
                isLoading: false,
              ),
            );
            break;
          case OnGetTab(:final tabId):
            final tab = await _tabsRepository.getTab(tabId);

            emit(
              state.copyWith(
                tab: tab,
              ),
            );
            break;
          case OnPressedAddTab():
            emit(
              state.copyWith(
                isLoading: true,
                isAdded: true,
              ),
            );

            final tab = state.tab;

            final updatedTitle = Validator.trimWhitespace(tab.title);
            final updatedSubtitle = Validator.trimWhitespace(tab.subtitle);

            await _tabsRepository.addTab(updatedTitle, updatedSubtitle);
            final tabs = await _tabsRepository.readTabs();

            emit(
              state.copyWith(
                tab: TabsDTO.empty(),
                tabs: tabs,
                isLoading: false,
                isAdded: false,
              ),
            );
            break;
          case OnPressedAddEntry():
            emit(
              state.copyWith(
                isLoading: true,
                isAdded: true,
              ),
            );

            final tab = state.tab;
            final entry = state.entry;

            final updatedTitle = Validator.trimWhitespace(entry.title);
            final updatedSubtitle = Validator.trimWhitespace(entry.subtitle);

            await _entryRepository.addEntry(
              tab.id,
              updatedTitle,
              updatedSubtitle,
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
            break;
          case OnLongPressedDeleteTab(:final tabId):
            emit(
              state.copyWith(
                isLoading: true,
                isDeleted: true,
              ),
            );

            await _tabsRepository.deleteTab(tabId);
            final tabs = await _tabsRepository.readTabs();

            emit(
              state.copyWith(
                tabs: tabs,
                entryCards: [],
                isLoading: false,
                isDeleted: false,
              ),
            );
            break;
          case OnLongPressedDeleteEntry(:final tabId, :final entryId):
            emit(
              state.copyWith(
                isLoading: true,
                isDeleted: true,
              ),
            );

            await _entryRepository.deleteEntry(
              tabId,
              entryId,
            );

            final entryCards = await _entryRepository.readEntries(tabId);
            final tabs = await _tabsRepository.readTabs();

            emit(
              state.copyWith(
                tabs: tabs,
                entryCards: entryCards,
                isLoading: false,
                isDeleted: false,
              ),
            );
            break;
          case OnPressedDeleteAllEntries(:final tabId):
            emit(state.copyWith(isLoading: true));

            final result = await _entryRepository.deleteEntries(tabId);
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
            break;
          case OnPressedDeleteAll():
            emit(state.copyWith(isLoading: true));

            final result = await _tabsRepository.deleteTabs();

            if (result) {
              emit(
                state.copyWith(
                  tab: TabsDTO.empty(),
                  tabs: null,
                  entry: EntryDTO.empty(),
                  entryCards: null,
                  isLoading: false,
                  isValid: false,
                ),
              );
            } else {
              emit(state.copyWith(errorMessage: 'Failed to delete all tabs.'));
            }
            break;
          case OnChangedTabTitle(:final text):
            final isValid = Validator.isValidInput(text);

            emit(
              state.copyWith(
                tab: state.tab.copyWith(title: text),
                isValid: isValid,
              ),
            );
            break;
          case OnChangedTabSubtitle(:final text):
            var isValid = Validator.isValidSubtitle(text);

            emit(
              state.copyWith(
                tab: state.tab.copyWith(subtitle: text),
                isValid: isValid,
              ),
            );
            break;
          case OnChangedEntryTitle(:final text):
            final isValid = Validator.isValidInput(text);

            emit(
              state.copyWith(
                entry: state.entry.copyWith(title: text),
                isValid: isValid,
              ),
            );
            break;
          case OnChangedEntrySubtitle(:final text):
            var isValid = Validator.isValidSubtitle(text);

            emit(
              state.copyWith(
                entry: state.entry.copyWith(subtitle: text),
                isValid: isValid,
              ),
            );
            break;
          case OnSubmitEditTab():
            emit(state.copyWith(isLoading: true));

            final tab = state.tab;

            final updatedTitle = Validator.trimWhitespace(tab.title);
            final updatedSubtitle = Validator.trimWhitespace(tab.subtitle);

            await _tabsRepository.updateTab(
                tab.id, updatedTitle, updatedSubtitle);

            final tabs = await _tabsRepository.readTabs();

            emit(
              state.copyWith(
                tab: TabsDTO.empty(),
                tabs: tabs,
                isLoading: false,
                isValid: false,
              ),
            );
            break;
          case OnSubmitEditEntry():
            emit(state.copyWith(isLoading: true));

            final entry = state.entry;

            final updatedTitle = Validator.trimWhitespace(entry.title);
            final updatedSubtitle = Validator.trimWhitespace(entry.subtitle);

            await _entryRepository.updateEntry(
              entry.id,
              entry.tabId,
              updatedTitle,
              updatedSubtitle,
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
            break;
          case OnPressedCancel():
            emit(
              state.copyWith(
                tab: TabsDTO.empty(),
                entry: EntryDTO.empty(),
                isValid: false,
              ),
            );
            break;
          case OnUpdateTabId(:final id):
            emit(state.copyWith(isLoading: true));

            final tab = await _tabsRepository.getTab(id);

            emit(state.copyWith(
              tab: tab,
              isValid: false,
              isLoading: false,
            ));
            break;
          case OnUpdateEntry(:final id):
            emit(state.copyWith(isLoading: true));

            final entry = await _entryRepository.getEntry(id);

            emit(state.copyWith(
              entry: entry,
              isValid: false,
              isLoading: false,
            ));
            break;
          default:
        }
      },
    );
  }

  final ITabsRepository _tabsRepository;
  final IEntryRepository _entryRepository;
}
