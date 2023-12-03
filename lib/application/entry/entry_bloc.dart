import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/domain/entry/i_entry_repository.dart';
import 'package:multichoice/presentation/home/home_page.dart';

part 'entry_event.dart';
part 'entry_state.dart';
part 'entry_bloc.freezed.dart';

@Injectable()
class EntryBloc extends Bloc<EntryEvent, EntryState> {
  EntryBloc(this._entryRepository) : super(EntryState.initial()) {
    on<EntryEvent>((event, emit) {
      event.map(
        onPressedAddEntry: (value) async {
          emit(
            state.copyWith(
              isLoading: true,
            ),
          );

          emit(
            state.copyWith(
              entryCard: value.entryCard,
              isLoading: false,
              isAdded: true,
            ),
          );
          await _entryRepository.addEntry(0, value.entryCard);

          emit(
            state.copyWith(
              isLoading: false,
              isAdded: false,
            ),
          );
        },
        onLongPressedDeleteEntry: (_) {
          emit(state.copyWith(isLoading: true));

          emit(
            state.copyWith(
              isLoading: false,
              isDeleted: true,
            ),
          );
          _entryRepository.deleteEntry(0, EntryCard());

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

  final IEntryRepository _entryRepository;
}
