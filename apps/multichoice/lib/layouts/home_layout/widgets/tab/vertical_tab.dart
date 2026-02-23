import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/layouts/home_layout/widgets/tab/tab_drop_target.dart';
import 'package:multichoice/layouts/home_layout/widgets/tab/tab_header.dart';
import 'package:multichoice/layouts/home_layout/widgets/tab/tab_placeholder_card.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:ui_kit/ui_kit.dart';

class VerticalTab extends HookWidget {
  const VerticalTab({
    required this.tab,
    this.isEditMode = false,
    this.dragIndex,
    super.key,
  });

  final TabsDTO tab;
  final bool isEditMode;
  final int? dragIndex;

  int? _getInsertIndex(BuildContext context, Offset globalOffset) {
    final entries = tab.entries;
    if (!isEditMode || entries.isEmpty) return null;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final localPosition = box.globalToLocal(globalOffset);
    const headerHeight = 80.0;
    const entryListTop = headerHeight;
    final entryListBottom = box.size.height;
    if (localPosition.dy < entryListTop || localPosition.dy > entryListBottom) {
      return null;
    }
    final entryHeight = UIConstants.entryHeight(context) + 8;
    final relativeY = localPosition.dy - entryListTop;
    final entryIndex = (relativeY / entryHeight).floor();
    final positionInEntry = relativeY - (entryIndex * entryHeight);
    final isInLowerHalf = positionInEntry > entryHeight / 2;
    final calculatedIndex = isInLowerHalf ? entryIndex + 1 : entryIndex;
    return calculatedIndex.clamp(0, entries.length);
  }

  @override
  Widget build(BuildContext context) {
    final entries = tab.entries;
    final scrollController = useScrollController();
    final previousEntriesLength = useState(entries.length);

    useEffect(
      () {
        if (entries.length > previousEntriesLength.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
        previousEntriesLength.value = entries.length;
        return null;
      },
      [entries.length],
    );

    return TabDropTarget(
      tab: tab,
      isEditMode: isEditMode,
      entries: entries,
      getInsertIndex: _getInsertIndex,
      builder: (insertIndex, {required isActiveDropTarget}) {
        return SizedBox(
          width: UIConstants.vertTabWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabHeader(
                tab: tab,
                isEditMode: isEditMode,
                dragIndex: dragIndex,
                layout: TabHeaderLayout.vertical,
              ),
              Divider(
                color: context.theme.appColors.secondaryLight,
                thickness: 2,
                indent: 4,
                endIndent: 4,
              ),
              gap4,
              Expanded(
                child: isEditMode && entries.isNotEmpty
                    ? ReorderableListView.builder(
                        scrollController: scrollController,
                        buildDefaultDragHandles: false,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: entries.length,
                        onReorder: (oldIndex, newIndex) {
                          context.read<HomeBloc>().add(
                            HomeEvent.onReorderEntries(
                              tab.id,
                              oldIndex,
                              newIndex,
                            ),
                          );
                        },
                        itemBuilder: (_, index) {
                          final entry = entries[index];
                          final showPlaceholderAbove = insertIndex == index;
                          final isLastItem = index == entries.length - 1;
                          final showPlaceholderBelow =
                              isLastItem && insertIndex == entries.length;
                          return Column(
                            key: ValueKey(entry.id),
                            children: [
                              if (showPlaceholderAbove)
                                const TabPlaceholderCard(),
                              EntryCard(
                                entry: entry,
                                onDoubleTap: () {},
                                isEditMode: isEditMode,
                                dragIndex: index,
                              ),
                              if (showPlaceholderBelow)
                                const TabPlaceholderCard(),
                            ],
                          );
                        },
                      )
                    : isEditMode && entries.isEmpty && isActiveDropTarget
                    ? SingleChildScrollView(
                        controller: scrollController,
                        child: const Padding(
                          padding: allPadding2,
                          child: TabPlaceholderCard(),
                        ),
                      )
                    : CustomScrollView(
                        controller: scrollController,
                        scrollBehavior: CustomScrollBehaviour(),
                        slivers: [
                          SliverList.builder(
                            itemCount: entries.length,
                            itemBuilder: (_, index) {
                              final entry = entries[index];
                              return BlocBuilder<HomeBloc, HomeState>(
                                builder: (context, _) {
                                  return EntryCard(
                                    entry: entry,
                                    isEditMode: isEditMode,
                                    onDoubleTap: () async {
                                      context.read<HomeBloc>().add(
                                        HomeEvent.onUpdateEntry(
                                          entry.id,
                                        ),
                                      );
                                      await context.router.push(
                                        EditEntryPageRoute(ctx: context),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          if (!isEditMode)
                            SliverToBoxAdapter(
                              child: NewEntry(tabId: tab.id),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
