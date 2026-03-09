// ignore_for_file: use_build_context_synchronously

part of '../home_page.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await coreSl<IAnalyticsService>().logEvent(
          const UiActionEventData(
            page: AnalyticsPage.home,
            button: AnalyticsButton.search,
            action: AnalyticsAction.open,
          ),
        );
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
