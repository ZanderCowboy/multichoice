import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';
import 'package:multichoice/presentation/home/home_page.dart';
import 'package:multichoice/utils/product_tour/tour_widget_wrapper.dart';
import 'package:ui_kit/ui_kit.dart';

class TutorialBody extends StatelessWidget {
  const TutorialBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.isLoading) {
          return CircularLoader.small();
        }

        final tabs = state.tabs ?? [];

        return Padding(
          padding: horizontal8,
          child: CustomScrollView(
            controller: ScrollController(),
            scrollBehavior: CustomScrollBehaviour(),
            slivers: [
              SliverPadding(
                padding: top4,
                sliver: SliverList.builder(
                  itemCount: tabs.length,
                  itemBuilder: (_, index) {
                    final tab = tabs[index];

                    if (tabs.isNotEmpty && index == 0) {
                      final step = context
                          .watch<ProductBloc>()
                          .state
                          .currentStep;

                      if (step == ProductTourStep.showCollection) {
                        return TourWidgetWrapper(
                          step: ProductTourStep.showCollection,
                          child: _HorizontalTab(tab: tab),
                        );
                      } else if (step ==
                          ProductTourStep.showCollectionActions) {
                        return TourWidgetWrapper(
                          step: ProductTourStep.showCollectionActions,
                          child: _HorizontalTab(tab: tab),
                        );
                      }

                      return _HorizontalTab(tab: tab);
                    }

                    return _HorizontalTab(tab: tab);
                  },
                ),
              ),
              const SliverPadding(
                padding: bottom24,
                sliver: SliverToBoxAdapter(
                  child: TourWidgetWrapper(
                    step: ProductTourStep.addNewCollection,
                    child: NewTab(),
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

class _HorizontalTab extends StatelessWidget {
  const _HorizontalTab({
    required this.tab,
  });

  final TabsDTO tab;

  @override
  Widget build(BuildContext context) {
    final entries = tab.entries;
    final isFirstTab =
        context.watch<ProductBloc>().state.tabs?.first.id == tab.id;

    return Card(
      margin: allPadding4,
      color: context.theme.appColors.primary,
      child: Padding(
        padding: allPadding2,
        child: SizedBox(
          height: UIConstants.horiTabHeight(context),
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            controller: ScrollController(),
            scrollBehavior: CustomScrollBehaviour(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  width: UIConstants.horiTabHeaderWidth(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: left4,
                        child: Text(
                          tab.title,
                          style: context.theme.appTextTheme.titleMedium
                              ?.copyWith(
                                fontSize: 16,
                              ),
                        ),
                      ),
                      if (tab.subtitle.isEmpty)
                        const SizedBox.shrink()
                      else
                        Padding(
                          padding: left4,
                          child: Text(
                            tab.subtitle,
                            style: context.theme.appTextTheme.subtitleMedium
                                ?.copyWith(fontSize: 12),
                          ),
                        ),
                      const Expanded(child: SizedBox()),
                      Center(
                        child: isFirstTab
                            ? TourWidgetWrapper(
                                step: ProductTourStep.showCollectionMenu,
                                child: MenuWidget(tab: tab),
                              )
                            : MenuWidget(tab: tab),
                      ),
                    ],
                  ),
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
              SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: entries.length + 1,
                itemBuilder: (context, index) {
                  if (index == entries.length) {
                    return isFirstTab
                        ? TourWidgetWrapper(
                            step: ProductTourStep.addNewItem,
                            child: NewEntry(
                              tabId: tab.id,
                            ),
                          )
                        : NewEntry(tabId: tab.id);
                  }

                  final entry = entries[index];

                  if (entries.isNotEmpty && index == 0 && isFirstTab) {
                    final step = context.watch<ProductBloc>().state.currentStep;

                    if (step == ProductTourStep.showItemsInCollection) {
                      return TourWidgetWrapper(
                        step: ProductTourStep.showItemsInCollection,
                        child: EntryCard(entry: entry, onDoubleTap: () {}),
                      );
                    } else if (step == ProductTourStep.showItemActions) {
                      return TourWidgetWrapper(
                        step: ProductTourStep.showItemActions,
                        child: EntryCard(entry: entry, onDoubleTap: () {}),
                      );
                    }

                    return EntryCard(entry: entry, onDoubleTap: () {});
                  }

                  return EntryCard(entry: entry, onDoubleTap: () {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
