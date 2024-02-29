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
              // showDialog<AlertDialog>(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return BlocProvider<HomeBloc>.value(
              //       value: homeBloc..add(HomeEvent.onUpdateTab(id)),
              //       child: BlocBuilder<HomeBloc, HomeState>(
              //         builder: (context, state) {
              //           return AlertDialog(
              //             title: Text('Delete ${state.tab.title}?'),
              //             content: SizedBox(
              //               height: 20,
              //               child: Text(
              //                 "Are you sure you want to delete tab ${state.tab.title} and all it's entries?",
              //               ),
              //             ),
              //             actions: <Widget>[
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   OutlinedButton(
              //                     onPressed: () => Navigator.of(context).pop(),
              //                     child: const Text('Cancel'),
              //                   ),
              //                   gap10,
              //                   ElevatedButton(
              //                     onPressed: () {
              //                       context.read<HomeBloc>()
              //                         ..add(
              //                           HomeEvent.onLongPressedDeleteTab(id),
              //                         )
              //                         ..add(const HomeEvent.onGetTabs());

              //                       if (Navigator.canPop(context)) {
              //                         Navigator.of(context).pop();
              //                       }
              //                     },
              //                     child: const Text('Delete'),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           );
              //         },
              //       ),
              //     );
              //   },
              // );
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
                            MenuAnchor(
                              consumeOutsideTap: true,
                              builder: (
                                BuildContext context,
                                MenuController controller,
                                Widget? child,
                              ) {
                                return IconButton(
                                  onPressed: () {
                                    if (controller.isOpen) {
                                      controller.close();
                                    } else {
                                      controller.open();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.more_vert_outlined,
                                  ),
                                  hoverColor: Colors.pink,
                                  padding: EdgeInsets.zero,
                                );
                              },
                              menuChildren: [
                                MenuItemButton(
                                  onPressed: () => {
                                    context.router
                                        .push(EditPageRoute(ctx: context)),
                                  },
                                  child: Text(MenuItems.edit.name),
                                ),
                                MenuItemButton(
                                  onPressed: () {
                                    // homeBloc.add(
                                    //   HomeEvent.onLongPressedDeleteTab(id),
                                    // );
                                    show<AlertDialog>(
                                      context,
                                      homeBloc,
                                      id,
                                    );
                                  },
                                  child: Text(MenuItems.delete.name),
                                ),
                              ],
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
