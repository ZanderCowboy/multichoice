import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.g.dart';

@Injectable()
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchRepository) : super(SearchState.initial()) {
    on<SearchEvent>((event, emit) async {
      switch (event) {
        case Search(:final query):
          if (query.isEmpty) {
            emit(
              state.copyWith(
                results: [],
                isLoading: false,
                errorMessage: null,
                query: '',
              ),
            );
            return;
          }

          emit(
            state.copyWith(
              isLoading: true,
              errorMessage: null,
              query: query,
            ),
          );

          try {
            final results = await _searchRepository.search(query);
            emit(
              state.copyWith(
                results: results,
                isLoading: false,
                errorMessage: null,
                query: query,
              ),
            );
          } catch (e) {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: e.toString(),
                query: '',
              ),
            );
          }
        case Clear():
          emit(SearchState.initial());
        case Refresh():
          if (state.query.isEmpty) return;

          emit(state.copyWith(isLoading: true));

          try {
            final results = await _searchRepository.search(state.query);
            emit(
              state.copyWith(
                results: results,
                isLoading: false,
                errorMessage: null,
              ),
            );
          } catch (e) {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage: e.toString(),
              ),
            );
          }
      }
    });
  }

  final ISearchRepository _searchRepository;
}
