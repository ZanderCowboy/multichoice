import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/domain/entry/models/entry.dart';
import 'package:multichoice/domain/tabs/i_tabs_repository.dart';
import 'package:multichoice/domain/tabs/models/tabs.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._tabsRepository,
  ) : super(HomeState.initial()) {
    on<HomeEvent>((event, emit) {
      event.map(
        onGetTabs: (_) {
          emit(
            state.copyWith(
              isLoading: true,
            ),
          );

          final tabs = _tabsRepository.readTabs();

          emit(
            state.copyWith(
              tabs: tabs,
              isLoading: false,
            ),
          );
        },
        onUpdateTab: (value) {
          emit(
            state.copyWith(
              tab: value.tab,
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
              // tab: value.tab,
              isLoading: false,
              isAdded: true,
            ),
          );

          await _tabsRepository.addTab(value.title, value.subtitle);

          emit(
            state.copyWith(
              tab: Tabs(
                uuid: '',
                title: value.title,
                subtitle: value.subtitle,
              ),
              tabs: _tabsRepository.readTabs(),
              isLoading: false,
              isAdded: false,
            ),
          );
        },
        onLongPressedDeleteTab: (value) async {
          emit(
            state.copyWith(
              isLoading: true,
            ),
          );

          emit(
            state.copyWith(
              tab: Tabs(
                uuid: value.tabId,
                title: 'title',
                subtitle: 'subtitle',
              ),
              isLoading: true,
              isDeleted: true,
            ),
          );
          await _tabsRepository.deleteTab(value.tabId);

          emit(
            state.copyWith(
              tabs: _tabsRepository.readTabs(),
              isLoading: false,
              isDeleted: false,
            ),
          );
        },
      );
    });
  }

  final ITabsRepository _tabsRepository;
}
