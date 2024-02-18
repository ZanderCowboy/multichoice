part of '../home_page.dart';

class VerticalTab extends StatelessWidget {
  const VerticalTab({
    required this.tabId,
    super.key,
  });

  final int tabId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          coreSl<HomeBloc>()..add(HomeEvent.onGetEntryCards(tabId)),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return GestureDetector(
            onLongPress: () {
              CustomDialog<Widget>.show(
                context: context,
                title: Text('Delete ${state.tab.title}?'),
                content: SizedBox(
                  height: 20,
                  child: Text(
                    "Are you sure you want to delete tab ${state.tab.title} and all it's entries?",
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      gap10,
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<HomeBloc>()
                              .add(HomeEvent.onLongPressedDeleteTab(tabId));

                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
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
                  padding: allPadding6,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width / 4,
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
                            const IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.minor_crash_rounded,
                                color: Colors.black,
                              ),
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
                        Cards(tabId: tabId),
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
