part of '../home_page.dart';

class _EmptyTab extends HookWidget {
  const _EmptyTab();

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subtitleTextController = TextEditingController();
    final homeBloc = context.read<HomeBloc>();

    return GestureDetector(
      onTap: () {
        showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            return BlocProvider<HomeBloc>.value(
              value: homeBloc,
              child: AlertDialog(
                title: const Text('Add new tab'),
                content: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Text('Title'),
                              ),
                              gap4,
                              Expanded(
                                child: TextFormField(
                                  controller: titleTextController,
                                  onChanged: (value) {
                                    context.read<HomeBloc>().add(
                                          HomeEvent.onChangedTabTitle(value),
                                        );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Text('Subtitle'),
                              ),
                              gap4,
                              Expanded(
                                child: TextFormField(
                                  controller: subtitleTextController,
                                  onChanged: (value) {
                                    context.read<HomeBloc>().add(
                                          HomeEvent.onChangedTabSubtitle(value),
                                        );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: top12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    context.read<HomeBloc>().add(
                                          const HomeEvent.onPressedCancelTab(),
                                        );
                                    titleTextController.clear();
                                    subtitleTextController.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                gap4,
                                ElevatedButton(
                                  onPressed: state.isValid &&
                                          state.tab.title.isNotEmpty
                                      ? () {
                                          context.read<HomeBloc>().add(
                                                const HomeEvent
                                                    .onPressedAddTab(),
                                              );

                                          titleTextController.clear();
                                          subtitleTextController.clear();

                                          if (Navigator.canPop(context)) {
                                            Navigator.of(context).pop();
                                          }
                                        }
                                      : null,
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      child: AddTabCard(
        width: MediaQuery.sizeOf(context).width / 4,
      ),
    );
  }
}
