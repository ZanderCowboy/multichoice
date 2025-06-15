import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
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
    on<HomeEvent>(_onEvent);
  }

  Future<void> _onEvent(HomeEvent event, Emitter<HomeState> emit) async {
    switch (event) {
      case OnGetTabs():
        await _handleGetTabs(emit);
      case OnGetTab(:final tabId):
        await _handleGetTab(tabId, emit);
      case OnPressedAddTab():
        await _handleAddTab(emit);
      case OnPressedAddEntry():
        await _handleAddEntry(emit);
      case OnLongPressedDeleteTab(:final tabId):
        await _handleDeleteTab(tabId, emit);
      case OnLongPressedDeleteEntry(:final tabId, :final entryId):
        await _handleDeleteEntry(tabId, entryId, emit);
      case OnPressedDeleteAllEntries(:final tabId):
        await _handleDeleteAllEntries(tabId, emit);
      case OnPressedDeleteAll():
        await _handleDeleteAll(emit);
      case OnChangedTabTitle(:final text):
        _handleTabTitleChange(text, emit);
      case OnChangedTabSubtitle(:final text):
        _handleTabSubtitleChange(text, emit);
      case OnChangedEntryTitle(:final text):
        _handleEntryTitleChange(text, emit);
      case OnChangedEntrySubtitle(:final text):
        _handleEntrySubtitleChange(text, emit);
      case OnSubmitEditTab():
        await _handleSubmitEditTab(emit);
      case OnSubmitEditEntry():
        await _handleSubmitEditEntry(emit);
      case OnPressedCancel():
        _handleCancel(emit);
      case OnUpdateTabId(:final id):
        await _handleUpdateTabId(id, emit);
      case OnUpdateEntry(:final id):
        await _handleUpdateEntry(id, emit);
      case OnRefresh():
        await _handleRefresh(emit);
      default:
    }
  }

  Future<void> _handleGetTabs(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tabs = await _tabsRepository.readTabs();
    emit(state.copyWith(tabs: tabs, isLoading: false));
  }

  Future<void> _handleGetTab(int tabId, Emitter<HomeState> emit) async {
    final tab = await _tabsRepository.getTab(tabId: tabId);
    emit(state.copyWith(tab: tab));
  }

  Future<void> _handleAddTab(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, isAdded: true));
    final tab = state.tab;
    final updatedTitle = Validator.trimWhitespace(tab.title);
    final updatedSubtitle = Validator.trimWhitespace(tab.subtitle);

    if (updatedTitle.isNotEmpty) {
      await _tabsRepository.addTab(
        title: updatedTitle,
        subtitle: updatedSubtitle,
      );
    } else {
      emit(state.copyWith(errorMessage: 'Failed to add collection.'));
    }

    final tabs = await _tabsRepository.readTabs();
    emit(state.copyWith(
      tab: TabsDTO.empty(),
      tabs: tabs,
      isLoading: false,
      isAdded: false,
    ));
  }

  Future<void> _handleAddEntry(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, isAdded: true));
    final tab = state.tab;
    final entry = state.entry;
    final updatedTitle = Validator.trimWhitespace(entry.title);
    final updatedSubtitle = Validator.trimWhitespace(entry.subtitle);

    if (updatedTitle.isNotEmpty) {
      await _entryRepository.addEntry(
        tabId: tab.id,
        title: updatedTitle,
        subtitle: updatedSubtitle,
      );
    } else {
      emit(state.copyWith(errorMessage: 'Failed to add item.'));
    }

    final tabs = await _tabsRepository.readTabs();
    emit(state.copyWith(
      tab: TabsDTO.empty(),
      tabs: tabs,
      entry: EntryDTO.empty(),
      isLoading: false,
      isAdded: false,
    ));
  }

  Future<void> _handleDeleteTab(int tabId, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, isDeleted: true));
    await _tabsRepository.deleteTab(tabId: tabId);
    final tabs = await _tabsRepository.readTabs();
    emit(state.copyWith(
      tabs: tabs,
      entryCards: [],
      isLoading: false,
      isDeleted: false,
    ));
  }

  Future<void> _handleDeleteEntry(
    int tabId,
    int entryId,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isDeleted: true));
    await _entryRepository.deleteEntry(tabId: tabId, entryId: entryId);
    final entryCards = await _entryRepository.readEntries(tabId: tabId);
    final tabs = await _tabsRepository.readTabs();
    emit(state.copyWith(
      tabs: tabs,
      entryCards: entryCards,
      isLoading: false,
      isDeleted: false,
    ));
  }

  Future<void> _handleDeleteAllEntries(
    int tabId,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _entryRepository.deleteEntries(tabId: tabId);
    final tabs = await _tabsRepository.readTabs();

    if (result) {
      emit(state.copyWith(
        tabs: tabs,
        entryCards: [],
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(errorMessage: 'Tab entries failed to delete.'));
    }
  }

  Future<void> _handleDeleteAll(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _tabsRepository.deleteTabs();

    if (result) {
      emit(state.copyWith(
        tab: TabsDTO.empty(),
        tabs: null,
        entry: EntryDTO.empty(),
        entryCards: null,
        isLoading: false,
        isValid: false,
      ));
    } else {
      emit(state.copyWith(errorMessage: 'Failed to delete all tabs.'));
    }
  }

  void _handleTabTitleChange(String text, Emitter<HomeState> emit) {
    final isValid = Validator.isValidInput(text);
    emit(state.copyWith(
      tab: state.tab.copyWith(title: text),
      isValid: isValid,
    ));
  }

  void _handleTabSubtitleChange(String text, Emitter<HomeState> emit) {
    final isValid = Validator.isValidSubtitle(text);
    emit(state.copyWith(
      tab: state.tab.copyWith(subtitle: text),
      isValid: isValid,
    ));
  }

  void _handleEntryTitleChange(String text, Emitter<HomeState> emit) {
    final isValid = Validator.isValidInput(text);
    emit(state.copyWith(
      entry: state.entry.copyWith(title: text),
      isValid: isValid,
    ));
  }

  void _handleEntrySubtitleChange(String text, Emitter<HomeState> emit) {
    final isValid = Validator.isValidSubtitle(text);
    emit(state.copyWith(
      entry: state.entry.copyWith(subtitle: text),
      isValid: isValid,
    ));
  }

  Future<void> _handleSubmitEditTab(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tab = state.tab;
    final updatedTitle = Validator.trimWhitespace(tab.title);
    final updatedSubtitle = Validator.trimWhitespace(tab.subtitle);

    await _tabsRepository.updateTab(
      id: tab.id,
      title: updatedTitle,
      subtitle: updatedSubtitle,
    );

    final tabs = await _tabsRepository.readTabs();
    emit(state.copyWith(
      tab: TabsDTO.empty(),
      tabs: tabs,
      isLoading: false,
      isValid: false,
    ));
  }

  Future<void> _handleSubmitEditEntry(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final entry = state.entry;
    final updatedTitle = Validator.trimWhitespace(entry.title);
    final updatedSubtitle = Validator.trimWhitespace(entry.subtitle);

    await _entryRepository.updateEntry(
      id: entry.id,
      tabId: entry.tabId,
      title: updatedTitle,
      subtitle: updatedSubtitle,
    );

    final tabs = await _tabsRepository.readTabs();
    final entryCards = await _entryRepository.readEntries(tabId: entry.tabId);
    emit(state.copyWith(
      tabs: tabs,
      entry: EntryDTO.empty(),
      entryCards: entryCards,
      isLoading: false,
      isValid: false,
    ));
  }

  void _handleCancel(Emitter<HomeState> emit) {
    emit(state.copyWith(
      tab: TabsDTO.empty(),
      entry: EntryDTO.empty(),
      isValid: false,
    ));
  }

  Future<void> _handleUpdateTabId(int id, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tab = await _tabsRepository.getTab(tabId: id);
    emit(state.copyWith(
      tab: tab,
      isValid: false,
      isLoading: false,
    ));
  }

  Future<void> _handleUpdateEntry(int id, Emitter<HomeState> emit) async {
    final entry = await _entryRepository.getEntry(entryId: id);
    emit(state.copyWith(entry: entry));
  }

  Future<void> _handleRefresh(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tabs = await _tabsRepository.readTabs();

    if (state.tab.id != 0) {
      final entryCards =
          await _entryRepository.readEntries(tabId: state.tab.id);
      emit(state.copyWith(
        tabs: tabs,
        entryCards: entryCards,
        isLoading: false,
      ));
    } else {
      emit(state.copyWith(
        tabs: tabs,
        isLoading: false,
      ));
    }
  }

  final ITabsRepository _tabsRepository;
  final IEntryRepository _entryRepository;
}
