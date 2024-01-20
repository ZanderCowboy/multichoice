part of '../home_page.dart';

class VerticalTab extends StatelessWidget {
  const VerticalTab({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    // final tab = context.read<TabsRepository>();

    return RepositoryProvider(
      create: (_) => EntryRepository(),
      child: BlocProvider(
        create: (_) => coreSl<EntryBloc>(),
        child: GestureDetector(
          onLongPress: () {
            CustomDialog.show(
              context: context,
              title: const Text('delete'),
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
                        context.read<HomeBloc>().add(
                              HomeEvent.onLongPressedDeleteTab(
                                VerticalTab(
                                  title: title,
                                  subtitle: subtitle,
                                ),
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                )
              ],
            );
          },
          child: BlocConsumer<EntryBloc, EntryState>(
            listener: (context, state) {
              if (state.isLoading) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('loading entry...'),
                    ),
                  );
              }
              if (state.isAdded) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('added entry...'),
                    ),
                  );
              }
              if (state.isDeleted) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('deleted entry...'),
                    ),
                  );
              }
            },
            builder: (context, state) {
              final tab = context.read<TabsRepository>().readTabs().first;

              final entriesInTab =
                  context.read<EntryRepository>().readEntries(0, tab);

              return Card(
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
                            Expanded(child: Text(title)),
                            const IconButton(
                              onPressed: null,
                              icon: Icon(Icons.minor_crash_rounded),
                            ),
                          ],
                        ),
                        gap10,
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: CustomScrollBehaviour(),
                            child: ListView.builder(
                              controller: scrollController,
                              scrollDirection: Axis.vertical,
                              itemCount: entriesInTab!.length + 1,
                              itemBuilder: (context, index) {
                                if (index == entriesInTab.length) {
                                  return const EmptyEntry();
                                } else {
                                  return entriesInTab[index];
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
