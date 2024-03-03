part of '../home_page.dart';

class VerticalTab extends StatelessWidget {
  const VerticalTab({
    required this.id,
    super.key,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();

    return BlocProvider(
      create: (_) => coreSl<HomeBloc>()..add(HomeEvent.onGetEntryCards(id)),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (ctx, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          return GestureDetector(
            onLongPress: () {
              showDialog<AlertDialog>(
                context: ctx,
                builder: (_) {
                  return BlocProvider<HomeBloc>.value(
                    value: homeBloc..add(HomeEvent.onUpdateTab(id)),
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (ctx, state) {
                        return AlertDialog(
                          title: Text('Delete ${state.tab.title}?'),
                          content: Text(
                            "Are you sure you want to delete tab ${state.tab.title} and all it's entries?",
                          ),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('Cancel'),
                                ),
                                gap10,
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<HomeBloc>().add(
                                          HomeEvent.onLongPressedDeleteTab(id),
                                        );

                                    if (Navigator.canPop(ctx)) {
                                      Navigator.of(ctx).pop();
                                    }
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: right4,
              child: Card(
                color: Colors.blueGrey[200],
                elevation: 5,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: circularBorder12,
                ),
                child: Padding(
                  padding: allPadding4,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(ctx).width / 4,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: left4,
                                child: Text(
                                  state.tab.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            MenuWidget(
                              ctx: context,
                              homeBloc: homeBloc,
                              id: id,
                            ),
                          ],
                        ),
                        const Divider(
                          indent: 4,
                          endIndent: 4,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: left4,
                                child: Text(
                                  state.tab.subtitle,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        gap10,
                        const Cards(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
