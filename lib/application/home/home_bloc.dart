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
          emit(state.copyWith(isLoading: true));

          emit(
            state.copyWith(
              tabs: await _tabsRepository.readTabs(),
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

          final entryCards = await _entryRepository.readEntries(value.tabId);

          emit(
            state.copyWith(
              entry: EntryDTO.empty().copyWith(tabId: value.tabId),
              entryCards: entryCards,
              isLoading: false,
            ),
          );
        },
        onPressedAddTab: (value) async {
          emit(state.copyWith(isLoading: true, isAdded: true));

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
          emit(state.copyWith(isLoading: true, isAdded: true));
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
          emit(state.copyWith(isLoading: true, isDeleted: true));

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
          emit(state.copyWith(isLoading: true, isDeleted: true));

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
        onPressedTheme: (_) {
          emit(state.copyWith(isLoading: true));

          if (state.theme == 'light') {
            emit(state.copyWith(theme: 'dark', isLoading: false));
          } else {
            emit(state.copyWith(theme: 'light', isLoading: false));
          }
        },
      );
    });
  }

  final ITabsRepository _tabsRepository;
  final IEntryRepository _entryRepository;
}
