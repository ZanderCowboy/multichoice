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

class HorizontalTab extends HookWidget {
  const HorizontalTab({
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
    final headerWidth = UIConstants.horiTabHeaderWidth(context);
    final entryListLeft = headerWidth + 8;
    final entryListRight = box.size.width;
    if (localPosition.dx < entryListLeft || localPosition.dx > entryListRight) {
      return null;
    }
    final entryWidth = UIConstants.horiTabHeight(context) / 2;
    final relativeX = localPosition.dx - entryListLeft;
    final entryIndex = (relativeX / entryWidth).floor();
    final positionInEntry = relativeX - (entryIndex * entryWidth);
    final isInRightHalf = positionInEntry > entryWidth / 2;
    final calculatedIndex = isInRightHalf ? entryIndex + 1 : entryIndex;
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
          height: UIConstants.horiTabHeight(context),
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            scrollBehavior: CustomScrollBehaviour(),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: TabHeader(
                  tab: tab,
                  isEditMode: isEditMode,
                  dragIndex: dragIndex,
                  layout: TabHeaderLayout.horizontal,
                ),
              ),
              SliverToBoxAdapter(
                child: VerticalDivider(
                  color: context.theme.appColors.secondaryLight,
                  thickness: 2,
                  indent: 4,
                  endIndent: 4,
                ),
              ),
              if (isEditMode && entries.isNotEmpty)
                SliverReorderableList(
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
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final showPlaceholderBefore = insertIndex == index;
                    final entryWidth = UIConstants.horiTabHeight(context) / 2;
                    return SizedBox(
                      key: ValueKey(entry.id),
                      width: showPlaceholderBefore
                          ? entryWidth * 2
                          : entryWidth,
                      child: Row(
                        children: [
                          if (showPlaceholderBefore)
                            SizedBox(
                              width: entryWidth,
                              child: const TabPlaceholderCard(),
                            ),
                          SizedBox(
                            width: entryWidth,
                            child: EntryCard(
                              entry: entry,
                              onDoubleTap: () {},
                              isEditMode: isEditMode,
                              dragIndex: index,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              if (isEditMode &&
                  entries.isNotEmpty &&
                  insertIndex == entries.length)
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: UIConstants.horiTabHeight(context) / 2,
                    child: const TabPlaceholderCard(),
                  ),
                ),
              if (!(isEditMode && entries.isNotEmpty))
                if (isEditMode && entries.isEmpty && isActiveDropTarget)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: UIConstants.horiTabHeight(context) / 2,
                      child: const TabPlaceholderCard(),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: UIConstants.horiTabHeight(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < entries.length; i++) ...[
                            SizedBox(
                              width: UIConstants.horiTabHeight(context) / 2,
                              child: EntryCard(
                                entry: entries[i],
                                isEditMode: isEditMode,
                                onDoubleTap: () async {
                                  context.read<HomeBloc>().add(
                                    HomeEvent.onUpdateEntry(entries[i].id),
                                  );
                                  await context.router.push(
                                    EditEntryPageRoute(ctx: context),
                                  );
                                },
                              ),
                            ),
                          ],
                          if (!isEditMode)
                            SizedBox(
                              width: UIConstants.horiTabHeight(context) / 2,
                              child: NewEntry(tabId: tab.id),
                            ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
