part of '../home_page.dart';

class _NewEntry extends HookWidget {
  const _NewEntry({
    required this.tabId,
    required this.entryCount,
  });

  final int tabId;
  final int entryCount;

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subtitleTextController = TextEditingController();

    return BlocProvider(
      create: (context) =>
          context.read<HomeBloc>()..add(HomeEvent.onGetTab(tabId)),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final homeBloc = context.read<HomeBloc>();
          return AddEntryCard(
            padding: allPadding6,
            onPressed: () {
              CustomDialog<AlertDialog>.show(
                context: context,
                title: Text('Add new entry to ${state.tab.title}'),
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
                              onChanged: (value) =>
                                  context.read<HomeBloc>().add(
                                        HomeEvent.onChangedEntryTitle(value),
                                      ),
                              onTap: () => context
                                  .read<HomeBloc>()
                                  .add(HomeEvent.onGetTab(tabId)),
                              decoration: const InputDecoration(
                                labelText: 'Enter a Title',
                                hintText: 'Title',
                              ),
                            ),
                            TextFormField(
                              controller: subtitleTextController,
                              onChanged: (value) =>
                                  context.read<HomeBloc>().add(
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
                                          const HomeEvent.onPressedCancelTab(),
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
      ),
    );
  }
}
