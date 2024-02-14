import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/domain/export_domain.dart';
import 'package:multichoice/domain/tabs/i_tabs_repository.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

@Injectable()
//! TODO(@ZanderCowboy): Rename HomeBloc to TabsBloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._tabsRepository,
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
        // onUpdateTab: (value) {
        //   emit(
        //     state.copyWith(
        //       tab: value.tab,
        //     ),
        //   );
        // },
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
      );
    });
  }

  final ITabsRepository _tabsRepository;
}
