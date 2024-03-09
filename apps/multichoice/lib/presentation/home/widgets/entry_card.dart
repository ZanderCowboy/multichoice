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
            elevation: 7,
            shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: circularBorder5,
            ),
            color: const Color.fromARGB(255, 81, 153, 187),
            child: Padding(
              padding: allPadding4,
              child: Column(
                children: [
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    entry.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
