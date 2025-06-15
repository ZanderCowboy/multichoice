import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:models/models.dart';

part 'details_event.dart';
part 'details_state.dart';
part 'details_bloc.freezed.dart';

@Injectable()
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final ITabsRepository tabsRepository;
  final IEntryRepository entryRepository;

  DetailsBloc({
    required this.tabsRepository,
    required this.entryRepository,
  }) : super(DetailsState.initial()) {
    on<DetailsEvent>(
      (event, emit) async {
        await event.map(
          onPopulate: (e) async {
            emit(state.copyWith(isLoading: true));

            final result = e.result;

            if (result.isTab) {
              final tab = result.item as TabsDTO;
              final children = await entryRepository.readEntries(tabId: tab.id);

              emit(state.copyWith(
                title: tab.title,
                subtitle: tab.subtitle,
                timestamp: tab.timestamp,
                parent: null,
                children: children,
                tabId: tab.id,
                entryId: null,
                isLoading: false,
              ));
            } else {
              final entry = result.item as EntryDTO;
              final parentTab = await tabsRepository.getTab(tabId: entry.tabId);

              emit(state.copyWith(
                title: entry.title,
                subtitle: entry.subtitle,
                timestamp: entry.timestamp,
                parent: parentTab,
                children: null,
                isLoading: false,
                entryId: entry.id,
                tabId: parentTab.id,
              ));
            }
          },
          onChangeTitle: (e) async {
            emit(state.copyWith(
              title: e.value,
              // TODO: Add validation
              isValid: e.value.trim().isNotEmpty,
            ));
          },
          onChangeSubtitle: (e) async {
            emit(state.copyWith(
              subtitle: e.value,
              // TODO: Add validation
            ));
          },
          onToggleEditMode: (e) async {
            if (state.isEditingMode) {
              /// We're exiting edit mode, need to revert changes
              if (state.parent == null && state.children != null) {
                final tab = await tabsRepository.getTab(tabId: state.tabId!);
                final children =
                    await entryRepository.readEntries(tabId: state.tabId!);
                emit(
                  state.copyWith(
                    title: tab.title,
                    subtitle: tab.subtitle,
                    children: children,
                    deleteChildren: <int>[],
                    isEditingMode: false,
                  ),
                );
              } else if (state.parent != null && state.children == null) {
                final entry =
                    await entryRepository.getEntry(entryId: state.entryId!);
                emit(
                  state.copyWith(
                    title: entry.title,
                    subtitle: entry.subtitle,
                    isEditingMode: false,
                  ),
                );
              }
            } else {
              emit(
                state.copyWith(
                  isEditingMode: true,
                ),
              );
            }
          },
          onDeleteChild: (e) async {
            final current = List<int>.from(state.deleteChildren ?? []);
            final currentChildren = List<EntryDTO>.from(state.children ?? []);

            if (!current.contains(e.id)) {
              current.add(e.id);
              // Remove from children list when marked for deletion
              currentChildren.removeWhere((entry) => entry.id == e.id);
            } else {
              current.remove(e.id);
              // Add back to children list when unmarked for deletion
              final entryToRestore = state.children?.firstWhere(
                (entry) => entry.id == e.id,
                orElse: () => throw Exception('Entry not found'),
              );
              if (entryToRestore != null) {
                currentChildren.add(entryToRestore);
              }
            }

            emit(state.copyWith(
              deleteChildren: current,
              children: currentChildren,
            ));
          },
          onSubmit: (e) async {
            emit(state.copyWith(
              isLoading: true,
              isEditingMode: false,
            ));

            if (state.parent == null && state.children != null) {
              if (state.tabId != null) {
                await tabsRepository.updateTab(
                  id: state.tabId!,
                  title: state.title,
                  subtitle: state.subtitle,
                );
              }
              for (final id in state.deleteChildren ?? <int>[]) {
                await entryRepository.deleteEntry(
                  tabId: state.tabId!,
                  entryId: id,
                );
              }
            } else if (state.parent != null && state.children == null) {
              if (state.entryId != null) {
                await entryRepository.updateEntry(
                  id: state.entryId!,
                  tabId: state.parent!.id,
                  title: state.title,
                  subtitle: state.subtitle,
                );
              }
            }

            emit(state.copyWith(isLoading: false));
          },
        );
      },
    );
  }
}
