import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'changelog_event.dart';
part 'changelog_state.dart';
part 'changelog_bloc.g.dart';

@Injectable()
class ChangelogBloc extends Bloc<ChangelogEvent, ChangelogState> {
  final IChangelogRepository changelogRepository;

  ChangelogBloc(this.changelogRepository) : super(ChangelogState.initial()) {
    on<ChangelogEvent>((event, emit) async {
      switch (event) {
        case FetchChangelog():
          emit(state.copyWith(isLoading: true, errorMessage: null));

          final result = await changelogRepository.getChangelog();

          result.fold(
            (error) => emit(
              state.copyWith(
                isLoading: false,
                errorMessage: error.message,
                changelog: null,
              ),
            ),
            (changelog) => emit(
              state.copyWith(
                isLoading: false,
                errorMessage: null,
                changelog: changelog,
              ),
            ),
          );
      }
    });
  }
}
