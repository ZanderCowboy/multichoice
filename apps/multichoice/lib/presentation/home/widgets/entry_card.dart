part of '../home_page.dart';

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final EntryDTO entry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return GestureDetector(
          onLongPress: () {
            CustomDialog<AlertDialog>.show(
              context: context,
              title: Text('delete ${entry.title}'),
              content: Text(
                "Are you sure you want to delete ${entry.title} and all it's data?",
              ),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(
                          HomeEvent.onLongPressedDeleteEntry(
                            entry.tabId,
                            entry.id,
                          ),
                        );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
          child: Card(
            elevation: 5,
            shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: circularBorder5,
            ),
            color: Colors.blueGrey,
            child: Padding(
              padding: allPadding4,
              child: Column(
                children: [
                  Text(entry.title),
                  Text(entry.subtitle),
                  Text('t-id: ${entry.tabId}'),
                  gap4,
                  Text('e-id: ${entry.id}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
