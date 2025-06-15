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

        return Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              crossAxisSpacing: 5,
              mainAxisSpacing: 1,
            ),
            itemCount: children?.length ?? 0,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final child = children?[index];

              return Card(
                color: Colors.blue,
                child: GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          child?.title ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        if (child?.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            child!.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
