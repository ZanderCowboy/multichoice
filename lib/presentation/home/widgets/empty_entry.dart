part of '../home_page.dart';

class EmptyEntry extends HookWidget {
  const EmptyEntry({
    required this.tabId,
    super.key,
  });

  final int tabId;

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
            return BlocProvider.value(
              value: homeBloc,
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return AlertDialog(
                    title: Text('Add new entry to ${state.tab.title}'),
                    content: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleTextController,
                            onChanged: (value) {
                              context.read<HomeBloc>().add(
                                    HomeEvent.onChangedEntryTitle(value),
                                  );
                            },
                            decoration: const InputDecoration(
                              labelText: 'Enter a Title',
                              hintText: 'Title',
                            ),
                          ),
                          TextFormField(
                            controller: subtitleTextController,
                            onChanged: (value) {
                              context.read<HomeBloc>().add(
                                    HomeEvent.onChangedEntrySubtitle(
                                      value,
                                    ),
                                  );
                            },
                            decoration: const InputDecoration(
                              labelText: 'Enter a Subtitle',
                              hintText: 'Subtitle',
                            ),
                          ),
                          gap10,
                          Padding(
                            padding: top12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    context.read<HomeBloc>().add(
                                          const HomeEvent
                                              .onPressedCancelEntry(),
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
                                          state.entry.title.isNotEmpty
                                      ? () {
                                          context.read<HomeBloc>().add(
                                                const HomeEvent
                                                    .onPressedAddEntry(
                                                    // tabId,
                                                    ),
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
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      child: const AddEntryCard(),
    );
  }
}
