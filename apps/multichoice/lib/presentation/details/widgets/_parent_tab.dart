part of '../details_page.dart';

class _ParentTab extends StatelessWidget {
  const _ParentTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        final tab = state.parent;

        if (tab == null) {
          return const Text('Failed to load parent tab');
        }

        return _ResultListTile(
          title: tab.title,
          subtitle: tab.subtitle,
        );
      },
    );
  }
}
