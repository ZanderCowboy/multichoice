part of '../home_page.dart';

class _NewTab extends StatelessWidget {
  const _NewTab();

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subtitleTextController = TextEditingController();

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();
        return AddTabCard(
          width: MediaQuery.sizeOf(context).width / 4,
          onPressed: () {
            CustomDialog<AlertDialog>.show(
              context: context,
              title: const Text('Add New Tab'),
              content: BlocProvider.value(
                value: homeBloc,
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleTextController,
                            onChanged: (value) => context
                                .read<HomeBloc>()
                                .add(HomeEvent.onChangedTabTitle(value)),
                            decoration: const InputDecoration(
                              labelText: 'Enter a Title',
                              hintText: 'Title',
                            ),
                          ),
                          TextFormField(
                            controller: subtitleTextController,
                            onChanged: (value) => context
                                .read<HomeBloc>()
                                .add(HomeEvent.onChangedTabSubtitle(value)),
                            decoration: const InputDecoration(
                              labelText: 'Enter a Subtitle',
                              hintText: 'Subtitle',
                            ),
                          ),
                          gap24,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  context.read<HomeBloc>().add(
                                        const HomeEvent.onPressedCancel(),
                                      );
                                  Navigator.of(context).pop();
                                  titleTextController.clear();
                                  subtitleTextController.clear();
                                },
                                child: const Text('Cancel'),
                              ),
                              gap4,
                              ElevatedButton(
                                onPressed: state.isValid &&
                                        state.tab.title.isNotEmpty
                                    ? () {
                                        context.read<HomeBloc>().add(
                                              const HomeEvent.onPressedAddTab(),
                                            );
                                        Navigator.of(context).pop();
                                        titleTextController.clear();
                                        subtitleTextController.clear();
                                      }
                                    : null,
                                child: const Text('Add'),
                              ),
                            ],
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
    );
  }
}
