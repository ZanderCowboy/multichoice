part of '../home_page.dart';

class _NewEntry extends StatelessWidget {
  const _NewEntry({
    required this.tabId,
  });

  final int tabId;

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subtitleTextController = TextEditingController();

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();
        return AddEntryCard(
          padding: allPadding6,
          onPressed: () {
            CustomDialog<AlertDialog>.show(
              context: context,
              title: RichText(
                text: TextSpan(
                  text: 'Add New Entry',
                  style:
                      DefaultTextStyle.of(context).style.copyWith(fontSize: 24),
                ),
              ),
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
                            onChanged: (value) => context.read<HomeBloc>().add(
                                  HomeEvent.onChangedEntryTitle(value),
                                ),
                            onTap: () => context.read<HomeBloc>()
                              ..add(HomeEvent.onGetTab(tabId)),
                            decoration: const InputDecoration(
                              labelText: 'Enter a Title',
                              hintText: 'Title',
                            ),
                          ),
                          TextFormField(
                            controller: subtitleTextController,
                            onChanged: (value) => context.read<HomeBloc>().add(
                                  HomeEvent.onChangedEntrySubtitle(
                                    value,
                                  ),
                                ),
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
                                        state.entry.title.isNotEmpty
                                    ? () {
                                        context.read<HomeBloc>().add(
                                              const HomeEvent
                                                  .onPressedAddEntry(),
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
