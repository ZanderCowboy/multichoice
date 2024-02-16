import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/domain/entry/i_entry_repository.dart';
import 'package:multichoice/domain/export_domain.dart';
import 'package:multichoice/domain/tabs/i_tabs_repository.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

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
        onGetAllEntryCards: (_) async {
          emit(
            state.copyWith(
              isLoading: true,
            ),
          );

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
              entry: Entry.empty().copyWith(tabId: value.tabId),
              entryCards: entryCards,
              isLoading: false,
            ),
          );
        },
        onPressedAddTab: (value) async {
          emit(
            state.copyWith(
              isLoading: true,
            ),
          );

          emit(
            state.copyWith(
              isLoading: false,
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
            ),
          );

          emit(
            state.copyWith(
              isLoading: false,
              isAdded: true,
            ),
          );
          await _entryRepository.addEntry(
            value.tabId,
            value.title,
            value.subtitle,
          );

          emit(
            state.copyWith(
              entryCards: await _entryRepository.readEntries(value.tabId),
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

          emit(
            state.copyWith(
              tabs: await _tabsRepository.readTabs(),
              entryCards: [],
              isLoading: false,
              isDeleted: false,
            ),
          );
        },
        onLongPressedDeleteEntry: (value) async {
          emit(state.copyWith(isLoading: true));

          emit(
            state.copyWith(
              isLoading: false,
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
      );
    });
  }

  final ITabsRepository _tabsRepository;
  final IEntryRepository _entryRepository;
}
