part of '../details_page.dart';

// TODO: Use this widget
// ignore: unused_element
class _ChildrenGridList extends StatelessWidget {
  const _ChildrenGridList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        final children = state.children;

        return SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
          ),
          itemCount: children?.length ?? 0,
          itemBuilder: (context, index) {
            final child = children?[index];

            if (child == null) {
              return const SizedBox.shrink();
            }

            return Stack(
              children: [
                _ResultListTile(
                  title: child.title,
                  subtitle: child.subtitle,
                  margin: allPadding12,
                  internalPadding: allPadding8,
                ),
                if (state.isEditingMode)
                  Positioned(
                    top: 4,
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
            );
          },
        );
      },
    );
  }
}
