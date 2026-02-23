import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:ui_kit/ui_kit.dart';

typedef GetInsertIndex = int? Function(BuildContext context, Offset globalOffset);

class TabDropTarget extends HookWidget {
  const TabDropTarget({
    required this.tab,
    required this.isEditMode,
    required this.entries,
    required this.getInsertIndex,
    required this.builder,
    super.key,
  });

  final TabsDTO tab;
  final bool isEditMode;
  final List<EntryDTO> entries;
  final GetInsertIndex getInsertIndex;
  final Widget Function(
    int? insertIndex, {
    required bool isActiveDropTarget,
  }) builder;

  @override
  Widget build(BuildContext context) {
    final insertIndexState = useState<int?>(null);

    return DragTarget<({EntryDTO entry, int fromTabId})>(
      onWillAcceptWithDetails: (details) {
        final data = details.data;
        return isEditMode && data.fromTabId != tab.id;
      },
      onMove: (details) {
        if (!isEditMode || entries.isEmpty) {
          insertIndexState.value = null;
          return;
        }
        if (details.data.fromTabId == tab.id) {
          insertIndexState.value = null;
          return;
        }
        insertIndexState.value = getInsertIndex(context, details.offset);
      },
      onLeave: (_) {
        insertIndexState.value = null;
      },
      onAcceptWithDetails: (details) {
        if (!isEditMode) return;
        final data = details.data;
        final entry = data.entry;
        final insertIndex = insertIndexState.value ?? entries.length;
        insertIndexState.value = null;
        context.read<HomeBloc>().add(
              HomeEvent.onMoveEntryToTab(
                entry.id,
                data.fromTabId,
                tab.id,
                insertIndex,
              ),
            );
      },
      builder: (context, candidateData, rejectedData) {
        final isActiveDropTarget = isEditMode &&
            candidateData.isNotEmpty &&
            (candidateData.first?.fromTabId ?? tab.id) != tab.id;

        return Card(
          margin: allPadding4,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          color: context.theme.appColors.primary,
          shape: RoundedRectangleBorder(
            side: isActiveDropTarget
                ? BorderSide(
                    color: context.theme.appColors.ternary ??
                        Colors.transparent,
                    width: 2,
                  )
                : BorderSide.none,
            borderRadius: borderCircular5,
          ),
          child: Padding(
            padding: allPadding2,
            child: builder(
              insertIndexState.value,
              isActiveDropTarget: isActiveDropTarget,
            ),
          ),
        );
      },
    );
  }
}
