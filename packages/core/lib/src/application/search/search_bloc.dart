import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

@Injectable()
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchRepository) : super(SearchState.initial()) {
    on<SearchEvent>((event, emit) async {
      await event.map(
        search: (e) async {
          if (e.query.isEmpty) {
            emit(state.copyWith(
              results: [],
              isLoading: false,
              errorMessage: null,
              query: '',
            ));
            return;
          }

          emit(state.copyWith(
            isLoading: true,
            errorMessage: null,
            query: e.query,
          ));

          try {
            final results = await _searchRepository.search(e.query);
            emit(state.copyWith(
              results: results,
              isLoading: false,
              errorMessage: null,
              query: e.query,
            ));
          } catch (e) {
            emit(state.copyWith(
              isLoading: false,
              errorMessage: e.toString(),
              query: '',
            ));
          }
        },
        clear: (e) async {
          emit(SearchState.initial());
        },
        refresh: (e) async {
          if (state.query.isEmpty) return;

          emit(state.copyWith(isLoading: true));

          try {
            final results = await _searchRepository.search(state.query);
            emit(state.copyWith(
              results: results,
              isLoading: false,
              errorMessage: null,
            ));
          } catch (e) {
            emit(state.copyWith(
              isLoading: false,
              errorMessage: e.toString(),
            ));
          }
        },
      );
    });
  }

  final ISearchRepository _searchRepository;
}
