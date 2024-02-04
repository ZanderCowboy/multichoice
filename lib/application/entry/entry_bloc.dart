import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multichoice/domain/entry/i_entry_repository.dart';
import 'package:multichoice/domain/entry/models/entry.dart';

part 'entry_event.dart';
part 'entry_state.dart';
part 'entry_bloc.freezed.dart';

@Injectable()
class EntryBloc extends Bloc<EntryEvent, EntryState> {
  EntryBloc(
    this._entryRepository,
  ) : super(EntryState.initial()) {
    on<EntryEvent>((event, emit) {
      event.map(
        onGetEntryCards: (value) {
          emit(state.copyWith(isLoading: true));

          final entryCards = _entryRepository.readEntries(value.tabId) ?? [];

          final entry = entryCards.isNotEmpty
              ? entryCards.first
              : Entry.empty().copyWith(tabId: value.tabId);

          emit(
            state.copyWith(
              entry: entry,
              entryCards: entryCards,
              isLoading: false,
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
              entryCards: _entryRepository.readEntries(value.tabId) ?? [],
              isLoading: false,
              isAdded: false,
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
              entryCards: _entryRepository.readEntries(value.tabId) ?? [],
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
