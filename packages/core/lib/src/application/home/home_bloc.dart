import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.g.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._tabsRepository,
    this._entryRepository,
    this._analyticsService,
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
      case OnToggleEditMode():
        _handleToggleEditMode(emit);
      case OnReorderTabs(:final oldIndex, :final newIndex):
        await _handleReorderTabs(oldIndex, newIndex, emit);
      case OnMoveEntryToTab(
          :final entryId,
          :final fromTabId,
          :final toTabId,
          :final insertIndex,
        ):
        await _handleMoveEntryToTab(
          entryId,
          fromTabId,
          toTabId,
          insertIndex,
          emit,
        );
      case OnReorderEntries(
        :final tabId,
        :final oldIndex,
        :final newIndex,
        :final isGrid,
      ):
        await _handleReorderEntries(tabId, oldIndex, newIndex, isGrid, emit);
    }
  }

  Future<void> _handleGetTabs(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tabs = await _tabsRepository.readTabs();

    // Log collection and item counts for analytics
    if (tabs.isNotEmpty) {
      final entries = await _entryRepository.readAllEntries();

      await _analyticsService.logEvent(
        CrudEventData(
          page: AnalyticsPage.home,
          entity: AnalyticsEntity.tab,
          action: AnalyticsAction.open,
          itemCount: tabs.length,
        ),
      );

      await _analyticsService.logEvent(
        CrudEventData(
          page: AnalyticsPage.home,
          entity: AnalyticsEntity.entry,
          action: AnalyticsAction.open,
          itemCount: entries.length,
        ),
      );
    }

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
      await _analyticsService.logEvent(
        const CrudEventData(
          page: AnalyticsPage.home,
          entity: AnalyticsEntity.tab,
          action: AnalyticsAction.create,
        ),
      );
    } else {
      emit(state.copyWith(errorMessage: 'Failed to add collection.'));
    }

    final tabs = await _tabsRepository.readTabs();
    emit(
      state.copyWith(
        tab: TabsDTO.empty(),
        tabs: tabs,
        isLoading: false,
        isAdded: false,
      ),
    );
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
      await _analyticsService.logEvent(
        CrudEventData(
          page: AnalyticsPage.home,
          entity: AnalyticsEntity.entry,
          action: AnalyticsAction.create,
          tabId: tab.id,
        ),
      );
    } else {
      emit(state.copyWith(errorMessage: 'Failed to add item.'));
    }

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
  }

  Future<void> _handleDeleteTab(int tabId, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, isDeleted: true));
    await _tabsRepository.deleteTab(tabId: tabId);
    await _analyticsService.logEvent(
      CrudEventData(
        page: AnalyticsPage.home,
        entity: AnalyticsEntity.tab,
        action: AnalyticsAction.delete,
        tabId: tabId,
      ),
    );
    final tabs = await _tabsRepository.readTabs();
    emit(
      state.copyWith(
        tabs: tabs,
        entryCards: [],
        isLoading: false,
        isDeleted: false,
      ),
    );
  }

  Future<void> _handleDeleteEntry(
    int tabId,
    int entryId,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isDeleted: true));
    await _entryRepository.deleteEntry(tabId: tabId, entryId: entryId);
    await _analyticsService.logEvent(
      CrudEventData(
        page: AnalyticsPage.home,
        entity: AnalyticsEntity.entry,
        action: AnalyticsAction.delete,
        tabId: tabId,
        entryId: entryId,
      ),
    );
    final entryCards = await _entryRepository.readEntries(tabId: tabId);
    final tabs = await _tabsRepository.readTabs();
    emit(
      state.copyWith(
        tabs: tabs,
        entryCards: entryCards,
        isLoading: false,
        isDeleted: false,
      ),
    );
  }

  Future<void> _handleDeleteAllEntries(
    int tabId,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _entryRepository.deleteEntries(tabId: tabId);
    final tabs = await _tabsRepository.readTabs();

    if (result) {
      await _analyticsService.logEvent(
        CrudEventData(
          page: AnalyticsPage.home,
          entity: AnalyticsEntity.allEntries,
          action: AnalyticsAction.delete,
          tabId: tabId,
        ),
      );
      emit(
        state.copyWith(
          tabs: tabs,
          entryCards: [],
          isLoading: false,
        ),
      );
    } else {
      emit(state.copyWith(errorMessage: 'Tab entries failed to delete.'));
    }
  }

  Future<void> _handleDeleteAll(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _tabsRepository.deleteTabs();

    if (result) {
      await _analyticsService.logEvent(
        const CrudEventData(
          page: AnalyticsPage.home,
          entity: AnalyticsEntity.allTabs,
          action: AnalyticsAction.delete,
        ),
      );
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
  }

  void _handleTabTitleChange(String text, Emitter<HomeState> emit) {
    final isValid = Validator.isValidInput(text);
    emit(
      state.copyWith(
        tab: state.tab.copyWith(title: text),
        isValid: isValid,
      ),
    );
  }

  void _handleTabSubtitleChange(String text, Emitter<HomeState> emit) {
    final isValid = Validator.isValidSubtitle(text);
    emit(
      state.copyWith(
        tab: state.tab.copyWith(subtitle: text),
        isValid: isValid,
      ),
    );
  }

  void _handleEntryTitleChange(String text, Emitter<HomeState> emit) {
    final isValid = Validator.isValidInput(text);
    emit(
      state.copyWith(
        entry: state.entry.copyWith(title: text),
        isValid: isValid,
      ),
    );
  }

  void _handleEntrySubtitleChange(String text, Emitter<HomeState> emit) {
    final isValid = Validator.isValidSubtitle(text);
    emit(
      state.copyWith(
        entry: state.entry.copyWith(subtitle: text),
        isValid: isValid,
      ),
    );
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
    await _analyticsService.logEvent(
      CrudEventData(
        page: AnalyticsPage.home,
        entity: AnalyticsEntity.tab,
        action: AnalyticsAction.update,
        tabId: tab.id,
      ),
    );

    final tabs = await _tabsRepository.readTabs();
    emit(
      state.copyWith(
        tab: TabsDTO.empty(),
        tabs: tabs,
        isLoading: false,
        isValid: false,
      ),
    );
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
    await _analyticsService.logEvent(
      CrudEventData(
        page: AnalyticsPage.home,
        entity: AnalyticsEntity.entry,
        action: AnalyticsAction.update,
        tabId: entry.tabId,
        entryId: entry.id,
      ),
    );

    final tabs = await _tabsRepository.readTabs();
    final entryCards = await _entryRepository.readEntries(tabId: entry.tabId);
    emit(
      state.copyWith(
        tabs: tabs,
        entry: EntryDTO.empty(),
        entryCards: entryCards,
        isLoading: false,
        isValid: false,
      ),
    );
  }

  void _handleCancel(Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        tab: TabsDTO.empty(),
        entry: EntryDTO.empty(),
        isValid: false,
      ),
    );
  }

  Future<void> _handleUpdateTabId(int id, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tab = await _tabsRepository.getTab(tabId: id);
    emit(
      state.copyWith(
        tab: tab,
        isValid: false,
        isLoading: false,
      ),
    );
  }

  Future<void> _handleUpdateEntry(int id, Emitter<HomeState> emit) async {
    final entry = await _entryRepository.getEntry(entryId: id);
    emit(state.copyWith(entry: entry));
  }

  Future<void> _handleRefresh(Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final tabs = await _tabsRepository.readTabs();

    if (state.tab.id != 0) {
      final entryCards = await _entryRepository.readEntries(
        tabId: state.tab.id,
      );
      emit(
        state.copyWith(
          tabs: tabs,
          entryCards: entryCards,
          isLoading: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          tabs: tabs,
          isLoading: false,
        ),
      );
    }
  }

  Future<void> _handleMoveEntryToTab(
    int entryId,
    int fromTabId,
    int toTabId,
    int insertIndex,
    Emitter<HomeState> emit,
  ) async {
    final tabs = state.tabs;
    if (tabs == null || tabs.isEmpty) return;

    final fromTabIndex = tabs.indexWhere((t) => t.id == fromTabId);
    final toTabIndex = tabs.indexWhere((t) => t.id == toTabId);
    if (fromTabIndex == -1 || toTabIndex == -1) return;

    final originalTabs = tabs;

    final updatedTabs = List<TabsDTO>.from(tabs);
    final fromTab = updatedTabs[fromTabIndex];
    final toTab = updatedTabs[toTabIndex];

    final fromEntries = List<EntryDTO>.from(fromTab.entries);
    final toEntries = List<EntryDTO>.from(toTab.entries);

    final entryIndexInFrom =
        fromEntries.indexWhere((entry) => entry.id == entryId);
    if (entryIndexInFrom == -1) return;

    final entry = fromEntries.removeAt(entryIndexInFrom);

    var targetIndex = insertIndex;
    if (targetIndex < 0 || targetIndex > toEntries.length) {
      targetIndex = toEntries.length;
    }

    toEntries.insert(targetIndex, entry.copyWith(tabId: toTabId));

    updatedTabs[fromTabIndex] = fromTab.copyWith(entries: fromEntries);
    updatedTabs[toTabIndex] = toTab.copyWith(entries: toEntries);

    // Optimistically update UI.
    emit(state.copyWith(tabs: updatedTabs));

    final success = await _entryRepository.moveEntryToTab(
      entryId: entryId,
      fromTabId: fromTabId,
      toTabId: toTabId,
      insertIndex: targetIndex,
    );

    if (!success) {
      // Roll back to original state if persistence fails.
      emit(state.copyWith(tabs: originalTabs));
      // TODO: surface an error message to the user.
    }
  }

  void _handleToggleEditMode(Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        isEditMode: !state.isEditMode,
      ),
    );
  }

  Future<void> _handleReorderTabs(
    int oldIndex,
    int newIndex,
    Emitter<HomeState> emit,
  ) async {
    final tabs = state.tabs;
    if (tabs == null || tabs.isEmpty) return;

    // Store the original tabs for rollback if needed
    final originalTabs = tabs;
    final updatedTabs = List<TabsDTO>.from(tabs);

    // Adjust newIndex if moving down
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Reorder the tabs
    final tab = updatedTabs.removeAt(oldIndex);
    updatedTabs.insert(newIndex, tab);

    // Update the UI optimistically
    emit(state.copyWith(tabs: updatedTabs));

    // Persist the new order to the database
    final tabIds = updatedTabs.map((t) => t.id).toList();
    final success = await _tabsRepository.updateTabsOrder(tabIds);
    if (success) {
      await _analyticsService.logEvent(
        CrudEventData(
          page: AnalyticsPage.home,
          entity: AnalyticsEntity.tab,
          action: AnalyticsAction.reorder,
          itemCount: tabIds.length,
        ),
      );
    }

    // If persistence failed, revert to original order
    if (!success) {
      emit(state.copyWith(tabs: originalTabs));
      // TODO: Show error message to user
    }
  }

  Future<void> _handleReorderEntries(
    int tabId,
    int oldIndex,
    int newIndex,
    bool isGrid,
    Emitter<HomeState> emit,
  ) async {
    final tabs = state.tabs;
    if (tabs == null) return;

    final tabIndex = tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;

    final tab = tabs[tabIndex];
    final entries = tab.entries;
    if (entries.isEmpty) return;

    // Store the original tabs for rollback if needed
    final originalTabs = tabs;
    final updatedEntries = List<EntryDTO>.from(entries);

    // Adjust newIndex based on source widget type
    var targetIndex = newIndex;
    if (!isGrid && oldIndex < newIndex) {
      // Standard list behavior: adjust when moving down
      targetIndex = newIndex - 1;
    }

    targetIndex = targetIndex.clamp(0, updatedEntries.length - 1);
    if (targetIndex == oldIndex) {
      return;
    }

    // Reorder the entries
    final entry = updatedEntries.removeAt(oldIndex);
    updatedEntries.insert(targetIndex, entry);

    // Update the tab with the new entries order
    final updatedTab = tab.copyWith(entries: updatedEntries);
    final updatedTabs = List<TabsDTO>.from(tabs);
    updatedTabs[tabIndex] = updatedTab;

    // Update the UI optimistically
    emit(state.copyWith(tabs: updatedTabs));

    // Persist the new order to the database
    final entryIds = updatedEntries.map((e) => e.id).toList();

    final success = await _entryRepository.updateEntriesOrder(
      tabId: tabId,
      entryIds: entryIds,
    );
    if (success) {
      await _analyticsService.logEvent(
        CrudEventData(
          page: AnalyticsPage.home,
          entity: AnalyticsEntity.entry,
          action: AnalyticsAction.reorder,
          tabId: tabId,
          itemCount: entryIds.length,
        ),
      );
    }

    // If persistence failed, revert to original order
    if (!success) {
      emit(state.copyWith(tabs: originalTabs));
      // TODO: Show error message to user
    }
  }

  final ITabsRepository _tabsRepository;
  final IEntryRepository _entryRepository;
  final IAnalyticsService _analyticsService;
}
