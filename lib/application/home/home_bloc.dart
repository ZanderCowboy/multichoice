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
          final entries = await _entryRepository.readEntries(value.tabId);
          emit(
            state.copyWith(
              tab: tab,
              entryCards: entries,
              isLoading: false,
            ),
          );
        },
        onPressedAddTab: (value) async {
          emit(
            state.copyWith(
              isLoading: true,
              isAdded: true,
            ),
          );

          await _tabsRepository.addTab(value.title, value.subtitle);

          emit(
            state.copyWith(
              tabs: await _tabsRepository.readTabs(),
              isLoading: false,
              isAdded: false,
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

          await _entryRepository.addEntry(
            value.tabId,
            value.title,
            value.subtitle,
          );

          final entryCards = await _entryRepository.readEntries(
            value.tabId,
          );
          final tabs = await _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tabs: tabs,
              entryCards: entryCards,
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
        onPressedDeleteAll: (_) async {
          emit(state.copyWith(isLoading: true));

          final tabs = await _tabsRepository.readTabs();

          for (final element in tabs) {
            await _tabsRepository.deleteTab(element.id);
          }

          emit(
            state.copyWith(
              tab: TabsDTO.empty(),
              tabs: [],
              entryCards: null,
              isLoading: false,
            ),
          );
        },
      );
    });
  }

  final ITabsRepository _tabsRepository;
  final IEntryRepository _entryRepository;
}
