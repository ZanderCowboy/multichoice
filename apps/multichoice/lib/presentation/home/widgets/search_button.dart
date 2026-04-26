import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:multichoice/app/export.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: () async {
        await coreSl<IAnalyticsService>().logEvent(
          const UiActionEventData(
            page: AnalyticsPage.home,
            button: AnalyticsButton.search,
            action: AnalyticsAction.open,
          ),
        );

        if (!context.mounted) return;

        await context.router.push(
          SearchPageRoute(
            onBack: () {
              context.read<HomeBloc>().add(
                const HomeEvent.refresh(),
              );
              context.router.pop();
            },
            onEdit: (result) async {
              if (result == null) return;

              if (result.isTab) {
                final tab = result.item as TabsDTO;
                context.read<HomeBloc>().add(
                  HomeEvent.onUpdateTabId(tab.id),
                );
                await context.router.push(
                  EditTabPageRoute(ctx: context),
                );
              } else {
                final entry = result.item as EntryDTO;
                context.read<HomeBloc>().add(
                  HomeEvent.onUpdateEntry(entry.id),
                );
                await context.router.push(
                  EditEntryPageRoute(ctx: context),
                );
              }
            },
            onDelete: (result) async {
              if (result == null) return;

              if (result.isTab) {
                final tab = result.item as TabsDTO;
                context.read<HomeBloc>().add(
                  HomeEvent.onLongPressedDeleteTab(tab.id),
                );
              } else {
                final entry = result.item as EntryDTO;
                context.read<HomeBloc>().add(
                  HomeEvent.onLongPressedDeleteEntry(
                    entry.tabId,
                    entry.id,
                  ),
                );
              }
            },
          ),
        );
      },
      tooltip: TooltipEnums.search.tooltip,
      icon: const Icon(Icons.search_outlined),
    );
  }
}
