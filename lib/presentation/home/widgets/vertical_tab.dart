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
        builder: (context, state) {
          return GestureDetector(
            onLongPress: () {
              show<AlertDialog>(context, homeBloc, id);
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
                            MenuWidget(homeBloc: homeBloc, id: id),
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
                        Cards(tabId: id),
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
