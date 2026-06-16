part of '../search_page.dart';

class _BodyText extends StatelessWidget {
  const _BodyText();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchBloc>().state;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: context.theme.appColors.textTertiary,
          ),
          gap16,
          Text(
            state.query.isEmpty
                ? context.t.search.emptyPrompt
                : context.t.search.noResults,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
