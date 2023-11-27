import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/domain/tabs/i_tabs_repository.dart';
import 'package:multichoice/presentation/home/home_page.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._tabsRepository) : super(HomeState.initial()) {
    on<HomeEvent>((event, emit) {
      event.map(
        onPressedAddTab: (value) async {
          emit(state.copyWith(isLoading: true));

          emit(
            state.copyWith(
              verticalTab: value.verticalTab,
              isLoading: false,
              isAdded: true,
            ),
          );
          await _tabsRepository.addTab(value.verticalTab);

          emit(
            state.copyWith(
              isLoading: false,
              isAdded: false,
            ),
          );
        },
        onLongPressedDeleteTab: (_) {
          emit(state.copyWith(isLoading: true));

          emit(
            state.copyWith(
              isLoading: false,
              isDeleted: true,
            ),
          );
          _tabsRepository.deleteTab(0);

          emit(
            state.copyWith(
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
