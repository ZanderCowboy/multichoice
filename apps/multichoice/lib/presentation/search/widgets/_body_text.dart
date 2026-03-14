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
            color: context.theme.appColors.ternary,
          ),
          gap16,
          Text(
            state.query.isEmpty
                ? 'Start typing to search for collection and items'
                : 'No results found',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
