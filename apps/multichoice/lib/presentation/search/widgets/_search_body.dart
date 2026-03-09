// ignore_for_file: use_build_context_synchronously

part of '../search_page.dart';

class _SearchBody extends StatelessWidget {
  const _SearchBody({
    required this.onEdit,
    required this.onDelete,
  });

  final Future<void> Function(SearchResult? result) onEdit;
  final Future<void> Function(SearchResult? result) onDelete;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: allPadding16,
          itemCount: state.results.length,
          itemBuilder: (_, index) {
            final result = state.results[index];
            final isTab = result.isTab;
            final item = result.item;
            final title = isTab
                ? (item as TabsDTO).title
                : (item as EntryDTO).title;
            final subtitle = isTab
                ? (item as TabsDTO).subtitle
                : (item as EntryDTO).subtitle;
            return SearchResultCard(
              title: title,
              subtitle: subtitle,
              isTab: isTab,
              onTap: () async {
                await coreSl<IAnalyticsService>().logEvent(
                  SearchResultOpenedEventData(
                    page: AnalyticsPage.search,
                    resultType: result.isTab
                        ? AnalyticsEntity.tab
                        : AnalyticsEntity.entry,
                  ),
                );

                await context.router.push(
                  DetailsPageRoute(
                    result: result,
                    onBack: () {
                      context.read<SearchBloc>().add(
                        const SearchEvent.refresh(),
                      );
                      context.router.pop();
                    },
                  ),
                );
              },
              onEdit: () async {
                await onEdit(result);
                if (context.mounted) {
                  context.read<SearchBloc>().add(
                    SearchEvent.search(state.query),
                  );
                }
              },
              onDelete: () async {
                await onDelete(result);
                if (context.mounted) {
                  context.read<SearchBloc>().add(
                    const SearchEvent.refresh(),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
