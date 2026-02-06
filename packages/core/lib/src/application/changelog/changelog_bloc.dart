import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'changelog_event.dart';
part 'changelog_state.dart';
part 'changelog_bloc.freezed.dart';

@Injectable()
class ChangelogBloc extends Bloc<ChangelogEvent, ChangelogState> {
  final IChangelogRepository changelogRepository;

  ChangelogBloc(this.changelogRepository) : super(ChangelogState.initial()) {
    on<ChangelogEvent>(
      (event, emit) async {
        await event.map(
          fetch: (e) async {
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
          },
        );
      },
    );
  }
}
