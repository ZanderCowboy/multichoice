part of '../details_page.dart';

class _ChildrenListView extends StatelessWidget {
  const _ChildrenListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        final children = state.children;

        if (children == null) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                'No children available',
                style: context.theme.appTextTheme.bodyLarge,
              ),
            ),
          );
        }

        if (children.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                'No children found',
                style: context.theme.appTextTheme.bodyLarge,
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: children.length,
            (context, index) {
              final child = children[index];

              return Padding(
                padding: vertical8,
                child: Stack(
                  children: [
                    _ResultListTile(
                      title: child.title,
                      subtitle: child.subtitle,
                    ),
                    if (state.isEditingMode)
                      Positioned(
                        top: -8,
                        right: 2,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context.read<DetailsBloc>().add(
                                  DetailsEvent.onDeleteChild(child.id),
                                );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
