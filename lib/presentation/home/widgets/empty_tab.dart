part of '../home_page.dart';

class EmptyTab extends StatelessWidget {
  const EmptyTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final tabCount = state.tabs?.length ?? 0;

        return GestureDetector(
          onTap: () {
            showDialog<AlertDialog>(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Add New Tab'),
                  content: const Text('TODO: Add FormFields to enter data.'),
                  actions: <Widget>[
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                              HomeEvent.onPressedAddTab(
                                't-title $tabCount',
                                't-s.title $tabCount',
                              ),
                            );
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              },
            );

            // CustomDialog<Widget>.show(
            //   context: context,
            //   title: const Text('Add New Tab'),
            //   content: const Text('TODO: Add FormFields to enter data.'),
            //   actions: <Widget>[
            //     OutlinedButton(
            //       onPressed: () => Navigator.of(context).pop(),
            //       child: const Text('Cancel'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         context.read<HomeBloc>().add(
            //               HomeEvent.onPressedAddTab(
            //                 't-title $tabCount',
            //                 't-s.title $tabCount',
            //               ),
            //             );
            //         if (Navigator.canPop(context)) {
            //           Navigator.of(context).pop();
            //         }
            //       },
            //       child: const Text('Add'),
            //     ),
            //   ],
            // );
          },
          child: AddTabCard(
            width: MediaQuery.sizeOf(context).width / 4,
          ),
        );
      },
    );
  }
}
