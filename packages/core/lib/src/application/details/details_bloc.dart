import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'details_event.dart';
part 'details_state.dart';
part 'details_bloc.g.dart';

@Injectable()
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final ITabsRepository tabsRepository;
  final IEntryRepository entryRepository;

  DetailsBloc({
    required this.tabsRepository,
    required this.entryRepository,
  }) : super(DetailsState.initial()) {
    on<DetailsEvent>((event, emit) async {
      final isTab =
          state.parent == null && state.children != null && state.tabId != null;
      final isEntry =
          state.parent != null &&
          state.children == null &&
          state.entryId != null;

      switch (event) {
        case OnPopulateDetails(:final result):
          emit(state.copyWith(isLoading: true));

          if (result.isTab) {
            final tab = result.item as TabsDTO;
            final children = await entryRepository.readEntries(tabId: tab.id);

            emit(
              DetailsState.initial().copyWith(
                title: tab.title,
                subtitle: tab.subtitle,
                timestamp: tab.timestamp,
                children: children,
                tabId: tab.id,
              ),
            );
          } else {
            final entry = result.item as EntryDTO;
            final parentTab = await tabsRepository.getTab(tabId: entry.tabId);

            emit(
              DetailsState.initial().copyWith(
                title: entry.title,
                subtitle: entry.subtitle,
                timestamp: entry.timestamp,
                parent: parentTab,
                entryId: entry.id,
                tabId: parentTab.id,
              ),
            );
          }
        case OnChangeTitleDetails(:final value):
          emit(
            state.copyWith(
              title: value,
              // TODO: Add validation
              isValid: value.trim().isNotEmpty,
            ),
          );
        case OnChangeSubtitleDetails(:final value):
          emit(
            state.copyWith(
              subtitle: value,
              // TODO: Add validation
            ),
          );
        case OnToggleEditModeDetails():
          if (!state.isEditingMode) {
            emit(
              state.copyWith(
                isEditingMode: true,
              ),
            );
            return;
          }

          /// We're exiting edit mode, need to revert changes
          if (isTab) {
            final tab = await tabsRepository.getTab(tabId: state.tabId!);
            final children = await entryRepository.readEntries(
              tabId: state.tabId!,
            );
            emit(
              state.copyWith(
                title: tab.title,
                subtitle: tab.subtitle,
                children: children,
                deleteChildren: <int>[],
                isEditingMode: false,
              ),
            );
          } else if (isEntry) {
            final entry = await entryRepository.getEntry(
              entryId: state.entryId!,
            );
            emit(
              state.copyWith(
                title: entry.title,
                subtitle: entry.subtitle,
                isEditingMode: false,
              ),
            );
          }
        case OnDeleteChildDetails(:final id):
          final current = List<int>.from(state.deleteChildren ?? []);
          final currentChildren = List<EntryDTO>.from(state.children ?? []);
          final originalChildren = List<EntryDTO>.from(state.children ?? []);

          final isAlreadyMarked = current.contains(id);

          if (!isAlreadyMarked) {
            current.add(id);
            // Remove from children list when marked for deletion
            currentChildren.removeWhere((entry) => entry.id == id);
          } else {
            current.remove(id);

            // Add back to children list when unmarked for deletion
            final entryToRestore = originalChildren.firstWhere(
              (entry) => entry.id == id,
              orElse: () => throw Exception('Entry not found'),
            );

            // Only add if not already in the list
            final isAlreadyRestored = currentChildren.any(
              (entry) => entry.id == id,
            );
            if (!isAlreadyRestored) {
              currentChildren.add(entryToRestore);
            }
          }

          emit(
            state.copyWith(
              deleteChildren: current,
              children: currentChildren,
            ),
          );
        case OnDeleteDetails():
          emit(state.copyWith(isLoading: true));

          bool deleteSuccess = false;
          if (isTab) {
            deleteSuccess = await tabsRepository.deleteTab(tabId: state.tabId!);
          } else if (isEntry) {
            deleteSuccess = await entryRepository.deleteEntry(
              tabId: state.tabId!,
              entryId: state.entryId!,
            );
          }

          // Only mark as deleted if the operation succeeded
          emit(
            state.copyWith(
              isLoading: false,
              isDeleted: deleteSuccess,
            ),
          );

        // TODO: If deleteSuccess is false, show error message to user
        case OnSubmitDetails():
          emit(
            state.copyWith(
              isLoading: true,
              isEditingMode: false,
            ),
          );

          if (isTab) {
            await tabsRepository.updateTab(
              id: state.tabId!,
              title: state.title,
              subtitle: state.subtitle,
            );

            for (final id in state.deleteChildren ?? <int>[]) {
              await entryRepository.deleteEntry(
                tabId: state.tabId!,
                entryId: id,
              );
            }
          } else if (isEntry) {
            await entryRepository.updateEntry(
              id: state.entryId!,
              tabId: state.parent!.id,
              title: state.title,
              subtitle: state.subtitle,
            );
          }

          emit(state.copyWith(isLoading: false));
      }
    });
  }
}
